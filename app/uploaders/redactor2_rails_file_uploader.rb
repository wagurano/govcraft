# encoding: utf-8
class Redactor2RailsFileUploader < CarrierWave::Uploader::Base
  include Redactor2Rails::Backend::CarrierWave

  # storage :fog
  def self.env_storage
    if Rails.env.production?
      :fog
    else
      :file
    end
  end

  storage env_storage

  def store_dir
    "uploads/redactor2_assets/files/#{model.id}"
  end

  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
