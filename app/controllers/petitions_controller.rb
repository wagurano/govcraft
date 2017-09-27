class PetitionsController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource
  before_action :reset_meta_tags_for_show, only: :show
  before_action :fetch_current_organization, only: [:show, :edit]

  def index
    @petitions = Petition.recent
    @current_organization = fetch_organization_of_request(request)
    @petitions = @petitions.by_organization(@current_organization) if @current_organization.present?
  end

  def show
    @project = @petition.project
    @petition.increment!(:views_count)
    @signs = @petition.signs.recent.where.not(body: [nil, ''])
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
  end

  def add_speaker
    @speaker = Speaker.find_by(id: params[:speaker_id])
    render_404 and return if @speaker.blank?
    @petition.speakers << @speaker unless @petition.speakers.include?(@speaker)
    @petition.save
    redirect_to edit_speakers_petition_path(@petition, q: params[:q])
  end

  def remove_speaker
    @speaker = Speaker.find_by(id: params[:speaker_id])
    render_404 and return if @speaker.blank?
    @petition.speakers.delete(@speaker) if @petition.speakers.include?(@speaker)
    redirect_to edit_speakers_petition_path(@petition, q: params[:q])
  end

  def new_comment_speaker
    @speaker = Speaker.find_by(id: params[:speaker_id])
    render_404 and return if @speaker.blank?
  end

  def update_statement_speaker
    @statement_key = StatementKey.find_by(statement_id: params[:statement_id], key: params[:key])
    render_404 and return if @statement_key.blank?
    return if @statement_key.expired?

    @statement = @statement_key.statement

    if params[:stance].present?
      @statement.stance = params[:stance]
      @statement.save
    end

    @speaker = @statement.speaker
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id].present?
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

  def fetch_current_organization
    @current_organization = @project.organization
  end

  def petition_params
    params.require(:petition).permit(:title, :body, :project_id, :signs_goal_count, :cover_image, :thanks_mention, :comment_enabled, :sign_title, :social_image)
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
end
