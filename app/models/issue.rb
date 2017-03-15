class Issue < ApplicationRecord
  belongs_to :agenda
  has_many :opinions, dependent: :destroy
  has_many :following_issues, dependent: :destroy
  has_many :followers, -> { order 'following_issues.created_at desc' }, through: :following_issues, source: :user
  has_many :comments, as: :commentable
  has_many :speakers, -> { reorder('').distinct }, through: :opinions

  validates :title, uniqueness: true, presence: true

  after_initialize :trim_title

  default_scope { order('title ASC') }

  def categorized_speakers(position, quote)
    if quote.present?
      opinions = self.opinions.recent.of_quote(quote).of_speaker(speakers.of_position(position))
      opinions.map &:speaker
    else
      Speaker.of_position(position).where.not(id: self.speakers)
    end
  end

  private

  def trim_title
    self.title.try(:strip!)
  end
end
