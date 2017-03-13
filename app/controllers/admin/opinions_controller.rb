class Admin::OpinionsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @opinions = Opinion.all
  end

  def create
    if @opinion.save
      redirect_to admin_opinions_path
    else
      render 'new'
    end
  end

  def update
    if @opinion.update(opinion_params)
      redirect_to admin_opinions_path
    else
      render 'edit'
    end
  end

  def destroy
    @opinion.destroy
    redirect_to admin_opinions_path
  end

  private

  def opinion_params
    params.require(:opinion).permit(:issue_id, :speaker_id, :quote, :body)
  end
end
