require_relative '../../lib/configuration'

RSpec.shared_context 'shared_configuration', :a => :b do
  before do
    yaml_text = <<-EOF
          data_dir: spec/fixtures/blog
          wordpress_xml_path: spec/fixtures/wordpress.xml
    EOF
    yaml = YAML.load(yaml_text)
    @config = Contentful::Configuration.new(yaml)
  end
end