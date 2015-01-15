require 'spec_helper'
require './lib/converters/markup_converter'
require 'logger'

module Contentful
  module Converter
    describe MarkupConverter do
      include_context 'shared_configuration'

      before do
        @converter = MarkupConverter.new(@settings)
      end

      it 'convert_markup_to_markdown' do
        expect_any_instance_of(MarkupConverter).to receive(:convert_post_content).exactly(7).times
        @converter.convert_markup_to_markdown
      end

      it 'convert post content' do
        allow(File).to receive(:open)
        allow(File).to receive(:read).with('post_file_path')
        allow(JSON).to receive(:parse) { { 'content' => '<strong>TEST</strong>' } }
        @converter.convert_post_content('post_file_path')
      end
    end
  end
end
