class Statement < ApplicationRecord
  belongs_to :agent
  belongs_to :statementable, polymorphic: true, optional: true
  belongs_to :last_updated_user, optional: true, class_name: User
  has_many :statement_keys

  extend Enumerize
  enumerize :stance, in: %i(agree disagree hold)

  scope :recent, -> { order('updated_at DESC').order('id DESC') }
  scope :responed_body, -> { where('body is not null') }
  scope :responed_stance_only, -> { where.not(stance: nil).where.not(stance: "") }
  scope :responed_body_only, -> { where.not(body: nil).where.not(body: "") }
  scope :responed_only, -> { responed_stance_only.or(Statement.responed_body_only) }
  scope :agreed, -> { where(stance: :agree) }
  scope :disagreed, -> { where(stance: :disagree) }
  scope :sure, -> { where.any_of(Statement.agreed, Statement.disagreed) }

  def is_responed?
    stance.present? or body.present?
  end

  def sure?
    stance.try(:agree?) or stance.try(:disagree?)
  end

  def unsure?
    !sure?
  end

  def valid_key? key
    statement_keys.exists?(key: key) and !statement_keys.find_by(key: key).expired?
  end
end
