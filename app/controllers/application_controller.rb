# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all
  helper_method :app_config
  protect_from_forgery
  filter_parameter_logging :password
  before_filter :set_area_id

  attr_accessor :current_area_id, :current_treatment_area_id

  # Scrub sensitive parameters from your log

  
  def set_area_id    
    self.current_area_id = current_user.user_type if current_user
    
    if treatment_id = params[:treatment_area_id]
      self.current_treatment_area_id = treatment_id
    else
      self.current_treatment_area_id = nil
    end
  end
  
  protected
    
  def app_config
    @app_config ||= YAML.load_file("#{Rails.root}/config/mom.yml")
  end
end
