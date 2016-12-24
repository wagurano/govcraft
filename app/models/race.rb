class Race < ApplicationRecord
  belongs_to :user
  has_many :players, dependent: :destroy
  has_many :thumb_stats, dependent: :destroy

  validates :title, presence: true

  scope :recent, -> { order('id DESC') }

  def thumbs_updown_count
    players.sum(:thumbs_up_count) + players.sum(:thumbs_down_count)
  end
end
