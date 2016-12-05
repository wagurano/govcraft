class CandidatesController < ApplicationController
  load_and_authorize_resource :election
  load_and_authorize_resource :candidate, through: :election, shallow: true

  def create
    @candidate.user = current_user
    if @candidate.save
      redirect_to @election
    else
      render 'new'
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:name, :body, :image)
  end
end
