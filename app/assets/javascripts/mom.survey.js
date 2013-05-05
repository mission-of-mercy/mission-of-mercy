MoM.setupNamespace("Survey");

MoM.Survey.init = function(){
  $('#survey_heard_about_clinic').change(MoM.Survey.toggleOtherHeardAbout);

  $('#survey_heard_about_other').autocomplete({
    source: "/autocomplete/heard_about_clinic.json"
  });
}

MoM.Survey.toggleOtherHeardAbout = function(){
  var heardAbout = $(this).val();

  if(heardAbout == "Other")
  {
    $('#heard_about_other_div').slideDown(function(){
      $('#survey_heard_about_other').focus();
    });
  }
  else
  {
    $('#heard_about_other_div').slideUp();
    $('#survey_heard_about_other').val("");
  }
}
