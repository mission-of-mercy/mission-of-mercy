request = <%= @request.try(:id) %>

if request
  mom.support.showSupportRequested(request)
else
  $('#help_link').show()

$('#help_loading').hide()
