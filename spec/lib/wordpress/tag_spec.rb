require 'spec_helper'
require './lib/wordpress/tag'
require './lib/wordpress/blog'

module Contentful
  module Exporter
    module Wordpress
      describe Tag do
        include_context 'shared_configuration'

        before do
          xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          @tag = Tag.new(xml_doc, @settings)
        end

        it 'initialize' do
          expect(@tag.settings).to be_kind_of Contentful::Configuration
          expect(@tag.xml).to be_kind_of Nokogiri::XML::Document
        end

        it 'extract_tags' do
          tags = @tag.send(:extract_tags)
          expect(tags).to be_kind_of Array
          expect(tags.count).to eq 2
          expect(tags.first).to include(id: 'tag_2656354', nicename: 'testowy', name: 'testowy')
          expect(tags.last).to include(id: 'tag_306830130', nicename: 'testowy2', name: 'testowy2')
        end

        it 'extracted_data' do
          tags_xml = @tag.xml.xpath('//wp:tag').to_a
          tag = @tag.send(:extracted_data, tags_xml.first)
          expect(tag).to be_kind_of Hash
          expect(tag.count).to eq 3
          expect(tag).to include(id: 'tag_2656354', nicename: 'testowy', name: 'testowy')
        end
      end
    end
  end
end
