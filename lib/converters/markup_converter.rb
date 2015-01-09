require 'reverse_markdown'

module Contentful
  module Converter
    class MarkupConverter
      Encoding.default_external = 'utf-8'

      attr_reader :config, :logger

      def initialize(config)
        @config = config
        @logger = Logger.new(STDOUT)
      end

      def convert_markup_to_markdown
        Dir.glob("#{config.entries_dir}/post/*") do |post_file_path|
          logger.info("Converting #{post_file_path} markups...")
          convert_post_content(post_file_path)
        end
      end

      def convert_post_content(post_file_path)
        post_data = JSON.parse(File.read(post_file_path))
        converted_content = reverse_markdown(post_data['content'])
        post_data['content'] = replace_new_line_markup(converted_content)
        overwrite_file(post_file_path, post_data)
      end

      def reverse_markdown(content)
        ReverseMarkdown.convert content
      end

      def replace_new_line_markup(converted_content)
        converted_content.gsub("\n", "<br>")
      end

      def overwrite_file(path, data)
        File.open(path, 'w') do |file|
          file.write(JSON.pretty_generate(data))
        end
      end
    end
  end
end
