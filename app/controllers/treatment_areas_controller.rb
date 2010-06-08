class TreatmentAreasController < ApplicationController
  before_filter :login_required
  
  def assign
    @patient = Patient.find(params[:patient_id])
    @areas   = TreatmentArea.all(:order => "name")
    
    @current_capacity = @areas.map {|a| [a.name, a.patients.count || 0] }
  end
  
  def assign_complete
    patient = Patient.find(params[:patient_id])
    
    patient.update_attributes(params[:patient])
    
    flash[:notice] = 'Patient was successfully assigned.'
    redirect_to patients_path
  end
  
  def check_out
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
    @patient         = Patient.find(params[:patient_id])
    @patient_procedure = @patient.patient_procedures.build
  end

  def check_out_post
    @treatment_area   = TreatmentArea.find(params[:treatment_area_id])
    @patient           = Patient.find(params[:patient_id])
    
    @patient_procedure = PatientProcedure.new(params[:patient_procedure])
    
    if @patient_procedure.save
      flash[:last_provider_id] = @patient_procedure.provider_id
      flash[:procedure_added] = true
      
      @patient_procedure = @patient.patient_procedures.build
      
      redirect_to treatment_area_checkout_path(@treatment_area, @patient)
    else
      render :action => :check_out
    end
  end
  
  def pre_check_out
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
    @patient         = Patient.find(params[:patient_id])
    @survey          = @patient.survey
    
    @patient.patient_pre_meds.each do |p| 
      p.prescribed = true
    end
    
    PreMed.all.each do |med|
      unless @patient.pre_meds.exists? med
        @patient.patient_pre_meds.build(:pre_med_id => med.id)
      end
    end
  end
  
  def pre_check_out_post
    @treatment_area = TreatmentArea.find(params[:treatment_area_id])
    @patient         = Patient.find(params[:patient_id])
    
    @patient.attributes = params[:patient]
    
    @patient.patient_pre_meds.each do |p|
      p.destroy if !p.new_record? && p.prescribed == "0"
    end
    
    @patient.save
    
    if @patient.survey.update_attributes(params[:survey])
      redirect_to treatment_area_checkout_path(@treatment_area, @patient)
    else
      render :action => pre_check_out
    end
  end
  
  def check_out_completed
    area    = TreatmentArea.find(params[:treatment_area_id])
    patient = Patient.find(params[:patient_id])
    
    patient.check_out(area.id)
    
    flash[:notice] = "Patient successfully checked out"
                          
    redirect_to patients_path(:treatment_area_id => area.id)
  end

end
