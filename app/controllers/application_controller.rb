class ApplicationController < ActionController::Base
  helper_method :stats, :dexis?, :cdr?, :kodak?, :current_support_request,
    :current_area_id, :current_treatment_area, :pending_support_requests

  before_filter :remember_me

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :set_current_treatment_area

  private

  # Filter method to enforce admin access rights
  def admin_required
    if signed_in?
      current_user.user_type == UserType::ADMIN
    else
      redirect_to login_path
    end
  end

  def set_current_treatment_area
    if current_user &&
      current_user.user_type == UserType::CHECKOUT &&
      @treatment_area
        self.current_treatment_area = @treatment_area
    else
      current_treatment_area = nil
    end
  end

  def remember_me
    if current_user
      cookies.permanent[:remember_me] = current_user.login
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

  def current_support_request
    @current_support_request ||= begin
      support_request = SupportRequest
        .where(id: session[:current_support_request_id])
        .first

      if support_request && !support_request.resolved
        support_request
      else
        session[:current_treatment_area_id] = nil
      end
    end
  end

  def pending_support_requests
    @pending_support_requests ||= begin
      requests = SupportRequest.active
        .reject {|sr| sr == current_support_request }

      requests.map(&:description).join(', ')
    end
  end

  def current_treatment_area=(treatment_area)
    @current_treatment_area = treatment_area
    session[:current_treatment_area_id] = treatment_area.try(:id)
  end

  def current_treatment_area
    @current_treatment_area ||= TreatmentArea
      .where(id: session[:current_treatment_area_id]).first
  end
end
