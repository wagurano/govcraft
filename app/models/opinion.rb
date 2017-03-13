class Opinion < ApplicationRecord
  belongs_to :speaker
  belongs_to :issue
end
