module Contentful
  module Exporter
    module Wordpress
      class Category < Blog

        def initialize(xml, config)
          @xml = xml
          @config = config
        end

        def categories_extractor
          Escort::Logger.output.puts('Extracting blog categories...')
          create_directory("#{config.entries_dir}/category")
          extract_categories
        end

        private

        def extract_categories
          categories.each_with_object([]) do |category, categories|
            normalized_category = extracted_category(category)
            write_json_to_file("#{config.entries_dir}/category/#{id(category)}.json", normalized_category)
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