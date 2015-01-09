require_relative 'creator_content_types_json_files'

module Contentful
  module Converter
    class ContentfulModelToJson

      attr_reader :config

      def initialize(settings)
        @config = settings
      end

      def create_content_type_json
        puts 'Create JSON files with content types structure...'
        config.contentful_structure.each do |content_type, values|
          content_type_name = content_type_name(content_type)
          create_directory(config.collections_dir)
          CreatorContentTypesJsonFiles.new(config).create_content_type_json_file(content_type_name, values)
        end
        puts 'Done!'
      end

      def convert_to_import_form
        puts 'Converting Contentful model to Contentful import structure...'
        File.open(config.import_form_dir, 'w') { |file| file.write({}) }
        contentful_file = JSON.parse(File.read(config.content_types))['items']
        contentful_file.each do |content_type|
          parsed_content_type = {
              id: content_type['sys']['id'],
              name: content_type['name'],
              description: content_type['description'],
              displayField: content_type['displayField'],
              fields: {}.merge!(create_contentful_fields(content_type))
          }
          import_form = JSON.parse(File.read(config.import_form_dir))
          File.open(config.import_form_dir, 'w') { |file| file.write(JSON.pretty_generate(import_form.merge!(content_type['name'] => parsed_content_type))) }
        end
        puts "Done! Contentful import structure file saved in #{config.import_form_dir}"
      end

      def create_contentful_fields(content_type)
        content_type['fields'].each_with_object({}) do |(field, _value), results|
          id = link_id(field)
          results[id] = case field['type']
                          when 'Link'
                            {id: field['id'], type: field['linkType'], link: 'Link'}
                          when 'Array'
                            {id: field['id'], type: field['type'], link_type: field['items']['linkType'], link: field['items']['type']}
                          else
                            field['type']
                        end
        end
      end

      def link_id(field)
        if %w( Link Array ).include? field['type']
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

    end
  end
end