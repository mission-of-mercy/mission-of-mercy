require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "seamusabshere-scriptaculous_slider"
    s.summary = "Scriptaculous slider plugin"
    s.email = "nico@bounga.org"
    s.homepage = "http://github.com/Bounga/scriptaculous_slider"
    s.description = "Scriptaculous slider plugin"
    s.authors = [ "Nico Bounga", "Marty Haught", "Thomas Fuchs", "Nicolas Cavigneaux" ]
    s.files = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*", "init.rb", "{javascripts,rails,tasks}/**/*"] # first two are jeweler defaults
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
