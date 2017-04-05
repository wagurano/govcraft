class Agenda < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :issues, dependent: :destroy
  has_many :opinions, through: :issues
  has_many :speakers, -> { reorder('').distinct }, through: :opinions
  has_many :agenda_documents, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  acts_as_taggable

  mount_uploader :image, ImageUploader

  def opinions_by speaker
    opinions.where(speaker: speaker)
  end
end
