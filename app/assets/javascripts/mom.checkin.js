MoM.setupNamespace("Checkin");

MoM.Checkin.init = function(options){

  MoM.disableEnterKey($('form.new_patient'));

  MoM.Checkin.hacks();

  if (options.requireWaiverConfirmation)
    MoM.Checkin.disableAllFields();
  else
    MoM.Checkin.waiverConfirmed();

  if(options.lastPatient.contactInformation == null)
    MoM.Checkin.hidePreviousContactInformationButton();

  $("#waiver_agree_button").click(function(e) {
    MoM.Checkin.waiverConfirmed();
    e.preventDefault();
  });

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

  $('.same_as_previous_patient_button').click(function(e) {
    e.preventDefault();
    MoM.Checkin.fillContactInformation(options.lastPatient.contactInformation);
  })

  $('input[name="patient[attended_previous_mom_event]"]').change(function(e){
    MoM.Checkin.togglePreviousMoM();
  });

  $('#patient_zip').keyup(function(){
    if($('#patient_zip').val().length >= 5)
      MoM.Checkin.lookupZip();
  });

  $('#patient_city').autocomplete({
    source: "/autocomplete/city.json"
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

  if(options.lastPatient.id){
    MoM.Checkin.printChart(options.lastPatient.id);

    jQuery.facebox({ div: '#last_patient' }, 'last-patient');

    $('div.last-patient a').click(function(e){
      jQuery(document).trigger('close.facebox');
      e.preventDefault();
      $('#waiver_agree_button').focus();
    });
  }
  else
    $('#waiver_agree_button').focus();
}

MoM.Checkin.hacks = function(){
  $('#tabnav a').on('click', function(e){
    var input = $(this)
    var tab   = input.attr('data-tab');

    $('#tabnav li').removeClass('current');

    if(tab == "new"){
      $('form.new_patient').show();
      $('#reprint').hide();
      $('#previous-patient').hide();
      $('#waiver_agree_button').focus();
    } else if(tab == "previous"){
      $('form.new_patient').hide();
      $('#previous-patient').show();
      $('#reprint').hide();
      $('#previous-patient input:first').focus();
    } else if(tab == "print"){
      $('form.new_patient').hide();
      $('#previous-patient').hide();
      $('#reprint').show();
      $('#reprint input:first').focus();
    }

    input.parent().addClass("current");

    e.preventDefault();
  });

  $('#reprint').on('submit', function(e){
    var chartNumber = $('#reprint #chart_number').val();
    MoM.openInBackground('/patients/' + chartNumber + '/print');

    $('#reprint #chart_number').val(chartNumber + " printing ...").
      select().
      focus();

    e.preventDefault();
  });

  $('#previous-patient').on('submit', function(e){
    var chartNumber = $('#previous-patient #chart_number').val();
    $.getJSON("/patients/" + chartNumber + ".json", function(data){
      if(data.patient == null){
        $('#previous-patient #chart_number').
          val("Patient " + chartNumber + " not found").
          select().
          focus();
      } else {
        var patient = data.patient;

        MoM.Checkin.useTextDate();

        $('form.new_patient').show();
        $('#reprint').hide();
        $('#previous-patient').hide();
        $('#waiver_agree_button').focus();

        $('#patient_first_name').val(patient.first_name);
        $('#patient_last_name').val(patient.last_name);

        $('#patient_date_of_birth').val(patient.date_of_birth);
        $('#patient_sex').val(patient.sex);

        $('#patient_phone').val(patient.phone);
        $('#patient_street').val(patient.street);
        $('#patient_city').val(patient.city);
        $('#patient_state').val(patient.state);
        $('#patient_zip').val(patient.zip);

        $('#patient_race').val(patient.race);

        $('#patient_previous_chart_number').val(patient.id);
      }
    });

    e.preventDefault();
  });
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
  $('#date-text').show();

  $('#date_input').val('text');
  $('#date-format').slideDown();
}

MoM.Checkin.useSelectDate = function(){
  $('#date-text').hide();
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

MoM.Checkin.fillContactInformation = function(contact) {
  $("#patient_phone").val(contact.phone);
  $("#patient_street").val(contact.street);
  $("#patient_zip").val(contact.zip);
  $("#patient_city").val(contact.city);
  $("#patient_state").val(contact.state);
}

MoM.Checkin.hidePreviousContactInformationButton = function() {
  $(".same_as_previous_patient_button").hide();
}

MoM.Checkin.waiverConfirmed = function() {
  MoM.Checkin.enableAllFields();
  $('.waiver_confirmation').hide();
  $('form.new_patient input[type=text]').first().focus();
}

MoM.Checkin.enableAllFields = function() {
  $('form.new_patient').find('input, button, select').attr('disabled', false);
  $('form.new_patient').removeClass('disabled');
}

MoM.Checkin.disableAllFields = function() {
  $('form.new_patient').find('input, button, select').attr('disabled', true);
  $('form.new_patient').addClass('disabled');
  $('#waiver_agree_button').attr('disabled', false);
}
