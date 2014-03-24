module Capistrano
  def self.local_configs
    @capistrano_local_configs ||= {}
  end

  def self.local_config(name, &block)
    local_configs[name] = block
  end

  class Configuration
    def locally_overridable(name, &default)
      block = Capistrano.local_configs[name] || default
      instance_eval(&block)
    end
  end
end

local_overrides = File.expand_path("~/.caplocal")
load(local_overrides) if File.exist?(local_overrides)

