MoM.setupNamespace("Checkout");

MoM.Checkout.init = function(options){
  $('a.delete-procedure').bind('ajax:beforeSend', function(e){
    $(this).hide();
    $(this).siblings('img').show();
  });

  $('#export_to_dexis').bind('ajax:beforeSend', function(e){
    $(this).siblings('img').show();
  }).bind('ajax:complete', function(e){
    $(this).siblings('img').hide();
  });
}
