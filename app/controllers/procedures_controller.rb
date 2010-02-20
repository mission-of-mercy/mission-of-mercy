class ProceduresController < ApplicationController
  before_filter :admin_required
  
  # GET /procedures
  # GET /procedures.xml
  def index
    @procedures = Procedure.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procedures }
    end
  end

  # GET /procedures/1
  # GET /procedures/1.xml
  def show
    @procedure = Procedure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procedure }
    end
  end

  # GET /procedures/new
  # GET /procedures/new.xml
  def new
    @procedure = Procedure.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @procedure }
    end
  end

  # GET /procedures/1/edit
  def edit
    @procedure = Procedure.find(params[:id])
  end

  # POST /procedures
  # POST /procedures.xml
  def create
    @procedure = Procedure.new(params[:procedure])

    respond_to do |format|
      if @procedure.save
        flash[:notice] = 'Procedure was successfully created.'
        format.html { redirect_to(@procedure) }
        format.xml  { render :xml => @procedure, :status => :created, :location => @procedure }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @procedure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /procedures/1
  # PUT /procedures/1.xml
  def update
    @procedure = Procedure.find(params[:id])

    respond_to do |format|
      if @procedure.update_attributes(params[:procedure])
        flash[:notice] = 'Procedure was successfully updated.'
        format.html { redirect_to(@procedure) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procedure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /procedures/1
  # DELETE /procedures/1.xml
  def destroy
    @procedure = Procedure.find(params[:id])
    @procedure.destroy

    respond_to do |format|
      format.html { redirect_to(procedures_url) }
      format.xml  { head :ok }
    end
  end
end
