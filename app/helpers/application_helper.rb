# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_area_id
    controller.current_area_id
  end
  
  def current_treatment_area_id
    controller.current_treatment_area_id
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def header(&block)
    content_tag(:div, :class => "header") do
      image_tag("logo_small.png") + 
      capture(&block)     
    end
  end

  def app_version
    '3.1 Beta'
  end
  
  def clinic_state
    app_config["state"]
  end
  
  def real_currency(number)
    number_to_currency(number,:delimiter => ",", :unit => "$ ",:separator => ".")
  end
  
  def body_css
    if current_user.nil?
      "logged_out" 
    elsif current_user.user_type == UserType::ADMIN
      "admin"
    end
  end
  
  def link_to_reset(form_id)
    link_to_function 'Reset Form', 
                     "if (confirm('Are you sure you wish to reset this form?')) $('#{form_id}').reset();", 
                     :class => 'warning'
  end
end
