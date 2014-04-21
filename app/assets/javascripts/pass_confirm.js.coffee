$(document).on 'confirm', 'a[data-pass-confirm]', (e) ->
  $this       = $(this)
  pass        = $this.data('pass-confirm')
  enteredPass = prompt("To continue, enter '#{pass}' in the box below")

  alert("Wrong key!") if enteredPass != pass && enteredPass != null

  enteredPass == pass
