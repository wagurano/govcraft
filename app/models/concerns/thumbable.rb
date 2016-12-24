module Thumbable
  extend ActiveSupport::Concern

  included do
    has_many :thumbs, as: :thumbable, dependent: :destroy
  end

  def thumbed? someone
    thumbs.exists(user: someone)
  end

  def thumbed_up? someone
    thumbed_by(someone).try(:direction) == 'up'
  end

  def thumbed_down? someone
    thumbed_by(someone).try(:direction) == 'down'
  end

  def thumbed_middle? someone
    thumbed_by(someone).try(:direction) == 'middle'
  end

  def thumbed_by someone
    thumbs.find_by(user: someone)
  end
end
