require 'json'

class BulkTaskJob
  include Sidekiq::Worker

  def perform(task_id)
    begin
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
        temp_file = nil
        begin
          id = fetch_data(row, attributes, :id)
          break if 'END' == id
          id = id.try(:to_i)

          current_index += 1
          is_success = false

          row_data = fetch_data_all(row, attributes, ArchiveDocument::XLXS_META.reject { |a| %i(content is_secret_donor).include? a }).merge(
            is_secret_donor: (fetch_data(row, attributes, :is_secret_donor) == '예'))

          fetch_data(row, attributes, :remote_content_url)

          if id == 0 or id.blank?
            document = @bulk_task.archive.documents.build(row_data.merge(user: @bulk_task.user))
            temp_file = download_content(document, fetch_data(row, attributes, :remote_content_url))
            if document.save
              success_count += 1
              inserted_count += 1
            end
          else
            document = @bulk_task.archive.documents.find_by(id: id)
            if document.blank?
              errors[current_index] = '해당 자료 없음'
              next
            end

            document.assign_attributes(row_data)
            temp_file = download_content(document, fetch_data(row, attributes, :remote_content_url))
            if document.save
              success_count += 1
              updated_count += 1 if document.previous_changes.any?
            end
          end

          if document.errors.any?
            errors[current_index] = document.errors.full_messages
          end
        rescue => e # StandardError
          errors[current_index] = e.message
        rescue Exception => e
          errors[current_index] = e.message
        ensure
          if temp_file.present?
            temp_file.close
            temp_file.unlink
          end
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
    Hash[names.map { |name|
      value = fetch_data(row, attributes, name)
      [name, (value.is_a?(Numeric) ? value.to_i.to_s : value)]
    }]
  end

  def init_google_session(bulk_task)
    GoogleDrive::Session.from_access_token(bulk_task.google_access_token)
  end

  def download_content(document, url)
    google_session = init_google_session(@bulk_task)
    begin
      google_file = google_session.file_by_url(url)
    rescue GoogleDrive::Error
      document.remote_content_url = url
      return
    end

    temp_file = Tempfile.new(['archive', File.extname(google_file.title)])
    google_file.download_to_file(temp_file.path)

    document.content = temp_file.open
    document.content_name = google_file.title

    return temp_file
  end
end
