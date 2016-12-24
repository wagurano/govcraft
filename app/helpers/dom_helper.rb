module DomHelper
  def vote_panel_dom_id(poll)
    "#{dom_id(poll)}--vote-panel"
  end

  def like_btn_dom_id(likable)
    "#{likable.class.name.underscore}_#{likable.id}_btn"
  end

  def thumb_btns_panel_dom_id(thumbable)
    "#{dom_id(thumbable)}--thumb-btns-panel"
  end
end
