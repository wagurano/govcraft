class PetitionsController < ApplicationController
  include OrganizationHelper
  include StatementableControlling

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

    if params[:mode] == 'widget'
      render '_widget', layout: 'strip'
    end
  end

  def data
  end

  def edit_speakers
    if params[:q].present?
      @searched_speakers = Speaker.where('name like ?', "%#{params[:q]}%")
    end

    @statementable = @petition
    render 'statementables/edit_speakers'
  end

  def edit_speakers
    statementable_edit_speakers(@petition)
  end

  def add_speaker
    statementable_add_speaker(@petition)
  end

  def new_comment_speaker
    statementable_new_comment_speaker(@petition)
  end

  def update_statement_speaker
    statementable_update_statement_speaker(@petition)
  end

  def remove_speaker
    statementable_remove_speaker(@petition)
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id].present?
    @current_organization = @project.organization if @project.present?
  end

  def create
    @petition.user = current_user
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

  private

  def petition_params
    params.require(:petition).permit(:title, :body, :project_id, :signs_goal_count, :cover_image, :thanks_mention,
      :comment_enabled, :sign_title, :social_image, :confirm_privacy,
      :use_signer_email, :use_signer_address, :use_signer_real_name, :use_signer_phone,
      :signer_email_title, :signer_address_title, :signer_real_name_title, :signer_phone_title,
      :speaker_section_title, :speaker_section_response_title, :sign_hidden)
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
end
