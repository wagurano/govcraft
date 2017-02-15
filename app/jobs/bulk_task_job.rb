require 'json'

class BulkTaskJob
  include Sidekiq::Worker

  def perform(task_id)
    begin
      # do something dodgy
      @bulk_task = BulkTask.find_by(id: task_id)
      return if @bulk_task.blank?

      @bulk_task.update_attributes(status: '시작')

      current_index = 0
      success_count = 0
      updated_count = 0
      inserted_count = 0
      errors = {}

      attributes = ArchiveDocument::XLXS_META

      if @bulk_task.attachment.blank?
        @bulk_task.update_attributes(
          error_detail: '업로드된 파일 없음'
        )
        return
      end

      xlsx = Roo::Spreadsheet.open @bulk_task.attachment.file.respond_to?(:url) ? @bulk_task.attachment.url : @bulk_task.attachment.file
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        id = fetch_data(row, attributes, :id)
        break if 'END' == id

        id = id.try(:to_i)

        current_index += 1
        is_success = false

        content_created_date = fetch_data(row, attributes, :content_created_date).try(:to_date)

        row_data = fetch_data_all(row, attributes,
          %i(title body content_creator content_created_time content_source remote_content_url category_slug)).merge(
          is_secret_content_source: (fetch_data(row, attributes, :is_secret_content_source) == '예'),
          content_created_date: content_created_date)
        if id == 0 or id.blank?
          document = @bulk_task.archive.documents.create!(row_data.merge(user: @bulk_task.user))
          if document.errors.empty?
            is_success = true
            inserted_count += 1
          end
        else
          document = @bulk_task.archive.documents.find_by(id: id)
          if document.blank?
            errors[current_index] = '해당 자료 없음'
            next
          end

          is_success = document.update_attributes(row_data)
          if document.previous_changes.any?
            updated_count += 1
          end
        end

        if is_success
          success_count += 1
        else
          errors[current_index] = document.errors.full_messages
        end

        if (current_index % 1000.0) == 0
          @bulk_task.update_attributes(
            processing_count: current_index,
            success_count: success_count,
            inserted_count: inserted_count,
            updated_count: updated_count,
            error_count: errors.count)
        end
      end

      @bulk_task.update_attributes(
        processing_count: current_index,
        success_count: success_count,
        inserted_count: inserted_count,
        updated_count: updated_count,
        error_count: errors.count,
        error_detail: (errors.to_json if errors.any?)
      )
      @bulk_task.update_attributes(status: '완료')
    rescue => e # StandardError
      @bulk_task.update_attributes(status: '실패')
      raise e
    rescue Exception => e
      @bulk_task.update_attributes(status: '실패')
      raise e
    end
  end

  def fetch_data(row, attributes, name)
    row[attributes.index(name)].try(:value)
  end

  def fetch_data_all(row, attributes, names)
    Hash[names.map { |name| [name, fetch_data(row, attributes, name)] }]
  end

  def parse_colon_time(value)
    value = value.try(:strip)
    return [nil, nil, nil] if value.blank?

    splits = value.split(':')
    hour = splits[0].to_i if splits[0] !~ /\D/
    min = splits[1].to_i if splits[1] !~ /\D/
    sec = splits[2].to_i if splits[2] !~ /\D/

    [hour, min || 0, sec || 0]
  end
end
