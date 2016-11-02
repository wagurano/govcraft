module VoteHelper
  def voted? poll
    user_signed_in? ? poll.voted_by?(current_user) : voted_polls.include?(poll.id)
  end

  def mark_voted_poll(poll)
    cookies.permanent.signed[:qus_qus] = JSON.generate(voted_polls << poll.id)
  end

  private

  def voted_polls
    cookie_voted_polls = cookies.permanent.signed[:qus_qus]
    cookie_voted_polls.present? ? JSON.parse(cookie_voted_polls) : []
  end
end
