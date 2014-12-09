Wordpress to Contentful Exporter
=================

## Description
This tool will extract the following content from a Wordpress XML file of your blog’s content:

* Blog with posts
* Categories, tags and terms from custom taxonomies
* Attachments
* Authors

## Setup
To start using this tool, you need to [export blog's content](http://en.support.wordpress.com/export/) from WordPress and save as XML file.

Create settings YML file (e.g. settings.yml) and define path where all extracted data will be stored and path to XML file.

```ymld
data_dir: PATH_TO_ALL_DATA
wordpress_xml_path: PATH_TO_XML/file.xml
```

To strat extracting data from XML file, run command:
```
wordpress-exporter --config-file wordpress_settings/wordpress_settings.yml --extract-to-json
```

It will create tree folder structure with parsed Wordpress data saved as JSON files.
