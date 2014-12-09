require 'time'
require 'escort'

module Contentful
  module Exporter
    module Wordpress
      class Blog < ::Escort::ActionCommand::Base

        attr_reader :xml, :config

        def initialize(xml_document, config)
          @xml = xml_document
          @config = config
        end

        def blog_extractor
          create_directory(config.data_dir)
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

        private

        def extract_blog
          Escort::Logger.output.puts('Extracting blog data...')
          create_directory("#{config.entries_dir}/blog")
          blog = extracted_data
          write_json_to_file("#{config.entries_dir}/blog/blog_1.json", blog)
        end

        def extracted_data
          {
              id: id,
              title: title,
              posts: link_entry(posts),
              categories: link_entry(categories),
              tags: link_entry(tags)
          }
        end

        def posts
          Post.new(xml, config).post_extractor
        end

        def categories
          Category.new(xml, config).categories_extractor
        end

        def tags
          Tag.new(xml, config).tags_extractor
        end

        def id
          xml.at_xpath('//wp:base_blog_url').text.match(/http:\/\/(.+)/)[1].tr('.', '_')
        end

        def title
          xml.at_xpath('//title').text
        end

      end
    end
  end
end