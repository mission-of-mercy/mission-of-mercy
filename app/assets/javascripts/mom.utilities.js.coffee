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
  window.open(url)
  self.focus()

mom.utilities.printChart = (patientId) ->
  unless mom.mobile
    mom.utilities.openInBackground "/patients/#{patientId}/chart"

mom.mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)
