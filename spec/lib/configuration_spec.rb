require 'spec_helper'
require 'yaml'
require_relative '../../lib/configuration'

module Contentful
  describe Configuration do

    it 'initialize' do

      yaml_text = <<-EOF
      data_dir: path_to_data_dir
      wordpress_xml_path: path_to_xml_file.xml
      EOF

      yaml = YAML.load(yaml_text)
      configuration = Contentful::Configuration.new(yaml)

      expect(configuration.assets_dir).to eq 'path_to_data_dir/assets'
      expect(configuration.collections_dir).to eq 'path_to_data_dir/collections'
      expect(configuration.data_dir).to eq 'path_to_data_dir'
      expect(configuration.entries_dir).to eq 'path_to_data_dir/entries'
      expect(configuration.config['wordpress_xml_path']).to eq 'path_to_xml_file.xml'
    end

  end
end
