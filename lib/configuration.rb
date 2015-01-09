require 'active_support/core_ext/hash'
module Contentful
  class Configuration
    attr_reader :space_id,
                :data_dir,
                :collections_dir,
                :entries_dir,
                :assets_dir,
                :wordpress_xml,
                :settings,
                :contentful_structure,
                :import_form_dir,
                :content_types

    def initialize(settings)
      @settings = settings
      @data_dir = settings['data_dir']
      validate_required_parameters
      @wordpress_xml = settings['wordpress_xml_path']
      @collections_dir = "#{data_dir}/collections"
      @entries_dir = "#{data_dir}/entries"
      @assets_dir = "#{data_dir}/assets"
      @space_id = settings['space_id']
      @contentful_structure = initialize_contentful_structure_file
      @import_form_dir = settings['import_form_dir']
      @content_types = settings['content_model_json']
    end

    def validate_required_parameters
      fail ArgumentError, 'Set PATH to data_dir. Folder where all data will be stored. View README' if settings['data_dir'].nil?
      fail ArgumentError, 'Set PATH to Wordpress XML file. View README' if settings['wordpress_xml_path'].nil?
      fail ArgumentError, 'Set PATH to contentful structure JSON file. View README' if settings['contentful_structure_dir'].nil?
    end

    def initialize_contentful_structure_file
      file_exist? ? load_ct_structure_file : create_ct_structure_file
    end

    def file_exist?
      File.exist?(settings['contentful_structure_dir'])
    end

    def create_ct_structure_file
      File.open(settings['contentful_structure_dir'], 'w') { |file| file.write({}) }
      load_ct_structure_file
    end

    def load_ct_structure_file
      JSON.parse(File.read(settings['contentful_structure_dir']), symbolize_names: true).with_indifferent_access
    end
  end
end
