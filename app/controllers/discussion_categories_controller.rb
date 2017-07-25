class DiscussionCategoriesController < ApplicationController
  load_and_authorize_resource

  def new
    project = Project.find_by slug: params[:project_id]
    render_404 and return if project.blank?
    @discussion_category.project = project
  end

  def create
    if @discussion_category.save
      redirect_to project_path(@discussion_category.project) and return
    end
    errors_to_flash(@discussion_category)
    render 'new'
  end

  def destroy
    if @discussion_category.destroy
      redirect_to project_path(@discussion_category.project) and return
    end
    errors_to_flash(@discussion_category)
    redirect_back(@discussion_category.project)
  end

  private

  def discussion_category_params
    params.require(:discussion_category).permit(:title, :project_id)
  end
end
