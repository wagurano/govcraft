module DomHelper
  def vote_panel_dom_id(poll)
    "#{dom_id(poll)}--vote-panel"
  end

  def like_btn_dom_id(likable)
    "#{likable.class.name.underscore}_#{likable.id}_btn"
  end
end
