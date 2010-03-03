// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//
//  New Patient Java!
//

function showOtherRace()
{  
  var race = document.getElementById('patient_race');
  
  if(race.selectedIndex == 7)
  {
    document.getElementById('race_other_div').show();
    document.getElementById('race_other').focus();
  }
  else
  {
    document.getElementById('race_other_div').hide();
  }
}

function showPainLength()
{  
  var pain = document.getElementById('patient_pain');
  
  if(pain.checked == true)
  {
    document.getElementById('pain_length_div').show();
    document.getElementById('patient_pain_length_in_days').focus();
  }
  else
  {
    document.getElementById('pain_length_div').hide();
  }
}

function showPreviousMomLocation()
{
  var attended = document.getElementById('patient_attended_previous_mom_event');
  
  if(attended.checked == true)
  {
    document.getElementById('previous_mom_location_div').show();
    document.getElementById('patient_previous_mom_event_location').value = "Tolland, CT";
    document.getElementById('patient_previous_mom_event_location').focus();
  }
  else
  {
    document.getElementById('previous_mom_location_div').hide();
    document.getElementById('patient_previous_mom_event_location').value = "";
  }
}

function openInBackground(url){
   window.open(url); self.focus();
}

function showCheckoutFields(tooth, surface, code, type){
  if(tooth){
    $('tooth_dt').show(); 
    $('tooth_dd').show();

    new Effect.Highlight("tooth_dt");
    
    $('patient_procedure_tooth_number').focus();
  }else{
    $('tooth_dt').hide(); 
    $('tooth_dd').hide();
  }
  
  if(surface){
    $('surface_dt').show(); 
    $('surface_dd').show();
    
    new Effect.Highlight("surface_dt");
  }else{
    $('surface_dt').hide(); 
    $('surface_dd').hide();
  }
  
  if(code){
    $('other_dt').show(); 
    $('other_dd').show();
    
    new Effect.Highlight("other_dt");
    
    $('patient_procedure_code').focus();
  }else{
    $('other_dt').hide(); 
    $('other_dd').hide();
  }
  
  if(type){
    $('amcomp_dt').show();
    $('amcomp_dd').show();
    
    new Effect.Highlight("amcomp_dt");
    
    $('patient_procedure_procedure_type').focus();
  }else{
    $('amcomp_dt').hide();
    $('amcomp_dd').hide();
  }
}

function showPatientDemographics()
{
  $('demographics').show();
  $('bottom_demographics').show();
  $('survey').hide();
  $('bottom_survey').hide();
  
  return false;
}

function showPatientSurvey(){
  $('demographics').hide();
  $('bottom_demographics').hide();
  $('survey').show();
  $('bottom_survey').show();
  
  return false;
}

function showOtherHeardAbout()
{  
  var heardAbout = $('patient_survey_attributes_heard_about_clinic');
  
  if(heardAbout.selectedIndex == 4)
  {
    $('heard_about_other_div').show();
    $('patient_survey_attributes_heard_about_other').focus();
  }
  else
  {
    $('heard_about_other_div').hide();
    $('patient_survey_attributes_heard_about_other').value = "";
  }
}

function graph_highlight(id){
  highlight_bar = $$('#vertgraph dl dd.' + id).first();
  bars = $$('#vertgraph dl dd');
  
  for(var i = 0; i < bars.length; i++)
    if(bars[i] != highlight_bar) bars[i].hide();
  
  $($$('dt.' + id).first()).addClassName("highlight");
  $('vertgraph').addClassName("highlight");
}

function graph_reset(){
  bars   = $$('#vertgraph dl dd');
  labels = $$('#vertgraph dl dt.highlight');
  
  for(var i = 0; i < bars.length; i++)
    bars[i].show();
    
  for(var i = 0; i < labels.length; i++)
    labels[i].removeClassName("highlight");
  
  $('vertgraph').removeClassName("highlight");
}
