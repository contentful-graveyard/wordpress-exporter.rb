require 'spec_helper'
require 'yaml'
require_relative '../../../lib/wordpress/export'
require_relative '../../support/shared_configuration.rb'

module Contentful
  module Exporter
    module Wordpress
      describe Export do

        include_context 'shared_configuration'

        before do
          @exporter = Export.new(@config)
        end

        it 'initialize' do
          expect(@exporter.config).to be_kind_of Contentful::Configuration
          expect(@exporter.wordpress_xml_document).to be_kind_of Nokogiri::XML::Document
        end

        it 'export_blog' do
          @exporter.export_blog
          expect(Dir.glob('spec/fixtures/blog/**/*').count).to eq 23
        end

      end
    end
  end
end