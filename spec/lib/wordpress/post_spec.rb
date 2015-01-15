require 'spec_helper'
require './lib/wordpress/post'
require './lib/wordpress/blog'
require './lib/wordpress/post_attachment'
require './lib/wordpress/post_category_domain'

module Contentful
  module Exporter
    module Wordpress
      describe Post do
        include_context 'shared_configuration'

        before do
          @xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          @post = Post.new(@xml_doc, @settings)
        end

        it 'initialize' do
          expect(@post.settings).to be_kind_of Contentful::Configuration
          expect(@post.xml).to be_kind_of Nokogiri::XML::Document
        end

        it 'extract_data' do
          post_xml = @xml_doc.xpath('//item').to_a.first
          post = @post.send(:extract_data, post_xml)
          expect(post.count).to eq 5
          expect(post[:id]).to eq 'post_1'
          expect(post[:title]).to eq 'Informacje'
          expect(post[:wordpress_url]).to eq 'http://szpryc.wordpress.com/informacje/'
          expect(post[:created_at]).to eq Date.parse('2014-11-26')
        end

        it 'post_id(post)' do
          post = @xml_doc.xpath('//item').to_a.first
          post_id = @post.post_id(post)
          expect(post_id).to eq 'post_1'
        end
      end
    end
  end
end
