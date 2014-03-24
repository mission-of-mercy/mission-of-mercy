$.facebox.settings.closeImage   = '/assets/facebox/closelabel.png'
$.facebox.settings.loadingImage = '/assets/loading.gif'

# Setup the mom Namespace
window.mom = {utilities: {}}

mom.init = ->
  mom.support.init(true)
  $(document).pjax('#tabnav a', '[data-pjax-container]')

mom.utilities.disableEnterKey = (form) ->
  $(form).keypress (e) ->
    e.preventDefault() if e.keyCode == 13

mom.utilities.openInBackground = (url) ->
  newWindow = window.open(url)
  self.focus()
  newWindow

mom.utilities.printChart = (patientId) ->
  xhr = $.get("/patients/#{patientId}/chart.js")
  xhr.fail ->
    alert "Chart failed to print!"

mom.mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)

$(document).on 'click', "a[href='#reset-form']", ->
  if confirm('Are you sure you wish to reset this form?')
    url = $(this).data('url')
    document.location.href = url
