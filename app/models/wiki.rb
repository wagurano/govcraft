class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy
  has_many :wiki_revisions, dependent: :destroy

  scope :recent, -> { order('updated_at DESC') }

  attr_accessor :revision_note
end
