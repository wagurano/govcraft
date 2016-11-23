//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require unobtrusive_flash
//= require unobtrusive_flash_bootstrap
//= require imagesloaded.pkgd
//= require masonry.pkgd
//= require redactor2_rails/config
//= require redactor
//= require redactor2_rails/langs/ko
//= require jssocials

UnobtrusiveFlash.flashOptions['timeout'] = 300000;

$(document).imagesLoaded( { }, function() {

  if ( $(window).width() > 739 ) {
    //masonry
    var options = {}
      $('.masonry-container').masonry();
    }

    // Initialize Redactor
    $('.redactor').redactor({
      buttons: ['format', 'bold', 'italic', 'deleted', 'lists', 'image', 'file', 'link', 'horizontalrule'],
      callbacks: {
        imageUploadError: function(json, xhr) {
          UnobtrusiveFlash.showFlashMessage(json.error.data[0], {type: 'notice'})
        }
      }
    });
    $('.redactor .redactor-editor').prop('contenteditable', true);
  }
);

$(function(){
  $('.share-box').jsSocials({
    shares: [{
        renderer: function() {
          var $result = $("<div>");

          var script = document.createElement("script");
          script.text = "(function(d, s, id) {var js, fjs = d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js = d.createElement(s); js.id = id; js.src = \"//connect.facebook.net/ru_RU/sdk.js#xfbml=1&version=v2.3\"; fjs.parentNode.insertBefore(js, fjs); }(document, 'script', 'facebook-jssdk'));";
          $result.append(script);

          $("<div>").addClass("fb-share-button")
              .attr("data-layout", "button_count")
              .appendTo($result);

          return $result;
        }
      }, {
        renderer: function() {
          var $result = $("<div>");

          var script = document.createElement("script");
          script.text = "window.twttr=(function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],t=window.twttr||{};if(d.getElementById(id))return t;js=d.createElement(s);js.id=id;js.src=\"https://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);t._e=[];t.ready=function(f){t._e.push(f);};return t;}(document,\"script\",\"twitter-wjs\"));";
          $result.append(script);

          $("<a>").addClass("twitter-share-button")
              .text("Tweet")
              .attr("href", "https://twitter.com/share")
              .appendTo($result);

          return $result;
      }
    }]
  });

  $('.post-block__body iframe').addClass('embed-responsive-item');
  $('.post-block__body iframe').parent().addClass('embed-responsive embed-responsive-16by9');
  $('[data-toggle="tooltip"]').tooltip()
});
