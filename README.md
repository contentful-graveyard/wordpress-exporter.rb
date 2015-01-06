Wordpress to Contentful Exporter
=================

## Description
This adapter will allow you to extract content from a Wordpress Blog and prepare it to be imported to [Contentful](https://wwww.contentful.com).

The following will be extracted:

* Blog with posts
* Categories, tags and terms from custom taxonomies
* Attachments
* Authors

## Setup
To extract the contentn you need to [export](http://en.support.wordpress.com/export/) it from the Wordpress blog and save it as a XML file.

Further you need to define where the tool can find the XML file and the destination of the transformed data.
Create a `settings.yml` file and specify `data_dir` and `wordpress_xml_path`, eg:

``` ymld
data_dir: PATH_TO_ALL_DATA
wordpress_xml_path: PATH_TO_XML/file.xml
```

To extract the content run:

``` bash
wordpress-exporter --config-file settings.yml --extract-to-json
```

The result will be a directory structure with the Wordpress content transformed into JSON files that are ready to be imported.

Use the [generic-importer](https://github.com/contentful/generic-importer.rb) import the content to Contentful.
