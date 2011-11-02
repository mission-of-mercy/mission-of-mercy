MoM.setupNamespace("Checkin");

MoM.Checkin.init = function(options){
  $('#patient_first_name').focus();

  MoM.disableEnterKey();

  $('#patient_survey_attributes_heard_about_clinic').change(function(e){
    showOtherHeardAbout();
  });

  $('#patient_race').change(function(){
    MoM.Checkin.toggleOtherRace();
  });

  $('input[name="patient[pain]"]').change(function(e){
    MoM.Checkin.togglePatientPain();
  });

  if($('#patient_pain_true').is(":checked"))
    MoM.Checkin.togglePatientPain(false);

  if(options.dateInput == "text")
    MoM.Checkin.useTextDate();
  else
    MoM.Checkin.useSelectDate();

  $('#date-input-toggle').click(function(){
    MoM.Checkin.toggleDateInput();
  });

  $('input[name="patient[attended_previous_mom_event]"]').change(function(e){
    MoM.Checkin.togglePreviousMoM();
  });

  $('#patient_zip').keyup(function(){
    if($('#patient_zip').val().length >= 5)
      MoM.Checkin.lookupZip();
  });

  if(options.lastPatientId){
    MoM.Checkin.printChart(options.lastPatientId);

    // TODO Restore ModalBox
    //Modalbox.show($('last_patient'), {title: "Patient\'s Chart Number", width: 300});}
  }
}

MoM.Checkin.printChart = function(patientId){
  MoM.openInBackground('/patients/' + patientId + '/print');
}

MoM.Checkin.togglePatientPain = function(focus){
  if(focus == undefined) focus = true;

  if($('#patient_pain_true').is(':checked') == true)
    $('#pain_length_div').slideDown(function(){
      if(focus) $('#patient_time_in_pain').focus();
    });
  else
    $('#pain_length_div').slideUp(function(){
      $('#patient_time_in_pain').val('');
    });
}

MoM.Checkin.toggleDateInput = function(){

  if($('#date-select').is(":visible"))
    MoM.Checkin.useTextDate();
  else
    MoM.Checkin.useSelectDate();
}

MoM.Checkin.useTextDate = function(){

  $('#date-select').hide();

  $('body').append($('#date-select'));
  $('#date-input-container').append($('#date-text'));
  $('#date-text').show();

  $('#date_input').val('text');

  $('#date-format').slideDown();
}

MoM.Checkin.useSelectDate = function(){

  $('#date-text').hide();

  $('body').append($('#date-text'));
  $('#date-input-container').append($('#date-select'));
  $('#date-select').show();

  $('#date_input').val('select');

  $('#date-format').slideUp();
}

MoM.Checkin.togglePreviousMoM = function(){
  if($('#patient_attended_previous_mom_event_true').is(':checked') == true)
    $('#previous_mom_location_div').slideDown();
  else
    $('#previous_mom_location_div').slideUp();
}

MoM.Checkin.lookupZip = function(){

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

MoM.Checkin.toggleOtherRace = function(){
  if($('#patient_race').val() == 'Other')
    $('#race_other_div').slideDown(function(){
      $('#patient_race_other').focus();
    });
  else
    $('#race_other_div').slideUp();
}
