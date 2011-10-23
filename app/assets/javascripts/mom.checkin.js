MoM.setupNamespace("Checkin");

MoM.Checkin.init = function(){
  $('#patient_first_name').focus();

  MoM.disableEnterKey();

  $('#patient_survey_attributes_heard_about_clinic').change(function(e){
    showOtherHeardAbout();
  });
}