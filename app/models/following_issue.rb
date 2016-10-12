class FollowingIssue < ApplicationRecord
  belongs_to :user
  belongs_to :issue, counter_cache: true

  validates :user, uniqueness: { scope: :issue }

  attr_accessor :issue_title
end
