class Campaign < ApplicationRecord
  belongs_to :user
  has_many :discussions
  has_many :petitions
end
