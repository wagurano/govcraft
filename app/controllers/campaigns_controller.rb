class CampaignsController < ApplicationController
  include OrganizationHelper
  include Statementing

  load_and_authorize_resource
  before_action :reset_meta_tags_for_show, only: :show
  before_action :verify_organization

  def index
    @campaigns = Campaign.recent
    @current_organization = fetch_organization_from_request
    @campaigns = @campaigns.by_organization(@current_organization) if @current_organization.present?
  end

  def show
    @project = @campaign.project
    @campaign.increment!(:views_count)
    @signs = @campaign.signs.where.any_of(*([Sign.where.not(body: nil).where.not(body: ''), (Sign.where(user: current_user) if current_user.present?)].compact)).recent
    @signs = params[:mode] == 'widget' ? @signs.limit(10) : @signs.page(params[:page])

    if @campaign.template != 'petition'
      @comments = params[:tag].present? ? @campaign.comments.tagged_with(params[:tag]) : @campaign.comments
      @comments = params[:toxic].present? ? @comments.where(toxic: true) : @comments.where(toxic: false)
      @comments = @comments.order('id DESC')
      @comments = @comments.page(params[:page]).per 50
    end

    if @campaign.template == 'special_speech'
      @speeches = @campaign.speeches.recent.limit(browser.device.mobile? ? 4 : 8)
      @hero_speech = @campaign.speeches.sample
    end

    if params[:mode] == 'widget'
      render '_widget', layout: 'strip'
    end
  end

  def data
  end

  def new
    render 'new_no_template' and return if params[:template].blank?

    @project = Project.find(params[:project_id]) if params[:project_id].present?
    @current_organization = @project.organization if @project.present?
    @campaign.template = params[:template]
  end

  def create
    @campaign.user = current_user
    if @campaign.special_slug.present?
      Special.build_campaign @campaign
    end

    if params[:action_assignable_id].present? and params[:action_assignable_type].present?
      action_assignable_model = params[:action_assignable_type].classify.safe_constantize
      render_404 and return if action_assignable_model.blank?
      action_assignable = action_assignable_model.find_by(id: params[:action_assignable_id])
      render_404 and return if action_assignable.blank?

      @campaign.action_targets.build(action_assignable: action_assignable)
    end

    if @campaign.save
      redirect_to @campaign || @project
    else
      render 'new'
    end
  end

  def edit
    @project = @campaign.project
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign
    else
      render 'edit'
    end
  end

  def destroy
    @campaign.destroy
    redirect_to @campaign.project ? project_path(@campaign.project) : campaigns_path
  end

  def open
    @campaign.update_attributes(closed_at: nil)
    flash[:success] = t('messages.campaigns.open')
    redirect_to @campaign
  end

  def close
    @campaign.touch(:closed_at)
    flash[:success] = t('messages.campaigns.close')
    redirect_to @campaign
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :body, :project_id, :signs_goal_count, :cover_image, :thanks_mention,
      :comment_enabled, :sign_title, :social_image, :confirm_privacy,
      :use_signer_email, :use_signer_address, :use_signer_real_name, :use_signer_phone,
      :signer_email_title, :signer_address_title, :signer_real_name_title, :signer_phone_title,
      :agent_section_title, :agent_section_response_title, :sign_hidden, :area_id, :issue_id,
      :special_slug, :sign_form_intro, (:template if params[:action] == 'create'), :slug, :title_to_agent, :message_to_agent)
  end

  def reset_meta_tags_for_show
    prepare_meta_tags({
      site_name: ("#{@campaign.project.title} - #{@campaign.project.user.nickname}" if @campaign.project.present?),
      title: "[서명] " + @campaign.title,
      description: @campaign.body.html_safe,
      image: (view_context.image_url(@campaign.fallback_social_image_url) if @campaign.fallback_social_image_url),
      url: request.original_url}
    )
  end

  def current_organization
    if @campaign.present? and @campaign.persisted?
      @campaign.project.try(:organization)
    else
      fetch_organization_from_request
    end
  end

  # for Statementing
  def fetch_statementable
    @campaign
  end
end
