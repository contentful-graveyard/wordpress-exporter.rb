require 'active_support/core_ext/hash'
module Contentful
  class Configuration
    attr_reader :space_id,
                :data_dir,
                :collections_dir,
                :entries_dir,
                :assets_dir,
                :wordpress_xml,
                :settings

    def initialize(settings)
      @settings = settings
      @data_dir = settings['data_dir']
      validate_required_parameters
      @wordpress_xml = settings['wordpress_xml_path']
      @collections_dir = "#{data_dir}/collections"
      @entries_dir = "#{data_dir}/entries"
      @assets_dir = "#{data_dir}/assets"
      @space_id = settings['space_id']
    end

    def validate_required_parameters
      fail ArgumentError, 'Set PATH to data_dir. Folder where all data will be stored. View README' if settings['data_dir'].nil?
      fail ArgumentError, 'Set PATH to Wordpress XML file. View README' if settings['wordpress_xml_path'].nil?
    end
  end
end
