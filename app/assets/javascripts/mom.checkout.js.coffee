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

    $('ul.procedures input[type=radio]').change (e) =>
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
    $('dl .tooth-number').toggle(tooth)
    $('dl .surface-code').toggle(surface)
    $('dl .other-procedure').toggle(code)
    $('dl .amalgam-composite-procedure').toggle(type)

    if tooth
      $('#tooth-numbers').toggle(!surface)
      $('#tooth-number').toggle(surface)

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
