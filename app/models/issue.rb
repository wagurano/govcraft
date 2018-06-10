class Issue < ApplicationRecord
  has_and_belongs_to_many :agendas
  belongs_to :agenda_theme, optional: true
  has_many :opinions, dependent: :destroy
  has_many :following_issues, dependent: :destroy
  has_many :followers, -> { order 'following_issues.created_at desc' }, through: :following_issues, source: :user
  has_many :comments, as: :commentable
  has_many :speakers, -> { reorder('').distinct }, through: :opinions
  has_many :petitions, dependent: :nullify

  acts_as_taggable

  validates :title, uniqueness: true, presence: true

  after_initialize :trim_title

  default_scope { order('title ASC') }
  scope :with_theme, ->(theme) { where('agenda_theme_id': theme.id) }

  def categorized_speakers(position, quote)
    if quote.present?
      opinions = self.opinions.recent.of_quote(quote).of_speaker(speakers.of_position(position))
      opinions.map &:speaker
    else
      Speaker.of_position(position).where.not(id: self.speakers)
    end
  end

  def has_any_stances?(speakers = nil)
    return false unless has_stance?

    result = self.opinions.where.not(stance: nil)
    result = result.where(speaker_id: speakers) unless speakers.nil?

    result.exists?
  end

  def theme_name
    agenda_theme.try(:title)
  end

  def following?(someone)
    followers.exists?(id: someone)
  end

  def following_of(someone)
    following_issues.find_by(user_id: someone)
  end

  def self.group_by_theme issues
    issues.to_a.group_by{ |i| i.agenda_theme }.sort_by { |k,v| k.try(:name) }
  end

  private

  def trim_title
    self.title.try(:strip!)
  end
end
