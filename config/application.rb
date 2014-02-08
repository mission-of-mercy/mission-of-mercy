require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module MissionOfMercy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.use Rack::Pjax

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    config.assets.precompile += ['print/default.css', 'print/report.css']
    config.assets.paths << Rails.root.join("app", "assets", "mp3")

    Date::DATE_FORMATS.merge!(:default => '%m/%d/%Y')

    # Default uses divs which cause rendering issues
    ActionView::Base.field_error_proc = Proc.new { |html_tag, instance|
      "<span class=\"field_with_errors\">#{html_tag}</span>".html_safe
    }

    config.axlsx_author = "Mission of Mercy Management Application"
  end
end
