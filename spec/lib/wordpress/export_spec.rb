require 'spec_helper'
require 'yaml'
require './lib/wordpress/export'

module Contentful
  module Exporter
    module Wordpress
      describe Export do
        include_context 'shared_configuration'

        before do
          @exporter = Export.new(@settings)
        end

        it 'initialize' do
          expect(@exporter.settings).to be_kind_of Contentful::Configuration
          expect(@exporter.wordpress_xml).to be_kind_of Nokogiri::XML::Document
        end

        it 'export_blog' do
          @exporter.export_blog
          expect(Dir.glob('spec/fixtures/blog/**/*').count).to eq 23
        end
      end
    end
  end
end
