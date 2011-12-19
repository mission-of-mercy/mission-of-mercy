MoM.setupNamespace("Checkin");

MoM.Checkin.init = function(options){

  MoM.disableEnterKey();

  $('#patient_survey_attributes_heard_about_clinic').change(function(e){
    MoM.Checkin.toggleOtherHeardAbout();
  });

  $('#patient_race').change(function(){
    MoM.Checkin.toggleOtherRace();
  });

  $('input[name="patient[pain]"]').change(function(e){
    MoM.Checkin.togglePatientPain();
  });

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

  $('#patient_city').autocomplete({
    source: "/autocomplete/city.json",
    search: function(event, ui) {
      $('#city-spinner').show();
    },
    open: function(event, ui) {
      $('#city-spinner').hide();
    }
  });

  $('#bottom_survey a.back').click(function(e){
    MoM.Checkin.showPatientDemographics();

    e.preventDefault();
  });

  $('#bottom_demographics button').click(function(e){
     MoM.Checkin.showPatientSurvey();

     e.preventDefault();
  });

  // Toggle Fields

  MoM.Checkin.toggleOtherHeardAbout(false);
  MoM.Checkin.togglePreviousMoM(false);
  MoM.Checkin.togglePatientPain(false);
  MoM.Checkin.toggleOtherRace(false);

  if(options.lastPatientId){
    MoM.Checkin.printChart(options.lastPatientId);

    // TODO Restore ModalBox
    //Modalbox.show($('last_patient'), {title: "Patient\'s Chart Number", width: 300});}
  }

  $('#patient_first_name').focus();
}

MoM.Checkin.printChart = function(patientId){
  MoM.openInBackground('/patients/' + patientId + '/print');
}

MoM.Checkin.togglePatientPain = function(focus){
  if(focus == undefined) var focus = true;

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

MoM.Checkin.togglePreviousMoM = function(animate){
  var previousMoM = $('#previous_mom_location_div');

  if($('#patient_attended_previous_mom_event_true').is(':checked') == true)
    previousMoM.slideDown();
  else
    previousMoM.slideUp();
}

MoM.Checkin.lookupZip = function(){

  $('#zip-spinner').show();
  $.getJSON("/autocomplete/zip.json", {
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

MoM.Checkin.toggleOtherRace = function(focus){
  if(focus == undefined) var focus = true;

  if($('#patient_race').val() == 'Other')
    $('#race_other_div').slideDown(function(){
      if(focus) $('#patient_race_other').focus();
    });
  else{
    $('#race_other_div').slideUp();
    $('#patient_race_other').val("");
  }
}

MoM.Checkin.toggleOtherHeardAbout = function(focus){
  var heardAbout = $('#patient_survey_attributes_heard_about_clinic').val();
  if(focus == undefined) var focus = true;

  if(heardAbout == "Other")
  {
    $('#heard_about_other_div').slideDown(function(){
      if(focus){
        $('#patient_survey_attributes_heard_about_other').focus();
      }
    });
  }
  else
  {
    $('#heard_about_other_div').slideUp();
    $('#patient_survey_attributes_heard_about_other').val("");
  }
}

MoM.Checkin.showPatientDemographics = function(){
  $('#demographics').show();
  $('#bottom_demographics').show();

  $('#survey').hide();
  $('#bottom_survey').hide();
}

MoM.Checkin.showPatientSurvey = function (){
  $('#demographics').hide();
  $('#bottom_demographics').hide();

  $('#survey').show();
  $('#bottom_survey').show();
}

