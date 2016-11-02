class ArchiveDocument < ApplicationRecord
  belongs_to :user
  belongs_to :archive
  has_many :comments, as: :commentable
  has_many :likes, as: :likable

  default_scope { order('date DESC, time DESC') }

  scope :recent, -> { order('id DESC') }
end
