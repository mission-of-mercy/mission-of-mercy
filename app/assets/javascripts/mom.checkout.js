MoM.setupNamespace("Checkout");

MoM.Checkout.init = function(options){
  this.procedureAdded = options.procedureAdded;

  $('a.delete-procedure').bind('ajax:beforeSend', function(e){
    $(this).hide();
    $(this).siblings('img').show();
  });

  $('#export_to_xray').bind('ajax:beforeSend', function(e){
    $(this).siblings('img').show();
  }).bind('ajax:complete', function(e){
    $(this).siblings('img').hide();
  });

  $('form.new_patient_procedure input[type=radio]').change(function(e){
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

  MoM.Checkout.adjustColumnHeight();
  MoM.Checkout.procedureWarnings();
}

MoM.Checkout.addProcedure = function (tooth, surface, code, type){
  if(tooth){
    $('#tooth_dt').show();
    $('#tooth_dd').show();

    $("#tooth_dt").effect("highlight", {}, 2000);

    $('#patient_procedure_tooth_number').focus();
  }else{
    $('#tooth_dt').hide();
    $('#tooth_dd').hide();
  }

  if(surface){
    $('#surface_dt').show();
    $('#surface_dd').show();


    $("#surface_dt").effect("highlight", {}, 2000);

  }else{
    $('#surface_dt').hide();
    $('#surface_dd').hide();
  }

  if(code){
    $('#other_dt').show();
    $('#other_dd').show();

    $("#other_dt").effect("highlight", {}, 2000);

    $('#patient_procedure_code').focus();
  }else{
    $('#other_dt').hide();
    $('#other_dd').hide();
  }

  if(type){
    $('#amcomp_dt').show();
    $('#amcomp_dd').show();

    $("#amcomp_dt").effect("highlight", {}, 2000);

    $('#patient_procedure_procedure_type').focus();
  }else{
    $('#amcomp_dt').hide();
    $('#amcomp_dd').hide();
  }

  MoM.Checkout.adjustColumnHeight();
}

MoM.Checkout.procedureWarnings = function(){
  $('#next-button').click(function(e){
    if($('input[type=radio]').is(':checked')){
      jQuery.facebox({ div: '#incomplete_procedure' }, 'warning');

      e.preventDefault();
    }
    else if(MoM.Checkout.procedureAdded == false){
      jQuery.facebox({ div: '#no_procedure' }, 'warning');

      e.preventDefault();
    }
  });

  $(document).on('click', 'a.go-back', function(e){
    jQuery(document).trigger('close.facebox');
    e.preventDefault();
  });
}

MoM.Checkout.adjustColumnHeight = function(){
  var left  = $('div.input-left');
  var right = $('div.input-right');

  if(left.height() > right.height()){
    right.css('min-height', left.height());
  }
}
