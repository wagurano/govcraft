class Option < ApplicationRecord
  belongs_to :survey
  has_many :feedbacks, dependent: :destroy

  def selected? someone
    feedbacks.exists? user: someone
  end

  def all_feedbacks_count
    feedbacks_count + anonymous_feedbacks_count
  end
end
