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

function showCheckoutFields(tooth, surface){
  if(tooth){
    $('tooth_dt').show(); 
    $('tooth_dd').show();
  }else{
    $('tooth_dt').hide(); 
    $('tooth_dd').hide();
  }
  
  if(surface){
    $('surface_dt').show(); 
    $('surface_dd').show();
  }else{
    $('surface_dt').hide(); 
    $('surface_dd').hide();
  }
}