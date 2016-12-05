module LikeHelper
  def likable? likable
    if user_signed_in?
      !Like.liked?(likable, current_user)
    else
      !anonymous_liked?(likable)
    end
  end

  def anonymous_liked? likable
    liked_likables.include? likable_code(likable)
  end

  def mark_anonymous_liked likable
    updated = liked_likables
    updated << likable_code(likable)
    cookies.permanent.signed[:kong_kong] = JSON.generate(updated)
  end

  private

  def liked_likables
    cookie_liked_likables = cookies.permanent.signed[:kong_kong]
    cookie_liked_likables.present? ? JSON.parse(cookie_liked_likables) : []
  end

  def likable_code likable
    "#{likable.class.to_s}-#{likable.id}"
  end
end
