require_relative 'content_types_structure_creator'

module Contentful
  module Converter
    class ContentfulModelToJson
      attr_reader :config, :logger, :converted_model_dir, :content_types, :omit_content_model

      FIELD_TYPE = %w( Link Array )

      def initialize(settings)
        @config = settings
        @logger = Logger.new(STDOUT)
      end

      def create_content_type_json(omit_content_model_flag = true)
        @omit_content_model = omit_content_model_flag
        contentful_structure = load_contentful_structure_file
        logger.info 'Create JSON files with content types structure...'
        contentful_structure.each do |content_type, values|
          content_type_name = content_type_name(content_type)
          create_directory(config.collections_dir)
          ContentTypesStructureCreator.new(config).create_content_type_json_file(content_type_name, values)
        end
        logger.info 'Done!'
      end

      def convert_to_import_form
        set_content_model_parameters
        logger.info 'Converting Contentful model to Contentful import structure...'
        File.open(converted_model_dir, 'w') { |file| file.write({}) }
        contentful_file = JSON.parse(File.read(content_types))['items']
        contentful_file.each do |content_type|
          parsed_content_type = {
            id: content_type['sys']['id'],
            name: content_type['name'],
            description: content_type['description'],
            displayField: content_type['displayField'],
            fields: {}.merge!(create_contentful_fields(content_type))
          }
          import_form = JSON.parse(File.read(converted_model_dir))
          File.open(converted_model_dir, 'w') do |file|
            file.write(JSON.pretty_generate(import_form.merge!(content_type['name'] => parsed_content_type)))
          end
        end
        logger.info "Done! Contentful import structure file saved in #{converted_model_dir}"
      end

      def create_contentful_fields(content_type)
        content_type['fields'].each_with_object({}) do |(field, _value), results|
          id = link_id(field)
          results[id] = case field['type']
                          when 'Link'
                            { id: field['id'], type: field['linkType'], link: 'Link' }
                          when 'Array'
                            { id: field['id'], type: field['type'], link_type: field['items']['linkType'], link: field['items']['type'] }
                          else
                            field['type']
                        end
        end
      end

      def link_id(field)
        if FIELD_TYPE.include? field['type']
          field['name'].capitalize
        else
          field['id']
        end
      end

      def content_type_name(content_type)
        I18n.transliterate(content_type).underscore.tr(' ', '_')
      end

      def create_directory(path)
        FileUtils.mkdir_p(path) unless File.directory?(path)
      end

      # If contentful_structure JSON file exists, it will load the file. If not, it will automatically create an empty file.
      # This file is required to convert contentful model to contentful import structure.
      def load_contentful_structure_file
        fail ArgumentError, 'Set PATH for contentful structure JSON file. View README' if omit_content_model?
        file_exists? ? load_existing_contentful_structure_file : create_empty_contentful_structure_file
      end

      def omit_content_model?
        omit_content_model == true ? config.settings['contentful_structure_dir'].nil? : false
      end

      def file_exists?
        omit_content_model == false ? true : File.exist?(config.settings['contentful_structure_dir'])
      end

      def create_empty_contentful_structure_file
        File.open(config.settings['contentful_structure_dir'], 'w') { |file| file.write({}) }
        load_existing_contentful_structure_file
      end

      def load_existing_contentful_structure_file
        if omit_content_model == true
          JSON.parse(File.read(config.settings['contentful_structure_dir']), symbolize_names: true).with_indifferent_access
        else
          spec = Gem::Specification.find_by_name('wordpress-exporter')
          JSON.parse(File.read("#{spec.gem_dir}/wordpress_settings/default_contentful_structure.json"), symbolize_names: true).with_indifferent_access
        end
      end

      def set_content_model_parameters
        validate_content_model_files
        @converted_model_dir = config.settings['converted_model_dir']
        @content_types = config.settings['content_model_json']
      end

      def validate_content_model_files
        fail ArgumentError, 'Set PATH for content model JSON file. View README' if config.settings['content_model_json'].nil?
        fail ArgumentError, 'Set PATH where converted content model file will be saved. View README' if config.settings['converted_model_dir'].nil?
      end
    end
  end
end
