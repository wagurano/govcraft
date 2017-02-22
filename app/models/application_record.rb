class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def google_drive_session
    return if self.try(:google_access_token).blank?
    GoogleDrive::Session.from_access_token(google_access_token)
  end
end
