class Agency < ApplicationRecord
  acts_as_taggable_on :positions
end
