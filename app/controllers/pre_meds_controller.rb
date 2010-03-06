class PreMedsController < ApplicationController
  before_filter :admin_required
  
  # GET /pre_meds
  # GET /pre_meds.xml
  def index
    @pre_meds = PreMed.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pre_meds }
    end
  end

  # GET /pre_meds/1
  # GET /pre_meds/1.xml
  def show
    @pre_med = PreMed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pre_med }
    end
  end

  # GET /pre_meds/new
  # GET /pre_meds/new.xml
  def new
    @pre_med = PreMed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pre_med }
    end
  end

  # GET /pre_meds/1/edit
  def edit
    @pre_med = PreMed.find(params[:id])
  end

  # POST /pre_meds
  # POST /pre_meds.xml
  def create
    @pre_med = PreMed.new(params[:pre_med])

    respond_to do |format|
      if @pre_med.save
        flash[:notice] = 'PreMed was successfully created.'
        format.html { redirect_to(@pre_med) }
        format.xml  { render :xml => @pre_med, :status => :created, :location => @pre_med }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pre_med.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pre_meds/1
  # PUT /pre_meds/1.xml
  def update
    @pre_med = PreMed.find(params[:id])

    respond_to do |format|
      if @pre_med.update_attributes(params[:pre_med])
        flash[:notice] = 'PreMed was successfully updated.'
        format.html { redirect_to(@pre_med) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pre_med.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_meds/1
  # DELETE /pre_meds/1.xml
  def destroy
    @pre_med = PreMed.find(params[:id])
    @pre_med.destroy

    respond_to do |format|
      format.html { redirect_to(pre_meds_url) }
      format.xml  { head :ok }
    end
  end
end
