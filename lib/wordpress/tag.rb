require_relative 'blog'

module Contentful
  module Exporter
    module Wordpress
      class Tag < Blog
        attr_reader :xml, :settings

        def initialize(xml, settings)
          @xml = xml
          @settings = settings
        end

        def tags_extractor
          output_logger.info 'Extracting blog tags...'
          create_directory("#{settings.entries_dir}/tag")
          extract_tags
        end

        private

        def extract_tags
          tags.each_with_object([]) do |tag, tags|
            normalized_tag = extracted_data(tag)
            write_json_to_file("#{settings.entries_dir}/tag/#{id(tag)}.json", normalized_tag)
            tags << normalized_tag
          end
        end

        def extracted_data(tag)
          {
            id: id(tag),
            nicename: slug(tag),
            name: name(tag)
          }
        end

        def tags
          xml.xpath('//wp:tag').to_a
        end

        def id(tag)
          "tag_#{tag.xpath('wp:term_id').text}"
        end

        def slug(tag)
          tag.xpath('wp:tag_slug').text
        end

        def name(tag)
          tag.xpath('wp:tag_name').text
        end
      end
    end
  end
end
