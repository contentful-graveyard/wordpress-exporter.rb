module Contentful
  module Exporter
    module Wordpress
      class Post < Blog

        attr_reader :xml, :config

        def initialize(xml, config)
          @xml = xml
          @config = config
        end

        def post_extractor
          Escort::Logger.output.puts('Extracting posts...')
          create_directory("#{config.entries_dir}/post")
          extract_posts
        end

        def post_id(post)
          "post_#{post.xpath('wp:post_id').text}"
        end

        private

        def extract_posts
          posts.each_with_object([]) do |post_xml, posts|
            normalized_post = extract_data(post_xml)
            write_json_to_file("#{config.entries_dir}/post/#{post_id(post_xml)}.json", normalized_post)
            posts << normalized_post
          end
        end

        def posts
          xml.xpath('//item').to_a
        end

        def extract_data(xml_post)
          post_entry = basic_post_data(xml_post)
          assign_content_elements_to_post(xml_post, post_entry)
          post_entry
        end

        def attachment(xml_post)
          PostAttachment.new(xml_post, config).attachment_extractor
        end

        def tags(xml_post)
          PostCategoryDomain.new(xml, xml_post, config).extract_tags
        end

        def categories(xml_post)
          PostCategoryDomain.new(xml, xml_post, config).extract_categories
        end

        def basic_post_data(xml_post)
          created = Date.strptime(created_at(xml_post))
          {
              id: post_id(xml_post),
              title: title(xml_post),
              wordpress_url: url(xml_post),
              content: content(xml_post),
              created_at: created
          }
        end

        def assign_content_elements_to_post(xml_post, post_entry)
          attachment = attachment(xml_post)
          tags = link_entry(tags(xml_post))
          categories =link_entry(categories(xml_post))
          post_entry.merge!(attachment: link_asset(attachment)) unless attachment.nil?
          post_entry.merge!(tags: tags) unless tags.empty?
          post_entry.merge!(categories: categories) unless categories.empty?
        end

        def title(xml_post)
          xml_post.xpath('title').text
        end

        def url(xml_post)
          xml_post.xpath('link').text
        end

        def content(xml_post)
          xml_post.xpath('content:encoded').text
        end

        def created_at(xml_post)
          xml_post.xpath('wp:post_date').text
        end

      end
    end
  end
end
