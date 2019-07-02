(function() {
  "use strict";
  App.Banners = {
    update_banner: function(selector, text) {
      $(selector).html(text);
    },
    update_background_color: function(selector, background_color) {
      $(selector).css("background-color", background_color);
    },
    update_font_color: function(selector, font_color) {
      $(selector).css("color", font_color);
    },
    initialize: function() {
      $("[data-js-banner-title]").on({
        change: function() {
          App.Banners.update_banner("#js-banner-title", $(this).val());
        }
      });
      $("[data-js-banner-description]").on({
        change: function() {
          App.Banners.update_banner("#js-banner-description", $(this).val());
        }
      });
      $("[name='banner[background_color]']").on({
        change: function() {
          App.Banners.update_background_color("#js-banner-background", $(this).val());
        }
      });
      $("[name='banner[font_color]']").on({
        change: function() {
          App.Banners.update_font_color("#js-banner-title", $(this).val());
          App.Banners.update_font_color("#js-banner-description", $(this).val());
        }
      });
    }
  };
}).call(this);
