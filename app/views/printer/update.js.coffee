$("#printer-dropdown li").removeClass('selected')
$("#printer-dropdown li a[href*='<%= escape_javascript session[:printer] %>']")
  .parent().addClass('selected')

$('.dropdown-toggle').dropdown('toggle')
