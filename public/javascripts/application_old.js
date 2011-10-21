// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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

function procedure_not_added(hasProcedures){
  var checked = $('new_patient_procedure').getInputs('radio', 'patient_procedure[procedure_id]').find(
  	        function(re) {return re.checked;}
  	    );

  if( checked != null){
    Modalbox.show($('incomplete_procedure'), {title: 'Incomplete Procedure Entered!', width: 650}); return false;
  }
  else if(!hasProcedures){
    Modalbox.show($('no_procedure'), {title: 'No Procedures Added!', width: 650}); return false;
  }
}
