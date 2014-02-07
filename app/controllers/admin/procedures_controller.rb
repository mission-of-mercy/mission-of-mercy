class Admin::ProceduresController < ApplicationController
  before_filter :admin_required
  before_filter :find_procedure, :only => [:show, :edit, :update, :destroy]
  before_filter :set_current_tab

  def index
    @procedures = Procedure.order("code").paginate(:page => params[:page])
  end

  def new
    @procedure = Procedure.new
  end

  def create
    @procedure = Procedure.new(procedure_params)

    if @procedure.save
      flash[:notice] = 'Procedure was successfully created.'
      redirect_to admin_procedures_path
    else
      render :action => "new"
    end
  end

  def update
    if @procedure.update_attributes(procedure_params)
      flash[:notice] = 'Procedure was successfully updated.'
      redirect_to admin_procedures_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @procedure.destroy

    redirect_to admin_procedures_path
  end

  private

  def find_procedure
    @procedure = Procedure.find(params[:id])
  end

  def set_current_tab
    @current_tab = "procedures"
  end

  def procedure_params
    params.require(:procedure).permit!
  end
end
