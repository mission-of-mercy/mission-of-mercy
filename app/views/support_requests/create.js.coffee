html = '<%= escape_javascript render(@request) %>'

# Clear any old support requests
#
$('#support-request').remove()

$('body').prepend html

# Hacky hack hack hack. Wait to update the body so the css transition works
#
setTimeout ->
  $('body').addClass('support-requested')
, 1
