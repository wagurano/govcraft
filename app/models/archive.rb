class Archive < ApplicationRecord
  belongs_to :user
  has_many :documents, class_name: 'ArchiveDocument'
  has_many :comments, as: :commentable
  has_many :likes, as: :likable

  mount_uploader :image, ImageUploader
end
