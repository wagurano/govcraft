module DomHelper
  def vote_panel_dom_id(poll)
    "#{dom_id(poll)}--vote-panel"
  end
end
