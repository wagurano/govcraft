class Opinion < ApplicationRecord
  include Likable

  belongs_to :speaker
  belongs_to :issue

  scope :recent, -> { order('id DESC') }
end
