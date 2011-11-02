MoM.setupNamespace('Helpers');

MoM.Helpers.showPatientDemographics = function(){
  $('#demographics').show();
  $('#bottom_demographics').show();
  if($('#errorExplanation')) $('errorExplanation').show();

  $('#survey').hide();
  $('#bottom_survey').hide();

  return false;
}

MoM.Helpers.showPatientSurvey = function (){
  $('#demographics').hide();
  $('#bottom_demographics').hide();
  if($('#errorExplanation')) $('errorExplanation').hide();

  $('#survey').show();
  $('#bottom_survey').show();

  return false;
}
