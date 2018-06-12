class Admin::PositionsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @positions = Position.all
  end

  def create
    if @position.save
      redirect_to admin_positions_path
    else
      render 'new'
    end
  end

  def update
    if @position.update(position_params)
      redirect_to admin_positions_path
    else
      render 'edit'
    end
  end

  def destroy
    @position.destroy
    redirect_to admin_positions_path
  end

  private

  def position_params
    params.require(:position).permit(:name)
  end
end
