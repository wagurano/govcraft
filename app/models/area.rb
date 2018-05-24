class Area < ApplicationRecord
  has_many :petitions, dependent: :nullify

  scope :all_divisions, -> { where(subdivision: nil) }
  def description
    [self.division, self.subdivision, self.neighborhood].compact.join(' ')
  end
end

