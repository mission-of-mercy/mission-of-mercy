MoM.setupNamespace("Checkin");

$(document).on("pjax:success", function(){
  MoM.Checkin.init();
});

MoM.Checkin.init = function(){
  var $form = $('form.new_patient, form.edit_patient');

  if($form.length == 0) return false;

  MoM.disableEnterKey($('form.new_patient'));

  if($form.data('require-waiver-confirmation'))
    MoM.Checkin.disableAllFields();
  else
    MoM.Checkin.waiverConfirmed();

  if($form.data('last-patient-contact') == null)
    MoM.Checkin.hidePreviousContactInformationButton();

  $("#waiver_agree_button").click(function(e) {
    MoM.Checkin.waiverConfirmed();
    e.preventDefault();
  });

  $('#patient_race').change(function(){
    MoM.Checkin.toggleOtherRace();
  });

  $('input[name="patient[pain]"]').change(function(e){
    MoM.Checkin.togglePatientPain();
  });

  if($form.data('date-input') == "text")
    MoM.Checkin.useTextDate();
  else
    MoM.Checkin.useSelectDate();

  $('#date-input-toggle').click(function(){
    MoM.Checkin.toggleDateInput();
  });

  $('.same_as_previous_patient_button').click(function(e) {
    e.preventDefault();
    MoM.Checkin.fillContactInformation($form.data('last-patient-contact'));
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

  $('#patient_race_other').autocomplete({
    source: "/autocomplete/race.json"
  });

  // Toggle Fields

  MoM.Checkin.togglePreviousMoM(false);
  MoM.Checkin.togglePatientPain(false);
  MoM.Checkin.toggleOtherRace(false);

  var lastPatientId = $form.data('last-patient-id');

  if(lastPatientId){
    if(!$form.data('last-patient-chart-printed'))
      MoM.Checkin.printChart(lastPatientId);

    $('#last_patient h1').text(lastPatientId);

    jQuery.facebox({ div: '#last_patient' }, 'last-patient');

    $('div.last-patient a').click(function(e){
      jQuery(document).trigger('close.facebox');
      e.preventDefault();
      $('#waiver_agree_button').focus();
    });
  }
  else
    $('#waiver_agree_button').focus();

  $('a[rel=tooltip]').tooltip();
}

MoM.Checkin.printChart = function(patientId){
  if(!MoM.mobile) MoM.openInBackground('/patients/' + patientId + '/chart');
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
  $('#date-text input').focus();

  $('#date_input').val('text');
  $('#date-format').slideDown();
}

MoM.Checkin.useSelectDate = function(){
  $('#date-text').hide();
  $('#date-select').show();
  $('#date-select select').first().focus();

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
  var $form = $('form.new_patient, form.edit_patient');
  $form.find('input, button, select').attr('disabled', false);
  $form.removeClass('disabled');

  // Validate form with Parsley
  $form.parsley();
}

MoM.Checkin.disableAllFields = function() {
  $('form.new_patient').find('input, button, select').attr('disabled', true);
  $('form.new_patient').addClass('disabled');
  $('#waiver_agree_button').attr('disabled', false);
}
