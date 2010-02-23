/*
 * clearingInput: a jQuery plugin
 *
 * clearingInput is a simple jQuery plugin that provides example/label text
 * inside text inputs that automatically clears when the input is focused.
 * Common uses are for a hint/example, or as a label when space is limited.
 *
 * For usage and examples, visit:
 * http://github.com/alexrabarts/jquery-clearinginput
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2008 Stateless Systems (http://statelesssystems.com)
 *
 * @author   Alex Rabarts (alexrabarts -at- gmail -dawt- com)
 * @requires jQuery v1.2 or later
 * @version  0.1.2
 */

(function ($) {
  $.extend($.fn, {
    clearingInput: function (options) {
      var defaults = {blurClass: 'blur'};

      options = $.extend(defaults, options);

      return this.each(function () {
        var input = $(this).addClass(options.blurClass);
        var form  = input.parents('form:first');
        var label, text;

        text = options.text || textFromLabel() || input.val();

        if (text) {
          input.val(text);

          input.blur(function () {
            if (input.val() === '') {
              input.addClass(options.blurClass).val(text);
            }
          }).focus(function () {
            if (input.val() === text) {
              input.val('');
            }
            input.removeClass(options.blurClass);
          });

          form.submit(function() {
            if (input.hasClass(options.blurClass)) {
              input.val('');
            }
          });

          input.blur();
        }

        function textFromLabel() {
          label = form.find('label[for=' + input.attr('id') + ']');
          // Position label off screen and use it for the input text
          return label ? label.css({position: 'absolute', left: '-9999px'}).text() : '';
        }
      });
    }
  });
})(jQuery);
