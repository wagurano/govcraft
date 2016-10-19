class Campaign < ApplicationRecord
  belongs_to :user
  has_many :petitions
  has_many :memorials
end
