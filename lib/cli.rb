require_relative 'migrator'
require 'yaml'

module Command
  class CLI < Escort::ActionCommand::Base

    def execute
      setting_file = YAML.load_file(global_options[:file])
      Migrator.run(setting_file)
    end

  end
end
