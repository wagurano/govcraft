class IssueMailing < ApplicationRecord
  belongs_to :issue
  belongs_to :source, polymorphic: true
end
