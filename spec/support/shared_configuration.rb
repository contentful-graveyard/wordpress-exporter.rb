require_relative '../../lib/configuration'

RSpec.shared_context 'shared_configuration', a: :b do
  before do
    yaml_text = <<-EOF
          data_dir: spec/fixtures/blog
          wordpress_xml_path: spec/fixtures/wordpress.xml
          contentful_structure_dir: spec/fixtures//default_contentful_structure.json
    EOF
    yaml = YAML.load(yaml_text)
    @settings = Contentful::Configuration.new(yaml)
  end
end
