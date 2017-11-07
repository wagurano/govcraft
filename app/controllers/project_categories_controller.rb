class ProjectCategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    @current_organization = fetch_organization_from_request
    @project_categories = ProjectCategory.where(organization: @current_organization)
  end

  def create
    @project_category.organization = fetch_organization_from_request
    if !@project_category.save
      errors_to_flash(@project_category)
    end
    redirect_to project_categories_path
  end

  def destroy
    @project_category.destroy
    redirect_to project_categories_path
  end

  private

  def project_category_params
    params.require(:project_category).permit(:title, :slug)
  end

end
