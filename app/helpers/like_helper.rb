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

    begin
      cookies.permanent.signed[:kong_kong] = JSON.generate(updated)
    rescue ActionDispatch::Cookies::CookieOverflow => e
      flash[:error] = t('errors.messages.no_more_anonymous')
      raise ActiveRecord::Rollback
    end
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
