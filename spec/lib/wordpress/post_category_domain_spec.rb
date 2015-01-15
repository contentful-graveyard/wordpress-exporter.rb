require 'spec_helper'
require './lib/wordpress/post_category_domain'
require './lib/wordpress/post'
require './lib/wordpress/blog'

module Contentful
  module Exporter
    module Wordpress
      describe PostCategoryDomain do
        include_context 'shared_configuration'

        before do
          xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          post = xml_doc.xpath('//item').to_a[4]
          @pc_domain = PostCategoryDomain.new(xml_doc, post, @settings)
        end

        it 'initialize' do
          expect(@pc_domain.settings).to be_kind_of Contentful::Configuration
          expect(@pc_domain.xml).to be_kind_of Nokogiri::XML::Document
        end

        it 'extract_tags' do
          tags = @pc_domain.send(:extract_tags)
          expect(tags).to be_kind_of Array
          expect(tags.count).to eq 2
          expect(tags.first).to include(id: 'tag_2656354')
          expect(tags.last).to include(id: 'tag_306830130')
        end

        it 'extract_categories' do
          categories = @pc_domain.send(:extract_categories)
          expect(categories).to be_kind_of Array
          expect(categories.count).to eq 3
          expect(categories.first).to include(id: 'category_2214351')
          expect(categories.last).to include(id: 'category_11599757')
        end
      end
    end
  end
end
