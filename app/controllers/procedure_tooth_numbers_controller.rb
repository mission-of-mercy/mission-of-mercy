class ProcedureToothNumbersController < ApplicationController
  before_filter :admin_required
  
  # GET /procedure_tooth_numbers
  # GET /procedure_tooth_numbers.xml
  def index
    @procedure_tooth_numbers = ProcedureToothNumber.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procedure_tooth_numbers }
    end
  end

  # GET /procedure_tooth_numbers/1
  # GET /procedure_tooth_numbers/1.xml
  def show
    @procedure_tooth_number = ProcedureToothNumber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procedure_tooth_number }
    end
  end

  # GET /procedure_tooth_numbers/new
  # GET /procedure_tooth_numbers/new.xml
  def new
    @procedure_tooth_number = ProcedureToothNumber.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @procedure_tooth_number }
    end
  end

  # GET /procedure_tooth_numbers/1/edit
  def edit
    @procedure_tooth_number = ProcedureToothNumber.find(params[:id])
  end

  # POST /procedure_tooth_numbers
  # POST /procedure_tooth_numbers.xml
  def create
    @procedure_tooth_number = ProcedureToothNumber.new(params[:procedure_tooth_number])

    respond_to do |format|
      if @procedure_tooth_number.save
        flash[:notice] = 'ProcedureToothNumber was successfully created.'
        format.html { redirect_to(@procedure_tooth_number) }
        format.xml  { render :xml => @procedure_tooth_number, :status => :created, :location => @procedure_tooth_number }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @procedure_tooth_number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /procedure_tooth_numbers/1
  # PUT /procedure_tooth_numbers/1.xml
  def update
    @procedure_tooth_number = ProcedureToothNumber.find(params[:id])

    respond_to do |format|
      if @procedure_tooth_number.update_attributes(params[:procedure_tooth_number])
        flash[:notice] = 'ProcedureToothNumber was successfully updated.'
        format.html { redirect_to(@procedure_tooth_number) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procedure_tooth_number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /procedure_tooth_numbers/1
  # DELETE /procedure_tooth_numbers/1.xml
  def destroy
    @procedure_tooth_number = ProcedureToothNumber.find(params[:id])
    @procedure_tooth_number.destroy

    respond_to do |format|
      format.html { redirect_to(procedure_tooth_numbers_url) }
      format.xml  { head :ok }
    end
  end
end
