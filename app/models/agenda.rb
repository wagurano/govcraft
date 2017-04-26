class Agenda < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :issues, dependent: :destroy
  has_many :opinions, through: :issues
  has_many :speakers, -> { reorder('').distinct }, through: :opinions
  has_many :agenda_documents, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :agenda_themes, uniq: true

  acts_as_taggable

  mount_uploader :image, ImageUploader

  scope :sort_by_name, -> { order("if(ascii(substring(name, 1)) < 128, 1, 0)").order(:name) }

  def opinions_by speaker
    opinions.where(speaker: speaker)
  end
end
