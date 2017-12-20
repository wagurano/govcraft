module Organizable
  extend ActiveSupport::Concern

  included do
    has_many :organizers, dependent: :destroy, as: :organizable
    scope :organize_by, ->(user) { where(id: Admin.where(user: user).where(organizable_type: self.class.name).select(:organizable_id)) }
  end

  def organizer? someone
    try(:user) == someone or organizers.exists?(user: someone)
  end
end
