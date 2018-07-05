class ActionTarget < ApplicationRecord
  belongs_to :action_targetable, polymorphic: true
  belongs_to :action_assignable, polymorphic: true

  scope :with_action_targetable_type, ->(action_targetable_type) {
    where(action_targetable_type: action_targetable_type.to_s)
  }
end
