class BulkTasksController < ApplicationController
  load_and_authorize_resource :archive
  load_and_authorize_resource :bulk_task, through: :archive, shallow: true

  def index
    @bulk_tasks = BulkTask.page(params[:page]).recent
  end

  def create
    @bulk_task = BulkTask.new(bulk_task_params)
    @bulk_task.user = current_user
    @bulk_task.archive = @archive
    if @bulk_task.save
      credentials = init_credentials(@bulk_task)
      redirect_to credentials.authorization_uri.to_s
    else
      errors_to_flash(@bulk_task)
      redirect_back(fallback_location: archive_bulk_tasks_path(@archive))
    end
  end

  def attachment
    @bulk_task = BulkTask.find params[:id]
    if @bulk_task.attachment.file.respond_to?(:url)
      # s3
      data = open @bulk_task.attachment.url
      send_data data.read, filename: encoded_file_name(@bulk_task), disposition: 'attachment', stream: 'true', buffer_size: '4096'
    else
      # local storage
      send_file(@bulk_task.attachment.path, filename: encoded_file_name(@bulk_task), disposition: 'attachment')
    end
  end

  def start
    @bulk_task = BulkTask.find params[:state]
    @archive = @bulk_task.archive
    credentials = init_credentials(@bulk_task)
    credentials.code = params[:code]
    credentials.fetch_access_token!

    @bulk_task.update_attributes(
      google_access_token: credentials.access_token,
      google_refresh_token: credentials.refresh_token)

    job_id = BulkTaskJob.perform_async(@bulk_task.id)
    @bulk_task.update_attributes(job_id: job_id)
    redirect_to archive_bulk_tasks_path(@archive)
  end

  private

  def init_credentials(bulk_task)
    Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      scope: [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/",
      ],
      state: bulk_task.id,
      redirect_uri: start_bulk_task_url)
  end

  def bulk_task_params
    params.require(:bulk_task).permit(:desc, :attachment)
  end

  def encoded_file_name file_source
    filename = file_source.valid_name
    if browser.ie?
      filename = URI::encode(filename)
    elsif ENV['FILENAME_ENCODING'].present?
      filename = filename.encode('UTF-8', ENV['FILENAME_ENCODING'], invalid: :replace, undef: :replace, replace: '?')
    end
    filename
  end
end
