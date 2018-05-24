class ActionTarget < ApplicationRecord
  belongs_to :action_targetable, polymorphic: true
  belongs_to :action_assignable, polymorphic: true, foreign_key: :action_assignable_slug
end
