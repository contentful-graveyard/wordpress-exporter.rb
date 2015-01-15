require_relative 'blog'

module Contentful
  module Exporter
    module Wordpress
      class Category < Blog
        def initialize(xml, settings)
          @xml = xml
          @settings = settings
        end

        def categories_extractor
          output_logger.info 'Extracting blog categories...'
          create_directory("#{settings.entries_dir}/category")
          extract_categories
        end

        private

        def extract_categories
          categories.each_with_object([]) do |category, categories|
            normalized_category = extracted_category(category)
            write_json_to_file("#{settings.entries_dir}/category/#{id(category)}.json", normalized_category)
            categories << normalized_category
          end
        end

        def extracted_category(category)
          {
            id: id(category),
            nicename: nice_name(category),
            name: name(category)
          }
        end

        def categories
          xml.xpath('//wp:category').to_a
        end

        def id(category)
          "category_#{category.xpath('wp:term_id').text}"
        end

        def nice_name(category)
          category.xpath('wp:category_nicename').text
        end

        def name(category)
          category.xpath('wp:cat_name').text
        end
      end
    end
  end
end
