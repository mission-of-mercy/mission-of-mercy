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
    '5.0'
  end

  def clinic_state
    app_config["state"]
  end

  def patient_searches_path(*args)
    request.url
  end

  def real_currency(number)
    number_to_currency(number,:delimiter => ",", :unit => "$ ",:separator => ".")
  end

  def image_for_yes_no(value)
    css_class = if value
      'ok'
    else
      'remove'
    end

    content_tag(:span, '', class: "icon-#{css_class}")
  end

  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => BootstrapPagination::Rails
    end
    super *[collection_or_options, options].compact
  end

  def body_css
    css = [[controller_name, action_name].join("-")]

    if current_user.nil?
      css << "logged_out"
    elsif current_user.user_type == UserType::ADMIN
      css << "admin"
    end

    css.join(' ')
  end

  def link_to_reset(url)
    link_to_function 'Reset Form',
      %{if (confirm('Are you sure you wish to reset this form?'))
        document.location.href = '#{url}';},
      :class => 'warning'
  end
end
