// Generated by CoffeeScript 1.12.6
(function() {
  "use strict";
  App.Forms = {
    disableEnter: function() {
      return $("form.js-enter-disabled").on("keyup keypress", function(event) {
        if (event.which === 13) {
          return event.preventDefault();
        }
      });
    },
    submitOnChange: function() {
      return $(".js-submit-on-change").unbind("change").on("change", function() {
        $(this).closest("form").submit();
        return false;
      });
    },
    toggleLink: function() {
      return $(".js-toggle-link").unbind("click").on("click", function() {
        var toggle_txt;
        $($(this).data("toggle-selector")).toggle("down");
        if ($(this).data("toggle-text") !== void 0) {
          toggle_txt = $(this).text();
          $(this).text($(this).data("toggle-text"));
          $(this).data("toggle-text", toggle_txt);
        }
        return false;
      });
    },
    synchronizeInputs: function() {
      var banners, inputs, processes, progress_bar;
      progress_bar = "[name='progress_bar[percentage]']";
      processes = "[name='legislation_process[background_color]'], [name='legislation_process[font_color]']";
      banners = "[name='banner[background_color]'], [name='banner[font_color]']";
      inputs = $(progress_bar + ", " + processes + ", " + banners);
      inputs.on({
        input: function() {
          return $("[name='" + this.name + "']").val($(this).val());
        }
      });
      return inputs.trigger("input");
    },
    hideOrShowFieldsAfterSelection: function() {
      $("[name='progress_bar[kind]']").on({
        change: function() {
          var title_field;
          title_field = $("[name^='progress_bar'][name$='[title]']").parent();
          if (this.value === "primary") {
            title_field.hide();
            return $("#globalize_locales").hide();
          } else {
            title_field.show();
            return $("#globalize_locales").show();
          }
        }
      });
      return $("[name='progress_bar[kind]']").change();
    },
    initialize: function() {
      App.Forms.disableEnter();
      App.Forms.submitOnChange();
      App.Forms.toggleLink();
      App.Forms.synchronizeInputs();
      return App.Forms.hideOrShowFieldsAfterSelection();
    }
  };

}).call(this);
