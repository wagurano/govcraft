class Option < ApplicationRecord
  belongs_to :survey
  has_many :feedbacks, dependent: :destroy

  def selected? someone
    feedbacks.exists? user: someone
  end
end
