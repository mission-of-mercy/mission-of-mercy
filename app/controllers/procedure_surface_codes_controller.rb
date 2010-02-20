class ProcedureSurfaceCodesController < ApplicationController
  before_filter :admin_required
  
  # GET /procedure_surface_codes
  # GET /procedure_surface_codes.xml
  def index
    @procedure_surface_codes = ProcedureSurfaceCode.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procedure_surface_codes }
    end
  end

  # GET /procedure_surface_codes/1
  # GET /procedure_surface_codes/1.xml
  def show
    @procedure_surface_code = ProcedureSurfaceCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procedure_surface_code }
    end
  end

  # GET /procedure_surface_codes/new
  # GET /procedure_surface_codes/new.xml
  def new
    @procedure_surface_code = ProcedureSurfaceCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @procedure_surface_code }
    end
  end

  # GET /procedure_surface_codes/1/edit
  def edit
    @procedure_surface_code = ProcedureSurfaceCode.find(params[:id])
  end

  # POST /procedure_surface_codes
  # POST /procedure_surface_codes.xml
  def create
    @procedure_surface_code = ProcedureSurfaceCode.new(params[:procedure_surface_code])

    respond_to do |format|
      if @procedure_surface_code.save
        flash[:notice] = 'ProcedureSurfaceCode was successfully created.'
        format.html { redirect_to(@procedure_surface_code) }
        format.xml  { render :xml => @procedure_surface_code, :status => :created, :location => @procedure_surface_code }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @procedure_surface_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /procedure_surface_codes/1
  # PUT /procedure_surface_codes/1.xml
  def update
    @procedure_surface_code = ProcedureSurfaceCode.find(params[:id])

    respond_to do |format|
      if @procedure_surface_code.update_attributes(params[:procedure_surface_code])
        flash[:notice] = 'ProcedureSurfaceCode was successfully updated.'
        format.html { redirect_to(@procedure_surface_code) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procedure_surface_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /procedure_surface_codes/1
  # DELETE /procedure_surface_codes/1.xml
  def destroy
    @procedure_surface_code = ProcedureSurfaceCode.find(params[:id])
    @procedure_surface_code.destroy

    respond_to do |format|
      format.html { redirect_to(procedure_surface_codes_url) }
      format.xml  { head :ok }
    end
  end
end
