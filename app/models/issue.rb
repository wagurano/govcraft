class Issue < ApplicationRecord
  has_many :following_issues
  has_many :followers, -> { order 'following_issues.created_at' }, through: :following_issues, source: :user
  has_many :comments, as: :commentable

  validates :title, uniqueness: true, presence: true

  after_initialize :trim_title

  default_scope { order('title ASC') }

  private

  def trim_title
    self.title.try(:strip!)
  end
end
