require 'json'

class BulkTaskJob
  include Sidekiq::Worker

  def perform(task_id)
    logger.info("start job")
    begin
      100.times do
        @bulk_task = BulkTask.find_by(id: task_id)
        break if @bulk_task.present?

        logger.info("not found bulk_task. retry...")
        sleep(10)
      end

      if @bulk_task.blank?
        logger.info("not found bulk_task")
        return
      end

      @bulk_task.update_attributes(
        status: '시작',
        processing_count: 0,
        success_count: 0,
        inserted_count: 0,
        updated_count: 0,
        error_count: 0,
        error_detail: nil
      )

      upload_mode
      @bulk_task.update_attributes(status: '완료')
    rescue => e # StandardError
      @bulk_task.update_attributes(status: '실패')
      raise e
    rescue Exception => e
      @bulk_task.update_attributes(status: '실패')
      raise e
    end
  end

  def upload_mode
    if @bulk_task.attachment.blank?
      @bulk_task.update_attributes(
        error_detail: '업로드된 파일 없음'
      )
      return
    end

    xlsx = Roo::Spreadsheet.open @bulk_task.attachment.file.respond_to?(:url) ? @bulk_task.attachment.url : @bulk_task.attachment.file
    xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
      if empty_row?(row, @bulk_task.target_model)
        break
      end
      begin
        id = fetch_id(row, @bulk_task.target_model)
        return if id.blank?

        @bulk_task.processing_count += 1
        if id == 0
          model_instance = @bulk_task.target_model.new
        else
          model_instance = @bulk_task.target_model.find_by(id: id)
          if model_instance.blank?
            @bulk_task.set_current_error '해당 조직 없음'
            next
          end
        end

        process_model(row, model_instance, @bulk_task)
      ensure
        if (@bulk_task.processing_count % 1000.0) == 0
          @bulk_task.save
        end
      end
    end

    @bulk_task.serialize_error_detail
    @bulk_task.save
  end

  def process_model row, model_instance, bulk_task
    process_attributes(row, model_instance)
    unless model_instance.errors.any?
      model_instance.save
    end
    process_result(bulk_task, model_instance)
  end

  def empty_row? row, model_class
    row[0..model_class.bulk_attributes.size].all? do |cell|
      cell.nil? or cell.formatted_value.try(:strip).blank?
    end
  end

  def fetch_id(row, model_class)
    value = fetch_data(row, model_class.bulk_attributes, :id).try(:strip)
    return 0 if value.blank? or value == "0"

    i_value = value.try(:to_i)
    return i_value == 0 ? nil : i_value
  end

  def fetch_data(row, attributes, name)
    row[attributes.index(name)].try(:formatted_value)
  end

  def process_attributes(row, model_instance)
    model_instance.before_process_bulk(@bulk_task)
    model_instance.class.bulk_attributes.each do |name|
      process_method = :"process_bulk_of_#{name}"
      value = fetch_data(row, model_instance.class.bulk_attributes, name)

      if model_instance.respond_to?(process_method)
        model_instance.send(process_method, value)
      else
        model_instance.assign_attributes(name => value)
      end
    end
  end

  def process_result(bulk_task, model_instance)
    if model_instance.errors.any?
      @bulk_task.set_current_error model_instance.errors.full_messages
    else
      @bulk_task.success_count += 1
      if model_instance.previous_changes['id'].present?
        @bulk_task.inserted_count += 1
      else
        @bulk_task.updated_count += 1 if model_instance.previous_changes.any? or model_instance.has_dirty_associations
      end
    end
  end
end
