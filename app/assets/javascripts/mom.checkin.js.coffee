$(document).on "pjax:success", -> new mom.checkin

class mom.checkin
  constructor: ->
    @form = $('form.new_patient, form.edit_patient')

    return false if(@form.length == 0) # Short circuit

    mom.utilities.disableEnterKey @form

    if @form.data('require-waiver-confirmation')
      this.disableAllFields()
      this.hideForm()
    else
      this.waiverConfirmed()

    if @form.data('last-patient-contact') == null
      this.hidePreviousContactInformationButton()

    $("#waiver_agree_button").click (e) =>
      e.preventDefault()
      this.waiverConfirmed()

    $('#patient_race').change =>
      this.toggleOtherRace()

    $('input[name="patient[interpreter_needed]"]').change =>
      this.toggleLanguage()

    $('input[name="patient[pain]"]').change =>
      this.togglePatientPain()

    if @form.data('date-input') == "text"
      this.useTextDate()
    else
      this.useSelectDate()

    $('#date-input-toggle').click =>
      this.toggleDateInput()

    $('.same_as_previous_patient_button').click (e) =>
      e.preventDefault()
      this.fillContactInformation()

    $('input[name="patient[attended_previous_mom_event]"]').change (e) =>
      this.togglePreviousMom()

    $('#patient_zip').keyup =>
      this.lookupZip()

    $('#patient_city').autocomplete source: "/autocomplete/city.json"
    $('#patient_race_other').autocomplete source: "/autocomplete/race.json"

    # Toggle Fields

    this.togglePreviousMom(false)
    this.togglePatientPain(false)
    this.toggleOtherRace(false)
    this.toggleLanguage(false)

    @lastPatientId = @form.data('last-patient-id')

    $(document).on 'click', "a[href='/patients/new']", (e) =>
      e.preventDefault()
      $('#checkin-start').hide()
      @form.show()

    if @lastPatientId
      unless @form.data('last-patient-chart-printed')
        mom.utilities.printChart @lastPatientId

      $('#last_patient h1').text @lastPatientId

      jQuery.facebox({ div: '#last_patient' }, 'last-patient')

      $('div.last-patient a').click (e) ->
        jQuery(document).trigger('close.facebox')
        e.preventDefault()

    $('a[rel=tooltip]').tooltip()

  togglePatientPain: (focus) ->
    focus ||= true

    if $('#patient_pain_true').is(':checked') == true
      $('#pain_length_div').slideDown ->
        $('#patient_time_in_pain').focus() if focus
    else
      $('#pain_length_div').slideUp ->
        $('#patient_time_in_pain').val('')

  toggleDateInput: ->
    if $('#date-select').is(":visible")
      this.useTextDate()
    else
      this.useSelectDate()

  useTextDate: ->
    $('#date-select').hide()
    $('#date-text').show()
    $('#date-text input').focus()

    $('#date_input').val('text')
    $('#date-format').slideDown()

  useSelectDate: ->
    $('#date-text').hide()
    $('#date-select').show()
    $('#date-select select').first().focus()

    $('#date_input').val('select')
    $('#date-format').slideUp()

  togglePreviousMom: (animate) ->
    animate   ||= true
    previousMom = $('#previous_mom_location_div')

    if $('#patient_attended_previous_mom_event_true').is(':checked')
      if animate
        previousMom.slideDown()
      else
        previousMom.show()
    else
      previousMom.slideUp()

  lookupZip: ->
    zip = $('#patient_zip').val()

    return false unless zip.length >= 5

    $('#zip-spinner').show()
    $.getJSON "/autocomplete/zip.json", zip: zip, (data) ->
      $('#zip-spinner').hide()

      if data.found == true
        $('#patient_city').val(data.city)
        $('#patient_state').val(data.state)

  toggleOtherRace: (focus) ->
    focus ||= true

    if $('#patient_race').val() == 'Other'
      $('#race_other_div').slideDown ->
        $('#patient_race_other').focus() if focus
    else
      $('#race_other_div').slideUp()
      $('#patient_race_other').val("")

  toggleLanguage: (focus) ->
    $language = $('#language')
    focus ||= true

    if $('#patient_interpreter_needed_true').is(":checked")
      $language.slideDown ->
        $language.focus() if focus
    else
      $language.slideUp()
      $('#patient_language').prop('selectedIndex',0)

  fillContactInformation: ->
    contact = @form.data('last-patient-contact')

    $("#patient_phone").val(contact.phone)
    $("#patient_street").val(contact.street)
    $("#patient_zip").val(contact.zip)
    $("#patient_city").val(contact.city)
    $("#patient_state").val(contact.state)

  hidePreviousContactInformationButton: ->
    $(".same_as_previous_patient_button").hide()

  waiverConfirmed: ->
    this.enableAllFields()
    $('.waiver_confirmation').hide()
    $('form.new_patient input[type=text]').first().focus()

  hideForm: ->
    @form.hide()

  enableAllFields: ->
    @form.find('input, button, select').attr('disabled', false)
    @form.removeClass('disabled')

    # Validate form with Parsley
    @form.parsley()
    @form.parsley 'addListener',
      onFieldValidate: ( elem ) ->
        !$(elem).is(':visible')

  disableAllFields: ->
    @form.find('input, button, select').attr('disabled', true)
    @form.addClass('disabled')
    $('#waiver_agree_button').attr('disabled', false)
