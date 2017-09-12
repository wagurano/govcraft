class Statement < ApplicationRecord
  belongs_to :speaker
  belongs_to :petition
  has_many :statement_keys

  extend Enumerize
  enumerize :stance, in: %i(agree disagree hold)

  scope :recent, -> { order('updated_at DESC').order('id DESC') }
  scope :speaker_by, ->(speaker) { find_by(speaker: speaker) }
  scope :responed_body, -> { where('body is not null') }

  def is_responed?
    stance.present? or body.present?
  end

  def valid_key? key
    statement_keys.exists?(key: key) and !statement_keys.find_by(key: key).expired?
  end
end
