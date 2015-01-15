require 'spec_helper'
require './lib/wordpress/blog'
require './lib/wordpress/post'
require './lib/wordpress/post_attachment'
require './lib/wordpress/post_category_domain'
require './lib/wordpress/category'
require './lib/wordpress/tag'

module Contentful
  module Exporter
    module Wordpress
      describe Blog do
        include_context 'shared_configuration'

        before do
          xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          @blog = Blog.new(xml_doc, @settings)
        end

        it 'initialize' do
          expect(@blog.xml).to be_kind_of Nokogiri::XML::Document
          expect(@blog.settings).to be_kind_of Contentful::Configuration
        end

        it 'blog_extractor' do
          allow(Blog).to receive(:extract_blog)
        end

        it 'link_entry' do
          entry = [{ test: 'remove', id: 'entry_id' }, { test: 'remove', id: 'entry_id_2' }]
          link_entry = @blog.link_entry(entry)
          expect(link_entry.count).to eq 2
          expect(link_entry).to include(id: 'entry_id', type: 'Entry')
        end

        it 'link_asset' do
          asset = { test: 'remove', id: 'asset_id' }
          link_asset = @blog.link_asset(asset)
          expect(link_asset.count).to eq 2
          expect(link_asset).to include(id: 'asset_id', type: 'File')
        end

        it 'create_directory' do
          allow(File).to receive(:directory?).and_return(true)
          allow(File).to receive(:mkdir_p).with('/test/test.json').and_return(true)
          @blog.create_directory('/test/test.json')
        end

        it 'valid blog entry' do
          blog = JSON.parse(File.read('spec/fixtures/blog/entries/blog/blog_1.json'))
          expect(blog.count).to eq 5
          expect(blog['id']).to eq 'blog_id'
          expect(blog['title']).to eq 'Moj blog 2'
          expect(blog['posts'].count).to eq 7
          expect(blog['posts'].first).to include('id' => 'post_1', 'type' => 'Entry')
          expect(blog['categories'].count).to eq 4
          expect(blog['categories'].first).to include('id' => 'category_14786', 'type' => 'Entry')
          expect(blog['tags'].count).to eq 2
          expect(blog['tags'].first).to include('id' => 'tag_2656354', 'type' => 'Entry')
        end
      end
    end
  end
end
