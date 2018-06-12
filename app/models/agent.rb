class Agent < ApplicationRecord
  has_many :opinions, dependent: :destroy
  validates :name, presence: true
  mount_uploader :image, ImageUploader

  has_many :sent_requests, dependent: :destroy
  has_many :agenda_documents, dependent: :destroy
  has_many :election_candidates, dependent: :nullify
  has_and_belongs_to_many :petitions, -> { distinct }

  scope :of_position, ->(*positions) { tagged_with(positions, on: :positions) }

  acts_as_taggable_on :positions

  def details
    "#{name} - #{organization}"
  end

  def requested_by? someone
    return false if someone.blank?
    sent_requests.exists? user: someone
  end

  def has_opinion_of? agenda
    opinions.exists?(issue: agenda.issues)
  end

  def opinions_of_agenda agenda
    opinions.where(issue: agenda.issues)
  end

  def self.positions(agents)
    agents.tags_on(:positions)
  end
end

