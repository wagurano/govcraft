class ThumbsController < ApplicationController
  load_and_authorize_resource

  def create
    @thumbable = @thumb.thumbable

    thumb = @thumbable.thumbed_by current_user
    if thumb.present?
      @thumb = thumb
      @thumb.assign_attributes(thumb_params)
    end
    @thumb.user = current_user

    ActiveRecord::Base.transaction do
      if @thumb.save
        if @thumb.direction_previously_changed? and @thumb.direction_previous_change[0].present?
          @thumbable.decrement("thumbs_#{@thumb.direction_previous_change[0]}_count")
        end
        @thumbable.increment("thumbs_#{@thumb.direction}_count")
        @thumbable.save
      else
        errors_to_flash(@thumb)
      end
    end
  end

  private

  def thumb_params
    params.require(:thumb).permit(:thumbable_type, :thumbable_id, :direction)
  end
end
