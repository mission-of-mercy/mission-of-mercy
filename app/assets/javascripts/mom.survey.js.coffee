mom.survey = {}

mom.survey.init = ->
  $('#survey_heard_about_clinic').change(mom.survey.toggleOtherHeardAbout)

  $('#survey_heard_about_other').autocomplete
    source: "/autocomplete/heard_about_clinic.json"

mom.survey.toggleOtherHeardAbout = ->
  heardAbout = $(this).val()

  if heardAbout == "Other"
    $('#heard_about_other_div').slideDown ->
      $('#survey_heard_about_other').focus()
  else
    $('#heard_about_other_div').slideUp()
    $('#survey_heard_about_other').val("")
