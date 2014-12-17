require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'json'

require_relative 'blog'
require_relative 'post'
require_relative 'category'
require_relative 'tag'
require_relative 'post_category_domain'
require_relative 'post_attachment'

module Contentful
  module Exporter
    module Wordpress
      class Export
        attr_reader :wordpress_xml, :config

        def initialize(settings)
          @config = settings
          @wordpress_xml = wordpress_xml_document
        end

        def export_blog
          Blog.new(wordpress_xml, config).blog_extractor
        end

        def wordpress_xml_document
          fail ArgumentError, 'Set PATH to contentful structure JSON file. Check README' unless config.config['wordpress_xml_path']
          Nokogiri::XML(File.open(config.config['wordpress_xml_path']))
        end
      end
    end
  end
end
