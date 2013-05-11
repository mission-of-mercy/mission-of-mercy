class ApplicationController < ActionController::Base
  helper_method :app_config, :stats, :dexis?, :cdr?, :kodak?

  protect_from_forgery

  before_filter :set_area_id
  around_filter :setup_stats

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

  def app_config
    @app_config ||= YAML.load_file("#{Rails.root}/config/mom.yml")
  end

  def stats
    @stats
  end

  def setup_stats
    @stats ||= Stats.new(session[:stats])

    yield

    session[:stats] = @stats.data
  end

  def dexis?
    app_config['xray'] == "dexis"
  end

  def cdr?
    app_config['xray'] == "cdr"
  end

  def kodak?
    app_config['xray'] == "kodak"
  end
end
