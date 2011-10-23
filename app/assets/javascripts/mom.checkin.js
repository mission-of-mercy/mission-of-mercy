MoM.setupNamespace("Checkin");

MoM.Checkin.init = function(lastPatient){
  $('#patient_first_name').focus();

  MoM.disableEnterKey();

  $('#patient_survey_attributes_heard_about_clinic').change(function(e){
    showOtherHeardAbout();
  });

  if(lastPatient){
    MoM.Checkin.printChart(lastPatient)

    // TODO Restore ModalBox
    //Modalbox.show($('last_patient'), {title: "Patient\'s Chart Number", width: 300});}
  }
}

MoM.Checkin.printChart = function(patientId){
  MoM.openInBackground('/patients/' + patientId + '/print');
}