class Order < ApplicationRecord
  belongs_to :comment
  belongs_to :agent

  scope :all_read, -> { where.not(read_at: nil) }

  def read?
    self.read_at.present?
  end
end
