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

  def run(action, opts = {})
    case action.to_s
      when '--extract-to-json'
        exporter.export_blog
        omit_flag = opts[:omit_content_model].present?
        converter.create_content_type_json(omit_flag) unless omit_flag
      when '--convert-content-model-to-json'
        converter.convert_to_import_form
      when '--create-contentful-model-from-json'
        converter.create_content_type_json
      when '--convert-markup'
        markup_converter.convert_markup_to_markdown
    end
  end
end
