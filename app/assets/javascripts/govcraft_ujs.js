$(document).bind('rails:attachBindings', function() {
  $.rails.linkClickSelector += ', div.gov-action-rails-link';

  $.rails.href = function(el) {
    var $el = $(el);
    return $el.data('url') || $el.attr('href');
  }
});
