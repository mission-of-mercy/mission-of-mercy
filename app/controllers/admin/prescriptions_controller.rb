class Admin::PrescriptionsController < ApplicationController
  before_filter :admin_required
  before_filter :find_prescription, :only => [:show, :edit, :update, :destroy]
  before_filter :set_current_tab

  def index
    @prescriptions = Prescription.order("position")
  end

  def new
    @prescription = Prescription.new
  end

  def edit

  end

  def create
    @prescription = Prescription.new(params[:prescription])

    if @prescription.save
      flash[:notice] = 'Prescription was successfully created.'
      redirect_to admin_prescriptions_path
    else
      render :action => "new"
    end
  end

  def update
    if @prescription.update_attributes(params[:prescription])
      flash[:notice] = 'Prescription was successfully updated.'
      redirect_to admin_prescriptions_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @prescription.destroy
    
    flash[:notice] = 'Prescription was successfully destroyed.'

    redirect_to admin_prescriptions_path
  end

  private

  def find_prescription
    @prescription = Prescription.find(params[:id])
  end

  def set_current_tab
    @current_tab = "prescriptions"
  end
end
