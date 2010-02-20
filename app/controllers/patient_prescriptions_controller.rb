class PatientPrescriptionsController < ApplicationController
  before_filter :login_required
  
  # GET /patient_prescriptions
  # GET /patient_prescriptions.xml
  def index
    @patient = Patient.find(params[:patient_id])
    @patient_prescriptions = @patient.patient_prescriptions

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patient_prescriptions }
    end
  end

  # GET /patient_prescriptions/1
  # GET /patient_prescriptions/1.xml
  def show
    @patient_prescription = PatientPrescription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patient_prescription }
    end
  end

  # GET /patient_prescriptions/new
  # GET /patient_prescriptions/new.xml
  def new
    @patient_prescription = PatientPrescription.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patient_prescription }
    end
  end

  # GET /patient_prescriptions/1/edit
  def edit
    @patient_prescription = PatientPrescription.find(params[:id])
  end

  # POST /patient_prescriptions
  # POST /patient_prescriptions.xml
  def create
    @patient_prescription = PatientPrescription.new(params[:patient_prescription])

    respond_to do |format|
      if @patient_prescription.save
        flash[:notice] = 'PatientPrescription was successfully created.'
        format.html { redirect_to(@patient_prescription) }
        format.xml  { render :xml => @patient_prescription, :status => :created, :location => @patient_prescription }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @patient_prescription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /patient_prescriptions/1
  # PUT /patient_prescriptions/1.xml
  def update
    @patient_prescription = PatientPrescription.find(params[:id])

    respond_to do |format|
      if @patient_prescription.update_attributes(params[:patient_prescription])
        flash[:notice] = 'PatientPrescription was successfully updated.'
        format.html { redirect_to(@patient_prescription) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patient_prescription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_prescriptions/1
  # DELETE /patient_prescriptions/1.xml
  def destroy
    @patient_prescription = PatientPrescription.find(params[:id])
    @patient_prescription.destroy

    respond_to do |format|
      format.html { redirect_to(patient_prescriptions_url) }
      format.xml  { head :ok }
    end
  end
end
