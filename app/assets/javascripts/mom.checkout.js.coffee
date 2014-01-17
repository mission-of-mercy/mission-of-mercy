class mom.checkout
  @adjustColumnHeight: ->
    left  = $('div.input-left')
    right = $('div.input-right')

    if left.height() > right.height()
      right.css 'min-height', left.height()

  constructor: (@options) ->
    @procedureAdded = @options.procedureAdded

    $('a.delete-procedure').on 'ajax:beforeSend', (e) ->
      $(this).hide()
      $(this).siblings('img').show()

    $('#export_to_xray').on 'ajax:beforeSend', (e) ->
      $(this).siblings('img').show()
    .on 'ajax:complete', (e) ->
      $(this).siblings('img').hide()

    $('form.new_patient_procedure input[type=radio]').change (e) =>
      code    = $(e.target).data('generic-procedure') || false
      type    = $(e.target).data('amalgam-composite') || false
      tooth   = $(e.target).data('requires-tooth-number') || false
      surface = $(e.target).data('requires-surface-code') || false

      if code || type
        tooth = true
        surface = true

      this.addProcedure(tooth, surface, code, type)

    mom.checkout.adjustColumnHeight()
    this.procedureWarnings()

  addProcedure: (tooth, surface, code, type) ->
    highlightOptions = ["highlight", {}, 2000]

    if tooth
      $('#tooth_dt').show()
      $('#tooth_dd').show()

      $("#tooth_dt").effect highlightOptions...

      $('#patient_procedure_tooth_number').focus()
    else
      $('#tooth_dt').hide()
      $('#tooth_dd').hide()

    if surface
      $('#surface_dt').show()
      $('#surface_dd').show()

      $("#surface_dt").effect highlightOptions...
    else
      $('#surface_dt').hide()
      $('#surface_dd').hide()

    if code
      $('#other_dt').show()
      $('#other_dd').show()

      $("#other_dt").effect highlightOptions...

      $('#patient_procedure_code').focus()
    else
      $('#other_dt').hide()
      $('#other_dd').hide()

    if type
      $('#amcomp_dt').show()
      $('#amcomp_dd').show()

      $("#amcomp_dt").effect highlightOptions...

      $('#patient_procedure_procedure_type').focus()
    else
      $('#amcomp_dt').hide()
      $('#amcomp_dd').hide()

    mom.checkout.adjustColumnHeight()

  procedureWarnings: ->
    $('#next-button').click (e) =>
      if $('input[type=radio]').is(':checked')
        $.facebox { div: '#incomplete_procedure' }, 'warning'
        e.preventDefault()
      else if !@procedureAdded
        $.facebox({ div: '#no_procedure' }, 'warning')
        e.preventDefault()

    $(document).on 'click', 'a.go-back', (e) ->
      $(document).trigger('close.facebox')
      e.preventDefault()
