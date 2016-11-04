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
    showLabel: false,
    showCount: false,

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
    }, {
        renderer: function() {
            var $result = $("<div>");

            var script = document.createElement("script");
            script.src = "//assets.pinterest.com/js/pinit.js";
            $result.append(script);

            $("<a>").append($("<img>").attr("//assets.pinterest.com/images/pidgets/pinit_fg_en_rect_red_20.png"))
                    .attr({
                        href: "//www.pinterest.com/pin/create/button/?url=http%3A%2F%2Fjs-socials.com%2Fdemos%2F&media=%26quot%3Bhttp%3A%2F%2Fgdurl.com%2Fa653%26quot%3B&description=Next%20stop%3A%20Pinterest",
                        "data-pin-do": "buttonPin",
                        "data-pin-config": "beside",
                        "data-pin-color":"red"
                    })
                    .appendTo($result);

            return $result;
        }
    }]
  });

  $('.post-block__body iframe').addClass('embed-responsive-item');
  $('.post-block__body iframe').parent().addClass('embed-responsive embed-responsive-16by9');
});
