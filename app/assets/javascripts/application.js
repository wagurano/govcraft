//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require unobtrusive_flash
//= require unobtrusive_flash_bootstrap
//= require imagesloaded.pkgd
//= require masonry.pkgd

UnobtrusiveFlash.flashOptions['timeout'] = 300000;

$(document).imagesLoaded( { }, function() {

  if ( $(window).width() > 739 ) {
    //masonry
    var options = {}
      $('.masonry-container').masonry();
    }
  }
);