class Timeline < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :documents, class_name: 'TimelineDocument'
  has_many :comments, as: :commentable

  mount_uploader :image, ImageUploader
  mount_uploader :banner_image, ImageUploader

  scope :recent, -> { order('id DESC') }

  def contributors
    documents.collect{|d| d.user}.uniq
  end
end
