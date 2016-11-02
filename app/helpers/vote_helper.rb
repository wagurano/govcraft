module VoteHelper
  def anonymous_voted? poll, choice = nil
    if choice.nil?
      fetch_anonymous_choice(poll).present?
    else
      voted_polls[poll.id] == choice.to_s
    end
  end

  def mark_anonymous_voted_poll(poll, choice)
    updated = voted_polls
    updated[poll.id] = choice
    cookies.permanent.signed[:qus_qus] = JSON.generate(updated)
  end

  def fetch_anonymous_vote poll
   a = Vote.new(choice: fetch_anonymous_choice(poll))
  end

  private

  def fetch_anonymous_choice poll
    voted_polls[poll.id.to_s]
  end

  def voted_polls
    cookie_voted_polls = cookies.permanent.signed[:qus_qus]
    cookie_voted_polls.present? ? JSON.parse(cookie_voted_polls) : {}
  end
end
