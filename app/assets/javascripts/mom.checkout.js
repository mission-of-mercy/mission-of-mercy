MoM.setupNamespace("Checkout");

MoM.Checkout.init = function(options){
  $('a.delete-procedure').bind('ajax:beforeSend', function(e){
    $(this).hide();
    $(this).siblings('img').show();
  });
}
