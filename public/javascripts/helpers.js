MoM.setupNamespace('Helpers');

MoM.Helpers.showPatientDemographics = function(){
  $('demographics').show();
  $('bottom_demographics').show();
  $('survey').hide();
  $('bottom_survey').hide();
  
  return false;
}

MoM.Helpers.showPatientSurvey = function (){
  $('demographics').hide();
  $('bottom_demographics').hide();
  $('survey').show();
  $('bottom_survey').show();
  
  return false;
}

MoM.Helpers.togglePatientPain = function(){
  var $ = jQuery;
  
  if($('#patient_pain_true').is(':checked') == true)
    $('#pain_length_div').slideDown();
  else
    $('#pain_length_div').slideUp();
}

MoM.Helpers.toggleOtherRace = function(){
  var $ = jQuery;
  
  if($('#patient_race').val() == 'Other')
    $('#race_other_div').slideDown();
  else
    $('#race_other_div').slideUp();
}

MoM.Helpers.togglePreviousMoM = function(){
  var $ = jQuery;
  
  if($('#patient_attended_previous_mom_event_true').is(':checked') == true)
    $('#previous_mom_location_div').slideDown();
  else
    $('#previous_mom_location_div').slideUp();
}

MoM.Helpers.checkIn = function(){
  var $ = jQuery;
  
  $('#patient_attended_previous_mom_event_true').change(function(e){
    MoM.Helpers.togglePreviousMoM();
  });
  
  $('#patient_attended_previous_mom_event_false').change(function(e){
    MoM.Helpers.togglePreviousMoM();
  });
}