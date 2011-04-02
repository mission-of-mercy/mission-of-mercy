# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scriptaculous_slider}
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nico Bounga", "Marty Haught", "Thomas Fuchs", "Nicolas Cavigneaux"]
  s.date = %q{2009-02-05}
  s.description = %q{Scriptaculous slider plugin}
  s.email = %q{nico@bounga.org}
  s.files = ["VERSION.yml", "lib/helpers", "lib/helpers/slider_helper.rb", "lib/scriptaculous_slider.rb", "init.rb", "javascripts/slider.js", "rails/init.rb", "tasks/scriptaculous_slider.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/Bounga/scriptaculous_slider}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Scriptaculous slider plugin}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
