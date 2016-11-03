class WikiRevision < ApplicationRecord
  belongs_to :user
  belongs_to :wiki

  scope :recent, -> { order(created_at: :desc) }

  def previous_version
    previous(field: :id, scope: ->(record){ where(discussion: record.discussion) })
  end
end
