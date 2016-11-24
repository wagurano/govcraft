class Vote < ApplicationRecord
  include Choosable

  belongs_to :user
  belongs_to :poll, counter_cache: true

  counter_culture :poll, :column_name => proc {|model| "#{model.choice}s_count" }

  validates :user, uniqueness: { scope: :poll }, if: "user.present?"

  scope :recent, -> { order('id DESC') }
end
