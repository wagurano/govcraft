class Area < ApplicationRecord
  has_many :petitions, dependent: :nullify
  def description
    [self.division, self.subdivision, self.neighborhood].compact.join(' ')
  end
end

