require_relative 'configuration'
require_relative 'wordpress/export'

class Migrator

  attr_reader :exporter, :settings

  def initialize(settings)
    @settings = Contentful::Configuration.new(settings)
    @exporter = Contentful::Exporter::Wordpress::Export.new(@settings)
  end

  def self.run(settings)
    self.new(settings).run
  end

  def run
    exporter.export_blog
  end

end
