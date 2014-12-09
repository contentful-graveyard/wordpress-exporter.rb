require_relative 'configuration'
require_relative 'wordpress/export'


class Migrator

  attr_reader :exporter,  :config

  def initialize(settings)
    @config = Contentful::Configuration.new(settings)
    @exporter =   Contentful::Exporter::Wordpress::Export.new(config)
  end

  def run(action)
    case action.to_s
      when '--extract-to-json'
        exporter.export_blog
    end
  end
end
