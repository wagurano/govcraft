class Agenda < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :comments, as: :commentable
end
