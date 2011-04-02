desc "Install the slider.js file to public/javascripts"
task :scriptaculous_slider_install do
  FileUtils.cp(File.dirname(__FILE__) + "/../javascripts/slider.js", RAILS_ROOT + '/public/javascripts/')
end