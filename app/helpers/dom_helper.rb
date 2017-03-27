module DomHelper
  def vote_panel_dom_id(votable)
    "#{dom_id(votable)}--vote-panel"
  end

  def like_btn_dom_id(likable)
    "#{likable.class.name.underscore}_#{likable.id}_btn"
  end

  def thumb_btns_panel_dom_id(thumbable)
    "#{dom_id(thumbable)}--thumb-btns-panel"
  end

  def options_panel_dom_id(survey)
    "#{dom_id(survey)}--options"
  end

  def option_dom_id(option)
    dom_id(option)
  end
end
