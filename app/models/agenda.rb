class Agenda < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :issues
  has_many :comments, as: :commentable
end
