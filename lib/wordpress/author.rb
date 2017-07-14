require_relative 'blog'

module Contentful
  module Exporter
    module Wordpress
      class Author < Blog
        attr_reader :xml, :settings

        def initialize(xml, settings)
          @xml = xml
          @settings = settings
        end

        def author_extractor
          output_logger.info 'Extracting authors...'
          create_directory("#{settings.entries_dir}/author")
          extract_authors
        end

        private

        def extract_authors
          authors.each_with_object([]) do |author, authors|
            normalized_author = extracted_data(author)
            write_json_to_file("#{settings.entries_dir}/author/#{id(author)}.json", normalized_author)
            authors << normalized_author
          end
        end

        def extracted_data(author)
          {
            id: id(author),
            email: email(author),
            display_name: display_name(author),
            first_name: first_name(author),
            last_name: last_name(author)
          }
        end

        def authors
          xml.xpath('//wp:author').to_a
        end

        def id(author)
          "author_#{author.xpath('wp:author_id').text}"
        end

        def login(author)
          author.xpath('wp:author_login').text
        end

        def email(author)
          author.xpath('wp:author_email').text
        end

        def display_name(author)
          author.xpath('wp:author_display_name').text
        end

        def first_name(author)
          author.xpath('wp:author_first_name').text
        end

        def last_name(author)
          author.xpath('wp:author_last_name').text
        end
      end
    end
  end
end
