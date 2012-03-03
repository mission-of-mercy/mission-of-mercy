class User < ActiveRecord::Base
  devise :database_authenticatable

  validates_uniqueness_of :login

  def name
    if user_type == UserType::XRAY
      if login[/\Axray/]
        "X-Ray Station #{x_ray_station_id}"
      else
        "#{login.humanize} (#{x_ray_station_id})"
      end
    else
      login.humanize
    end
  end

  # TODO Replace / Move
  def start_path
    if user_type == UserType::ADMIN
      Rails.application.routes.url_helpers.admin_reports_path
    elsif user_type == UserType::CHECKIN
      Rails.application.routes.url_helpers.new_patient_path
    elsif user_type == UserType::XRAY
      Rails.application.routes.url_helpers.patients_path
    elsif user_type == UserType::CHECKOUT
      Rails.application.routes.url_helpers.root_path
    elsif user_type == UserType::PHARMACY
      Rails.application.routes.url_helpers.patients_path
    elsif user_type == UserType::ASSIGNMENT
      Rails.application.routes.url_helpers.patients_path
    else
      Rails.application.routes.url_helpers.root_path
    end
  end
end
