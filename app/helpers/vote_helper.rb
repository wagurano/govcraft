module VoteHelper
  def anonymous_voted? votable, choice = nil
    if choice.nil?
      fetch_anonymous_choice(votable).present?
    else
      voted_votables["#{votable.class.name}_#{votable.id}"] == choice.to_s
    end
  end

  def mark_anonymous_voted_poll(votable, choice)
    updated = voted_votables
    updated["#{votable.class.name}_#{votable.id}"] = choice
    cookies.permanent.signed[:qus_qus] = JSON.generate(updated)
  end

  def fetch_anonymous_vote votable
   a = Vote.new(choice: fetch_anonymous_choice(votable))
  end

  private

  def fetch_anonymous_choice votable
    voted_votables["#{votable.class.name}_#{votable.id}"]
  end

  def voted_votables
    cookie_voted_votables = cookies.permanent.signed[:qus_qus]
    cookie_voted_votables.present? ? JSON.parse(cookie_voted_votables) : {}
  end
end
