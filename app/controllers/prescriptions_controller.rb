class PrescriptionsController < ApplicationController
  before_filter :admin_required
  
  # GET /prescriptions
  # GET /prescriptions.xml
  def index
    @prescriptions = Prescription.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prescriptions }
    end
  end

  # GET /prescriptions/1
  # GET /prescriptions/1.xml
  def show
    @prescription = Prescription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prescription }
    end
  end

  # GET /prescriptions/new
  # GET /prescriptions/new.xml
  def new
    @prescription = Prescription.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prescription }
    end
  end

  # GET /prescriptions/1/edit
  def edit
    @prescription = Prescription.find(params[:id])
  end

  # POST /prescriptions
  # POST /prescriptions.xml
  def create
    @prescription = Prescription.new(params[:prescription])

    respond_to do |format|
      if @prescription.save
        flash[:notice] = 'Prescription was successfully created.'
        format.html { redirect_to(@prescription) }
        format.xml  { render :xml => @prescription, :status => :created, :location => @prescription }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @prescription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prescriptions/1
  # PUT /prescriptions/1.xml
  def update
    @prescription = Prescription.find(params[:id])

    respond_to do |format|
      if @prescription.update_attributes(params[:prescription])
        flash[:notice] = 'Prescription was successfully updated.'
        format.html { redirect_to(@prescription) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prescription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prescriptions/1
  # DELETE /prescriptions/1.xml
  def destroy
    @prescription = Prescription.find(params[:id])
    @prescription.destroy

    respond_to do |format|
      format.html { redirect_to(prescriptions_url) }
      format.xml  { head :ok }
    end
  end
end
