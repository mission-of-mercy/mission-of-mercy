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

  $('form.new_patient_procedure input').change(function(e){
    var code = $(this).data('generic-procedure') || false;
    var type = $(this).data('amalgam-composite') || false;
    var tooth = $(this).data('requires-tooth-number') || false;
    var surface = $(this).data('requires-surface-code') || false;

    if(code || type){
      tooth = true;
      surface = true;
    }

    MoM.Checkout.addProcedure(tooth, surface, code, type);
  });
}

MoM.Checkout.addProcedure = function (tooth, surface, code, type){
  if(tooth){
    $('#tooth_dt').show();
    $('#tooth_dd').show();

    // TODO Replace highlight effects
    // new Effect.Highlight("tooth_dt");

    $('#patient_procedure_tooth_number').focus();
  }else{
    $('#tooth_dt').hide();
    $('#tooth_dd').hide();
  }

  if(surface){
    $('#surface_dt').show();
    $('#surface_dd').show();

    // TODO Replace highlight effects
    //new Effect.Highlight("surface_dt");

  }else{
    $('#surface_dt').hide();
    $('#surface_dd').hide();
  }

  if(code){
    $('#other_dt').show();
    $('#other_dd').show();

    // TODO Replace highlight effects
    //new Effect.Highlight("other_dt");

    $('#patient_procedure_code').focus();
  }else{
    $('#other_dt').hide();
    $('#other_dd').hide();
  }

  if(type){
    $('#amcomp_dt').show();
    $('#amcomp_dd').show();

    // TODO Replace highlight effects
    //new Effect.Highlight("amcomp_dt");

    $('#patient_procedure_procedure_type').focus();
  }else{
    $('#amcomp_dt').hide();
    $('#amcomp_dd').hide();
  }
}