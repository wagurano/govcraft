class Player < ApplicationRecord
  include Thumbable

  belongs_to :user
  belongs_to :person
  belongs_to :race
  has_many :thumb_stats, dependent: :destroy

  validates :person, uniqueness: { scope: :race_id }, presence: true

  def up_graph_data
    result = thumb_stats.past_month(field: :stated_at).pluck(:stated_at, :thumbs_up_count)
    result.reject! { |row| row[0] == Date.today }
    result << [Date.today, thumbs_up_count]
  end

  def down_graph_data
    result = thumb_stats.past_month(field: :stated_at).pluck(:stated_at, :thumbs_down_count).map { |row| [row[0], row[1] * -1] }
    result.reject! { |row| row[0] == Date.today }
    result << [Date.today, thumbs_down_count * -1]
  end
end
