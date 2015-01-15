require 'spec_helper'
require './lib/wordpress/category'
require './lib/wordpress/blog'

module Contentful
  module Exporter
    module Wordpress
      describe Category do
        include_context 'shared_configuration'

        before do
          xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          @category = Category.new(xml_doc, @settings)
        end

        it 'initialize' do
          expect(@category.settings).to be_kind_of Contentful::Configuration
          expect(@category.xml).to be_kind_of Nokogiri::XML::Document
        end

        it 'extract_categories' do
          categories = @category.send(:extract_categories)
          expect(categories).to be_kind_of Array
          expect(categories.count).to eq 4
          expect(categories.first).to include(id: 'category_14786', nicename: 'bez-kategorii', name: 'Bez kategorii')
          expect(categories.last).to include(id: 'category_11599757', nicename: 'puchatka', name: 'puchatka')
        end

        it 'extracted_category' do
          categories_xml = @category.xml.xpath('//wp:category').to_a
          category = @category.send(:extracted_category, categories_xml.first)
          expect(category).to be_kind_of Hash
          expect(category.count).to eq 3
          expect(category).to include(id: 'category_14786', nicename: 'bez-kategorii', name: 'Bez kategorii')
        end
      end
    end
  end
end
