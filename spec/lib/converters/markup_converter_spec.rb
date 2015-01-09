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
        allow(JSON).to receive(:parse) { {'content' => '<strong>TEST</strong>'} }
        expect_any_instance_of(MarkupConverter).to receive(:reverse_markdown).with('<strong>TEST</strong>') { '**TEST**' }
        expect_any_instance_of(MarkupConverter).to receive(:replace_new_line_markup).with('**TEST**')
        @converter.convert_post_content('post_file_path')
      end

      it 'reverse_markdown' do
        content = '<em>italic text</em> <strong>Bold text</strong> <code> int a = 1 </code>'
        result = @converter.reverse_markdown(content)
        expect(result).to eq '_italic text_ **Bold text** ` int a = 1 `'
      end

      it 'replace new line markup to <br>' do
        result = @converter.replace_new_line_markup("Some \n\n Text \n Test\n")
        expect(result).to eq 'Some <br><br> Text <br> Test<br>'
      end

    end
  end
end
