Wordpress to Contentful Exporter
=================

## Description
This adapter will allow you to extract content from a WordPress Blog and prepare it to be imported to [Contentful](https://wwww.contentful.com).

The following content will be extracted:

* Blog with posts
* Categories, tags and terms from custom taxonomies
* Attachments
* Authors

## Setup
To extract the blog content you need to [export](http://en.support.wordpress.com/export/) it from the WordPress blog and save it as a XML file.

Further you need to define where the tool can find the XML file and the destination of the transformed content.
Create a `settings.yml` file and fill in the `data_dir` and `wordpress_xml_path`:

``` yaml
data_dir: PATH_TO_ALL_DATA
wordpress_xml_path: PATH_TO_XML/file.xml
```

To extract the content run:

```bash
wordpress-exporter --config-file settings.yml --extract-to-json
```

The result will be a directory structure with the WordPress content transformed into JSON files that are ready for import.

Use the [generic-importer](https://github.com/contentful/generic-importer.rb) to import your blog then to Contentful.

## Step by step

1. Export the content of the blog from WordPress and save it as XML file.
2. Create YAML file with settings (eg. settings.yml) and fill in the required parameters:
   The generated `content types`, `entries` and `assets` will be saved to the `data_dir`.

3. Extract the content from the XML file and generate the content model and JSON files for the import:

    ```bash
    wordpress-exporter --config-file settings.yml --extract-to-json
    ```
    If you want to create a different content model for your blog you can use `--omit-content-model`

    ```bash
    wordpress-exporter --config-file settings.yml --extract-to-json --omit-content-model
    ```
    
    It will only extract the content and store it as JSON, you need to take care about the content mapping yourself.
    See the [Contentful-importer](https://github.com/contentful/generic-importer.rb) for details on how this needs to be done.

4. (Optional). HTML markup can be converted to markdown:

    ```bash
    wordpress-exporter --config-file settings.yml --convert-markup
    ```
    This will only touch the content body of a blog post, other attribues will not be changed.

5. Use the [Contentful-importer](https://github.com/contentful/generic-importer.rb) to import the content to [contentful.com](https://www.contentful.com)
