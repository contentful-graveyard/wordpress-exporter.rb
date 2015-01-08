require_relative 'configuration'
require_relative 'wordpress/export'
require_relative 'converters/contentful_model_to_json'

class Migrator

  attr_reader :exporter, :settings, :converter

  def initialize(settings)
    @settings = Contentful::Configuration.new(settings)
    @exporter = Contentful::Exporter::Wordpress::Export.new(@settings)
    @converter = Contentful::Converter::ContentfulModelToJson.new(@settings)
  end

  def run(action)
    case action.to_s
      when '--create-contentful-model-from-json'
        converter.create_content_type_json
      when '--extract-to-json'
        exporter.export_blog
      when '--convert-content-model-to-json'
        converter.convert_to_import_form
    end
  end

end
