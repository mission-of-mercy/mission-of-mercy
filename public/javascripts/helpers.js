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
  $ = jQuery;
  
  if($('#patient_pain_true').is(':checked') == true)
    $('#pain_length_div').slideDown();
  else
    $('#pain_length_div').slideUp();
}

MoM.Helpers.toggleOtherRace = function(){
  $ = jQuery;
  
  if($('#patient_race').val() == 'Other')
    $('#race_other_div').slideDown();
  else
    $('#race_other_div').slideUp();
}