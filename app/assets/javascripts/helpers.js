MoM.setupNamespace('Helpers');

MoM.Helpers.showPatientDemographics = function(){
  $('demographics').show();
  $('bottom_demographics').show();
  if($('errorExplanation')) $('errorExplanation').show();

  $('survey').hide();
  $('bottom_survey').hide();

  return false;
}

MoM.Helpers.showPatientSurvey = function (){
  $('demographics').hide();
  $('bottom_demographics').hide();
  if($('errorExplanation')) $('errorExplanation').hide();

  $('survey').show();
  $('bottom_survey').show();

  return false;
}

MoM.Helpers.togglePatientPain = function(focus){
  var $ = jQuery;

  if(focus == undefined) focus = true;

  if($('#patient_pain_true').is(':checked') == true)
    $('#pain_length_div').slideDown(function(){
      if(focus) $('#patient_pain_length_in_days').focus();
    });
  else
    $('#pain_length_div').slideUp(function(){
      $('#patient_time_in_pain').val('');
    });
}

MoM.Helpers.toggleOtherRace = function(){
  var $ = jQuery;

  if($('#patient_race').val() == 'Other')
    $('#race_other_div').slideDown(function(){
      $('#patient_race_other').focus();
    });
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

MoM.Helpers.checkIn = function(options){
  var $ = jQuery;

  $('#patient_attended_previous_mom_event_true').change(function(e){
    MoM.Helpers.togglePreviousMoM();
  });

  $('#patient_attended_previous_mom_event_false').change(function(e){
    MoM.Helpers.togglePreviousMoM();
  });

  $('#patient_zip').keyup(function(){
    if($('#patient_zip').val().length >= 5)
      MoM.Helpers.lookupZip();
  });

  if(options.dateInput == "text")
    MoM.Helpers.useTextDate();
  else
    MoM.Helpers.useSelectDate();

  $('#date-input-toggle').click(function(){
    MoM.Helpers.toggleDateInput();
  })

  if($('#patient_pain_true').is(":checked"))
    MoM.Helpers.togglePatientPain(false);
}

MoM.Helpers.toggleDateInput = function(){
  var $ = jQuery;

  if($('#date-select').is(":visible"))
    MoM.Helpers.useTextDate();
  else
    MoM.Helpers.useSelectDate();
}

MoM.Helpers.useTextDate = function(){
  var $ = jQuery;

  $('#date-select').hide();

  $('body').append($('#date-select'));
  $('#date-input-container').append($('#date-text'));
  $('#date-text').show();

  $('#date_input').val('text');

  $('#date-format').slideDown();
}

MoM.Helpers.useSelectDate = function(){
  var $ = jQuery;

  $('#date-text').hide();

  $('body').append($('#date-text'));
  $('#date-input-container').append($('#date-select'));
  $('#date-select').show();

  $('#date_input').val('select');

  $('#date-format').slideUp();
}

MoM.Helpers.lookupZip = function(){
  var $ = jQuery;

  $('#zip-spinner').show();
  $.getJSON("/patients/lookup_zip.json", {
    zip: $('#patient_zip').val()
  },
  function(data){
    $('#zip-spinner').hide();

    if(data.found == true){
      $('#patient_city').val(data.city);
      $('#patient_state').val(data.state);
    }
  });
}
