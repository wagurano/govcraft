class Admin::AgenciesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @agencies = Agency.all
  end

  def create
    if @agency.save
      redirect_to admin_agencies_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @agency.update(agency_params)
      redirect_to admin_agencies_path
    else
      render 'edit'
    end
  end

  def destroy
    @agency.destroy
    redirect_to admin_agencies_path
  end

  private

  def agency_params
    params.require(:agency).permit(:title, :slug, :position_name_list, :image)
  end
end
