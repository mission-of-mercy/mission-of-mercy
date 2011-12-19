// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function procedure_not_added(hasProcedures){
  var checked = $('new_patient_procedure').getInputs('radio', 'patient_procedure[procedure_id]').find(
  	        function(re) {return re.checked;}
  	    );

  if( checked != null){
    Modalbox.show($('incomplete_procedure'), {title: 'Incomplete Procedure Entered!', width: 650}); return false;
  }
  else if(!hasProcedures){
    Modalbox.show($('no_procedure'), {title: 'No Procedures Added!', width: 650}); return false;
  }
}
