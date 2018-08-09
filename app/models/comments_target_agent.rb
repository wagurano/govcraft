class CommentsTargetAgent < ApplicationRecord
  belongs_to :comment
  belongs_to :agent
end
