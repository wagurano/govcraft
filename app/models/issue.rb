class Issue < ApplicationRecord
  has_many :following_issues
  has_many :followers, -> { order 'following_issues.created_at' }, through: :following_issues, source: :user
  validates :title, uniqueness: true, presence: true

  after_initialize :trim_title

  private

  def trim_title
    self.title.try(:strip!)
  end
end
