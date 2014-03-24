class Admin::TreatmentsController < ApplicationController
  before_filter :admin_required
  before_filter :set_current_tab

  def index
    @treatments = Treatment.order("name")
  end

  def new
    @treatment = Treatment.new
  end

  def create
    @treatment = Treatment.new(treatment_params)

    if @treatment.save
      redirect_to admin_treatments_path
    else
      render :action => :new
    end
  end

  def edit
    @treatment = Treatment.find(params[:id])
  end

  def update
    @treatment = Treatment.find(params[:id])

    if @treatment.update_attributes(treatment_params)
      flash[:notice] = 'Treatment was successfully updated.'
      redirect_to admin_treatments_path
    else
      render :action => :edit
    end
  end

  def destroy
    Treatment.find(params[:id]).destroy
    redirect_to admin_treatments_path
  end

  private

  def set_current_tab
    @current_tab = "treatments"
  end

  def treatment_params
    params.require(:treatment).permit!
  end
end
