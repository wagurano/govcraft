class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true,counter_cache: true
  belongs_to :user
  validates :user, uniqueness: { scope: [:reportable_id, :reportable_type ]}
end
