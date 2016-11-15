class ArchiveDocument < ApplicationRecord
  belongs_to :user
  belongs_to :archive
  has_many :comments, as: :commentable
  has_many :likes, as: :likable

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  default_scope { order('date DESC, time DESC') }

  scope :recent, -> { order('id DESC') }
end
