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
        attr_reader :wordpress_xml, :settings

        def initialize(settings)
          @settings = settings
          @wordpress_xml = Nokogiri::XML(File.open(settings.wordpress_xml))
        end

        def export_blog
          Blog.new(wordpress_xml, settings).blog_extractor
        end
      end
    end
  end
end
