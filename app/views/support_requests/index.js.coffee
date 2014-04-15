$('#pending-requests').remove()

$('body').prepend '<%= escape_javascript render('support_requests/pending_requests') %>'

<% if pending_support_requests.present? %>
$('body').addClass('pending-requests')
<% else %>
$('body').removeClass('pending-requests')
<% end %>
