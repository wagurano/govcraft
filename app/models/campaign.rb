class Campaign < ApplicationRecord
  belongs_to :user
  has_many :petitions
end
