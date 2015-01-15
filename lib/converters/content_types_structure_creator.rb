module Contentful
  module Converter
    class ContentTypesStructureCreator
      attr_reader :config, :logger

      def initialize(config)
        @config = config
        @logger = Logger.new(STDOUT)
      end

      def create_content_type_json_file(content_type_name, values)
        collection = {
          id: values[:id],
          name: values[:name],
          description: values[:description],
          displayField: values[:displayField],
          fields: create_fields(values[:fields])
        }
        write_json_to_file("#{config.collections_dir}/#{content_type_name}.json", collection)
        logger.info "Saving #{content_type_name}.json to #{config.collections_dir}"
      end

      def create_fields(fields)
        fields.each_with_object([]) do |(field, value), results|
          results << {
            name: create_field(field, value).capitalize,
            id: create_field(field, value),
            type: create_type_field(value),
            link_type: create_link_type_field(value),
            link: create_link_field(value)
          }.compact
        end
      end

      def create_field(field, value)
        value.is_a?(Hash) ? value[:id] : field
      end

      def create_link_type_field(value)
        value.is_a?(Hash) ? value[:link_type] : nil
      end

      def create_type_field(value)
        value.is_a?(Hash) ? value[:type] : value
      end

      def create_link_field(value)
        value.is_a?(Hash) ? value[:link] : nil
      end

      def write_json_to_file(path, data)
        File.open(path, 'w') do |file|
          file.write(JSON.pretty_generate(data))
        end
      end
    end
  end
end
