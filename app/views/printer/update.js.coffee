$("#printer-dropdown li").removeClass('selected')
$("#printer-dropdown li a[href*='<%= escape_javascript selected_printer %>']")
  .parent().addClass('selected')

$('.dropdown-toggle').dropdown('toggle')
