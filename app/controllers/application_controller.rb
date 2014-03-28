class ApplicationController < ActionController::Base
  helper_method :stats, :dexis?, :cdr?, :kodak?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_area_id

  attr_accessor :current_area_id, :current_treatment_area_id

  private

  # Filter method to enforce admin access rights
  def admin_required
    if signed_in?
      current_user.user_type == UserType::ADMIN
    else
      redirect_to login_path
    end
  end

  def set_area_id
    self.current_area_id = current_user.user_type if current_user

    if treatment_id = params[:treatment_area_id]
      self.current_treatment_area_id = treatment_id
    else
      self.current_treatment_area_id = nil
    end
  end

  def stats
    @stats ||= Stats.new(session)
  end

  def xray_system
    @xray_system ||= ENV['XRAY_SYSTEM']
  end

  def dexis?
    xray_system == "dexis"
  end

  def cdr?
    xray_system == "cdr"
  end

  def kodak?
    xray_system == "kodak"
  end
end
