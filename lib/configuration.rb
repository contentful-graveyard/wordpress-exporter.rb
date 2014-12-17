module Contentful
  class Configuration
    attr_reader :space_id,
                :config,
                :data_dir,
                :collections_dir,
                :entries_dir,
                :assets_dir

    def initialize(settings)
      @config = settings
      validate_required_parameters
      @data_dir = config['data_dir']
      @collections_dir = "#{data_dir}/collections"
      @entries_dir = "#{data_dir}/entries"
      @assets_dir = "#{data_dir}/assets"
      @space_id = config['space_id']
    end

    def validate_required_parameters
      fail ArgumentError, 'Set PATH to data_dir. Folder where all data will be stored. Check README' if config['data_dir'].nil?
    end
  end
end
