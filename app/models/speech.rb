class Speech < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :petition

  paginates_per 4 * 8

  scope :recent, -> { order('id DESC') }

  def view_count_cacheable
    if (self.view_count_cached_at.blank? || self.view_count_cached_at < 12.hours.ago) and self.is_expired_view_count == false
      update_columns(is_expired_view_count: true)
    end

    self.cached_view_count
  end
end
