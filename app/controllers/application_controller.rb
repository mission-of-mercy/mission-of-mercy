# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_area_id

  attr_accessor :current_area_id, :current_treatement_area_id

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def production?
    @is_production ||=(ENV['RAILS_ENV']=='production')
  end
  
  def set_area_id
    self.current_area_id = current_user.user_type if current_user
    
    if treatment_id = params[:treatement_area_id]
      self.current_treatement_area_id = treatment_id
    else
      self.current_treatement_area_id = nil
    end
  end
end
