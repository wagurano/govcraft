class Petition < ApplicationRecord
  include Statementable
  include Likable

  TEMPLATES = %w( default petition )

  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :signs, dependent: :destroy
  has_many :signed_users, through: :signs, source: :petition
  belongs_to :area, optional: true
  belongs_to :issue, optional: true

  mount_uploader :cover_image, ImageUploader
  mount_uploader :social_image, ImageUploader

  validates :signs_goal_count, :numericality => { :greater_than_or_equal_to => 0 }

  scope :recent, -> { order('id DESC') }
  scope :by_organization, ->(organization) { where(project: organization.projects) }
  scoped_search on: [:title]

  def signed? someone
    signs.exists?(user: someone)
  end

  def has_goal?
    signs_goal_count.present? && signs_goal_count > 0
  end

  def percentage
    has_goal? ? ( signs_count.to_f / signs_goal_count * 100 ).to_i : 100
  end

  def has_cover_image?
    cover_image.file.present?
  end

  def fallback_social_image_url
    if self.read_attribute(:social_image).present?
      self.social_image_url
    elsif self.project.try(:read_attribute, :social_image).present?
      self.project.social_image_url
    else
      self.cover_image_url
    end
  end

  def formatted_title_to_agent(user_nickname = nil)
    "서명 \"#{title}\"에 대해 #{"#{user_nickname}님이 " if user_nickname.present?}행동을 촉구합니다"
  end

  def closed?
    self.closed_at.present?
  end

  def opened?
    !closed?
  end

  def comment_closed?
    return false if self.template == 'petition'

    closed?
  end

  def comment_opened?
    !comment_closed?
  end

  def signable?
    self.template == 'petition'
  end

  def agents_orderable?
    self.template == 'petition'
  end

  def comment_disablable?
    self.template == 'petition'
  end
end
