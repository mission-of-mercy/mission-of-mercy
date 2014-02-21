class Admin::PreviousClinicsController < ApplicationController
  before_filter :admin_required
  before_filter :set_current_tab

  def index
    @previous_clinics = PreviousClinic.order("year")
  end

  def new
    @previous_clinic = PreviousClinic.new
  end

  def create
    @previous_clinic = PreviousClinic.new(previous_clinic_params)

    if @previous_clinic.save
      redirect_to admin_previous_clinics_path
    else
      render :action => :new
    end
  end

  def edit
    @previous_clinic = PreviousClinic.find(params[:id])
  end

  def update
    @previous_clinic = PreviousClinic.find(params[:id])

    if @previous_clinic.update_attributes(previous_clinic_params)
      flash[:notice] = 'PreviousClinic was successfully updated.'
      redirect_to admin_previous_clinics_path
    else
      render :action => :edit
    end
  end

  def destroy
    PreviousClinic.find(params[:id]).destroy
    redirect_to admin_previous_clinics_path
  end

  private

  def set_current_tab
    @current_tab = "previous-clinics"
  end

  def previous_clinic_params
    params.require(:previous_clinic).permit!
  end
end
