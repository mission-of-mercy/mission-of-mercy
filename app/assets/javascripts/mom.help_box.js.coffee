$(document).on 'click', 'img[data-help]', (e) ->
  helpBox = $(e.target).attr('data-help')

  $('#' + helpBox).slideToggle()
.on 'click', 'div.help-box img.close', (e) ->
  $(e.target).parent().slideUp()
