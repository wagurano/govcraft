class Voteaward::VotesController < Voteaward::BaseController
  def index
    @votes = Voteaward::Vote.all.limit(20)
  end

private
  def vote_params
    params.require(:vote).permit(:id)
  end
end
