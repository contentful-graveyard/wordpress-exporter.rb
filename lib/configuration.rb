module Contentful
  class Configuration
    attr_reader :space_id,
                :data_dir,
                :collections_dir,
                :entries_dir,
                :assets_dir,
                :wordpress_xml

    def initialize(settings)
      @data_dir = settings['data_dir']
      @wordpress_xml = settings['wordpress_xml_path']
      validate_required_parameters
      @collections_dir = "#{data_dir}/collections"
      @entries_dir = "#{data_dir}/entries"
      @assets_dir = "#{data_dir}/assets"
      @space_id = settings['space_id']
    end

    def validate_required_parameters
      fail ArgumentError, 'Set PATH to data_dir. Folder where all data will be stored. Check README' if data_dir.nil?
      fail ArgumentError, 'Set PATH to contentful structure JSON file. Check README' if wordpress_xml.nil?
    end

  end
end