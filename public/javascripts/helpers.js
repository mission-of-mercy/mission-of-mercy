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
  if($('patient_pain_true').checked == true)
    $('pain_length_div').show();
  else
    $('pain_length_div').hide();
}

MoM.Helpers.toggleOtherRace = function(){
  if($('patient_race').value == 'Other')
    $('race_other_div').show();
  else
    $('race_other_div').hide();
}