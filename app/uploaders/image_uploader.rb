# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def self.env_storage
    if Rails.env.production?
      :fog
    else
      :file
    end
  end

  storage env_storage

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def content_type_whitelist
    /image\//
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :xs  do
    process resize_to_fit: [80, nil]
  end

  version :sm do
    process resize_to_fit: [200, nil]
  end

  version :md do
    process resize_to_fit: [400, nil]
  end

  version :lg do
    process resize_to_fit: [700, nil]
  end

  def default_url
    ActionController::Base.helpers.asset_path('default-image.png')
  end

  # def url(version = nil)
  #   super_result = super(version)
  #   if Rails.env.production?
  #     super_result
  #   elsif self.file.try(:exists?)
  #     if ImageUploader::env_storage == :fog
  #       super_result
  #     else
  #       super_result = "http://#{ENV["HOST"]}#{super_result}" if ENV["HOST"].present?
  #       super_result
  #     end
  #   else
  #     if ImageUploader::env_storage == :fog
  #       "https://curry-file.s3.amazonaws.com#{self.path}"
  #     else
  #       "https://curry-file.s3.amazonaws.com#{super_result}"
  #     end
  #   end
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
