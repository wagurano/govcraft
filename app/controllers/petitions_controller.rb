class PetitionsController < ApplicationController
  include OrganizationHelper
  include Statementing

  load_and_authorize_resource
  before_action :reset_meta_tags_for_show, only: :show
  before_action :verify_organization

  def index
    @petitions = Petition.recent
    @current_organization = fetch_organization_from_request
    @petitions = @petitions.by_organization(@current_organization) if @current_organization.present?
  end

  def show
    @project = @petition.project
    @petition.increment!(:views_count)
    @signs = @petition.signs.where.any_of(*([Sign.where.not(body: nil).where.not(body: ''), (Sign.where(user: current_user) if current_user.present?)].compact)).recent
    @signs = params[:mode] == 'widget' ? @signs.limit(10) : @signs.page(params[:page])

    if @petition.template != 'petition'
      @comments = params[:tag].present? ? @petition.comments.tagged_with(params[:tag]) : @petition.comments
      @comments = params[:toxic].present? ? @comments.where(toxic: true) : @comments.where(toxic: false)
      @comments = @comments.order('id DESC')
      @comments = @comments.page(params[:page]).per 50
    end

    if @petition.template == 'special_speech'
      @speeches = @petition.speeches.recent.limit(browser.device.mobile? ? 4 : 8)
      @hero_speech = @petition.speeches.sample
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
    @petition.template = params[:template]
  end

  def create
    @petition.user = current_user
    if @petition.special_slug.present?
      Special.build_petition @petition
    end

    if params[:action_assignable_id].present? and params[:action_assignable_type].present?
      action_assignable_model = params[:action_assignable_type].classify.safe_constantize
      render_404 and return if action_assignable_model.blank?
      action_assignable = action_assignable_model.find_by(id: params[:action_assignable_id])
      render_404 and return if action_assignable.blank?

      @petition.action_targets.build(action_assignable: action_assignable)
    end

    if @petition.save
      redirect_to @petition || @project
    else
      render 'new'
    end
  end

  def edit
    @project = @petition.project
  end

  def update
    if @petition.update(petition_params)
      redirect_to @petition
    else
      render 'edit'
    end
  end

  def destroy
    @petition.destroy
    redirect_to @petition.project ? project_path(@petition.project) : petitions_path
  end

  def open
    @petition.update_attributes(closed_at: nil)
    flash[:success] = t('messages.petitions.open')
    redirect_to @petition
  end

  def close
    @petition.touch(:closed_at)
    flash[:success] = t('messages.petitions.close')
    redirect_to @petition
  end

  private

  def petition_params
    params.require(:petition).permit(:title, :body, :project_id, :signs_goal_count, :cover_image, :thanks_mention,
      :comment_enabled, :sign_title, :social_image, :confirm_privacy,
      :use_signer_email, :use_signer_address, :use_signer_real_name, :use_signer_phone,
      :signer_email_title, :signer_address_title, :signer_real_name_title, :signer_phone_title,
      :agent_section_title, :agent_section_response_title, :sign_hidden, :area_id, :issue_id,
      :special_slug, :sign_form_intro, (:template if params[:action] == 'create'), :slug, :title_to_agent, :message_to_agent)
  end

  def reset_meta_tags_for_show
    prepare_meta_tags({
      site_name: ("#{@petition.project.title} - #{@petition.project.user.nickname}" if @petition.project.present?),
      title: "[서명] " + @petition.title,
      description: @petition.body.html_safe,
      image: (view_context.image_url(@petition.fallback_social_image_url) if @petition.fallback_social_image_url),
      url: request.original_url}
    )
  end

  def current_organization
    if @petition.present? and @petition.persisted?
      @petition.project.try(:organization)
    else
      fetch_organization_from_request
    end
  end

  # for Statementing
  def fetch_statementable
    @petition
  end
end
