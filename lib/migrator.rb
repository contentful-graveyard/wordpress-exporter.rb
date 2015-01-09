require_relative 'configuration'
require_relative 'wordpress/export'
require_relative 'converters/contentful_model_to_json'
require_relative 'converters/markup_converter'

class Migrator
  attr_reader :exporter, :settings, :converter, :markup_converter

  def initialize(settings)
    @settings = Contentful::Configuration.new(settings)
    @exporter = Contentful::Exporter::Wordpress::Export.new(@settings)
    @converter = Contentful::Converter::ContentfulModelToJson.new(@settings)
    @markup_converter = Contentful::Converter::MarkupConverter.new(@settings)
  end

  def run(action)
    case action.to_s
      when '--create-contentful-model-from-json'
        converter.create_content_type_json
      when '--extract-to-json'
        exporter.export_blog
      when '--convert-content-model-to-json'
        converter.convert_to_import_form
      when '--convert-markup'
        markup_converter.convert_markup_to_markdown
    end
  end
end
