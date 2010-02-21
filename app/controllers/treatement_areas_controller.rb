class TreatementAreasController < ApplicationController
  before_filter :admin_required, :except => [:check_out]
  before_filter :login_required
  
  def index
    @areas = TreatementArea.all
  end

  def new
    @treatement_area = TreatementArea.new
  end
  
  def create
    @treatement_area = TreatementArea.new(params[:treatement_area])
    
    if @treatement_area.save
      redirect_to treatement_areas_path
    else
      render :action => :new
    end
  end

  def edit
    @treatement_area = TreatementArea.find(params[:id])
  end

  def show
    @treatement_area = TreatementArea.find(params[:id])
  end
  
  def check_out
    @treatement_area = TreatementArea.find(params[:id])
    @patient         = Patient.find(params[:patient_id])
  end

end
