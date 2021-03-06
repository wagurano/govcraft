class Statement < ApplicationRecord
  belongs_to :agent
  belongs_to :statementable, polymorphic: true, optional: true
  belongs_to :last_updated_user, optional: true, class_name: User
  has_many :statement_keys

  extend Enumerize
  enumerize :stance, in: %i(agree disagree hold unsure)
  validates :stance, presence: true

  scope :recent, -> { order('updated_at DESC').order('id DESC') }
  scope :responded_body, -> { where('body is not null') }
  scope :responded_stance_only, -> { where.not(stance: 'unsure') }
  scope :responded_body_only, -> { where.not(body: nil).where.not(body: "") }
  scope :responded_only, -> { responded_stance_only.or(Statement.responded_body_only) }
  scope :agreed, -> { where(stance: :agree) }
  scope :disagreed, -> { where(stance: :disagree) }
  scope :sure, -> { where.not(stance: :unsure) }

  def is_responded?
    sure? or body.present?
  end

  def sure?
    (stance.present? and !stance.unsure?)
  end

  def unsure?
    !sure?
  end

  def valid_key? key
    statement_keys.exists?(key: key) and !statement_keys.find_by(key: key).expired?
  end
end
