require_relative 'post'

module Contentful
  module Exporter
    module Wordpress
      class PostAttachment < Post
        attr_reader :post, :settings

        def initialize(post, settings)
          @post = post
          @settings = settings
        end

        def attachment_extractor
          create_directory("#{settings.assets_dir}/attachment_post")
          asset = { id: attachment_id, description: attachment_description, url: attachment_url }
          unless asset[:url].nil?
            write_json_to_file("#{settings.assets_dir}/attachment_post/#{attachment_id}.json", asset)
            asset
          end
        end

        private

        def attachment_url
          post.at_xpath('wp:attachment_url').text unless post.at_xpath('wp:attachment_url').nil?
        end

        def attachment_id
          "attachment_#{post_id(post)}"
        end

        def attachment_description
          meta_arr = post.xpath('wp:postmeta').to_a
          unless meta_arr.empty?
            meta_arr.each do |meta|
              return meta.at_xpath('wp:meta_value').text if meta.at_xpath('wp:meta_key').text == '_wp_attachment_image_alt'
            end
          end
        end
      end
    end
  end
end
