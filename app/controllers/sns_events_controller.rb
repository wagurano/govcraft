class SnsEventsController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource
  before_action :verify_organization

  def new_or_edit
    @event = Event.find(params[:event_id])
    if @event.sns_event.blank?
      @sns_event = @event.build_sns_event
    else
      @sns_event = @event.sns_event
    end
  end

  def create
    @event = @sns_event.event
    if @sns_event.save
      redirect_to @sns_event.event
    else
      render 'new_or_edit'
    end
  end

  def update
    @event = @sns_event.event
    if @sns_event.update(sns_event_params)
      redirect_to @sns_event.event
    else
      render 'new_or_edit'
    end
  end

  private

  def sns_event_params
    params.require(:sns_event).permit!
  end

  def current_organization
    if @sns_event.present? and @sns_event.persisted?
      @sns_event.event.project.try(:organization)
    else
      fetch_organization_from_request
    end
  end
end
