class PatientProceduresController < ApplicationController
  before_filter :login_required
  
  # GET /patient_procedures
  # GET /patient_procedures.xml
  def index
    @patient = Patient.find(params[:patient_id])
    @patient_procedures = @patient.patient_procedures
    
    @procedure = @patient.patient_procedures.new
    
    if flash[:provider] != nil
      @procedure.provider = flash[:provider]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patient_procedures }
    end
  end

  # GET /patient_procedures/1
  # GET /patient_procedures/1.xml
  def show
    @patient_procedure = PatientProcedure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patient_procedure }
    end
  end

  # GET /patient_procedures/new
  # GET /patient_procedures/new.xml
  def new
    @patient_procedure = PatientProcedure.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patient_procedure }
    end
  end

  # GET /patient_procedures/1/edit
  def edit
    @patient_procedure = PatientProcedure.find(params[:id])
  end

  # POST /patient_procedures
  # POST /patient_procedures.xml
  def create
    @patient_procedure = PatientProcedure.new(params[:patient_procedure])

    @patient_procedure.procedure = Procedure.find(:first, :conditions => {:code => params[:patient_procedure_code]})
    
    # Uppercase Tooth Number
    
    if @patient_procedure.tooth_number.to_i == 0
      @patient_procedure.tooth_number = @patient_procedure.tooth_number.upcase
    end

    if params[:patient_procedure_type] != nil && @patient_procedure.procedure == nil
      type = params[:patient_procedure_type][0]
      surface_count = @patient_procedure.surface_code.gsub(" ", "").gsub(",", "").length
      
      # HACK HACK this is nasty but it works!!!
      # Amalgams will be ok with just one return
      if type == "Amalgam"
        @patient_procedure.procedure = Procedure.find(:first, :conditions => {:procedure_type => type, :number_of_surfaces => surface_count})
      else
        # Find out if Post or Ant ...
        tooth_number = @patient_procedure.tooth_number.to_i
        
        if tooth_number.between?(1,5) || tooth_number.between?(12,16) || tooth_number.between?(17,21) || tooth_number.between?(28,32) || @patient_procedure.tooth_number.between?("A","B") || @patient_procedure.tooth_number.between?("I","J") || @patient_procedure.tooth_number.between?("K","L") || @patient_procedure.tooth_number.between?("S","T")
          @patient_procedure.procedure = Procedure.find(:first, :conditions => {:procedure_type => "Post Composite", :number_of_surfaces => surface_count})
        elsif  tooth_number.between?(6,11) || tooth_number.between?(22,27) || @patient_procedure.tooth_number.between?("C","H") || @patient_procedure.tooth_number.between?("M","R") 
          @patient_procedure.procedure = Procedure.find(:first, :conditions => {:procedure_type => "Ant Composite", :number_of_surfaces => surface_count})
        end
      end
    end

    flash[:provider] = @patient_procedure.provider

    respond_to do |format|
      if @patient_procedure.save
      
      # Can't use this controller for each page. Each page should really, at the very least, post to the same controller so we can render if there are errors!
      
        format.html { redirect_to(patient_patient_procedures_path(@patient_procedure.patient)) }
      else
        @patient = @patient_procedure.patient
        @procedure = @patient_procedure
        @patient_procedures = @patient.patient_procedures
      
        format.html { render :action => "index" }
        format.xml  { render :xml => @patient_procedure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /patient_procedures/1
  # PUT /patient_procedures/1.xml
  def update
    @patient_procedure = PatientProcedure.find(params[:id])

    respond_to do |format|
      if @patient_procedure.update_attributes(params[:patient_procedure])
        flash[:notice] = 'PatientProcedure was successfully updated.'
        format.html { redirect_to(@patient_procedure) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patient_procedure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_procedures/1
  # DELETE /patient_procedures/1.xml
  def destroy
    @patient_procedure = PatientProcedure.find(params[:id])
    @patient_procedure.destroy

    respond_to do |format|
    	format.js
    end
  end
end
