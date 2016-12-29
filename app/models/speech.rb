class Speech < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :event

  paginates_per 4 * 8

  scope :recent, -> { order('id DESC') }

  def view_count
    Rails.cache.fetch("speech_#{id}/view_count", expires_in: [15, 30, 45, 60, 75, 90].sample.minutes) do
      video = VideoInfo.new(video_url)
      video.view_count
    end
  end
end
