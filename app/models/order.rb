class Order < ApplicationRecord
  belongs_to :comment
  belongs_to :agent
end
