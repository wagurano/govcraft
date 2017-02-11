class Archive < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :documents, class_name: 'ArchiveDocument', dependent: :destroy
  has_many :comments, as: :commentable

  mount_uploader :cover_image, ImageUploader
  mount_uploader :social_image, ImageUploader

  scope :recent, -> { order('id DESC') }

  def contributors
    documents.collect{|d| d.user}.uniq
  end
end
