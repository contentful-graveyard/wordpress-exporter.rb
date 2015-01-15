require 'time'
require 'logger'

module Contentful
  module Exporter
    module Wordpress
      class Blog
        attr_reader :xml, :settings

        def initialize(xml_document, settings)
          @xml = xml_document
          @settings = settings
        end

        def blog_extractor
          create_directory(settings.data_dir)
          extract_blog
        end

        def link_entry(entries)
          entries.each do |entry|
            entry.keep_if { |key, _v| key if key == :id }
            entry.merge!(type: 'Entry')
          end
        end

        def link_asset(asset)
          asset.keep_if { |key, _v| key if key == :id }
          asset.merge!(type: 'File')
        end

        def create_directory(path)
          FileUtils.mkdir_p(path) unless File.directory?(path)
        end

        def write_json_to_file(path, data)
          File.open(path, 'w') do |file|
            file.write(JSON.pretty_generate(data))
          end
        end

        def output_logger
          Logger.new(STDOUT)
        end

        private

        def extract_blog
          output_logger.info('Extracting blog data...')
          create_directory("#{settings.entries_dir}/blog")
          blog = extracted_data
          write_json_to_file("#{settings.entries_dir}/blog/blog_1.json", blog)
        end

        def extracted_data
          {
            id: 'blog_id',
            title: title,
            posts: link_entry(posts),
            categories: link_entry(categories),
            tags: link_entry(tags)
          }
        end

        def posts
          Post.new(xml, settings).post_extractor
        end

        def categories
          Category.new(xml, settings).categories_extractor
        end

        def tags
          Tag.new(xml, settings).tags_extractor
        end

        def title
          xml.at_xpath('//title').text
        end
      end
    end
  end
end
