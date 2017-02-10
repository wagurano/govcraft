class ArchiveDocument < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :archive
  has_many :comments, as: :commentable

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  mount_uploader :image, ImageUploader

  default_scope { order('date DESC, time DESC, id DESC') }

  scope :recent, -> { order('id DESC') }

  def source_url_as_array
    source_url.split
  end
end
