module Contentful
  module Exporter
    module Wordpress
      class PostCategoryDomain < Post

        attr_reader :post, :xml, :config

        def initialize(xml, post, config)
          @xml = xml
          @post = post
          @config = config
        end

        def extract_tags
          Escort::Logger.output.puts('Extracting post tags...')
          post_domains('category[domain=post_tag]').each_with_object([]) do |tag, tags|
            normalized_tag = normalized_data(tag, '//wp:tag')
            tags << normalized_tag unless normalized_tag.empty?
          end
        end

        def extract_categories
          Escort::Logger.output.puts('Extracting post categories...')
          post_domains('category[domain=category]').each_with_object([]) do |category, categories|
            normalized_categories = normalized_data(category, '//wp:category')
            categories << normalized_categories unless normalized_categories.empty?
          end
        end

        private

        def post_domains(domain)
          post.css(domain).to_a
        end

        def blog_domains(domain)
          xml.xpath(domain).to_a
        end

        def id(domain, prefix)
          "#{prefix}#{domain.xpath('wp:term_id').text}"
        end

        def name(domain, name_path)
          domain.xpath(name_path).text
        end

        def domain_id(domain, domain_path)
          prefix_id = prefix_id(domain_path)
          name_path = domain_path_name(domain_path)
          blog_domains(domain_path).each do |blog_domain|
            return id(blog_domain, prefix_id) if name(blog_domain, name_path) == domain.text
          end
        end

        def normalized_data(domain, path)
          {id: domain_id(domain, path)}
        end

        def prefix_id(domain_path)
          '//wp:category' == domain_path ? 'category_' : 'tag_'
        end

        def domain_path_name(domain_path)
          '//wp:category' == domain_path ? 'wp:cat_name' : 'wp:tag_name'
        end

      end
    end
  end
end
