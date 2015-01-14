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
To extract the blog content you need to [export](http://en.support.wordpress.com/export/) it from the Wordpress blog and save it as a XML file.

Further you need to define where the tool can find the XML file and the destination of the transformed data.
Create a `settings.yml` file and specify `data_dir` and `wordpress_xml_path`, eg:

``` yaml
data_dir: PATH_TO_ALL_DATA
wordpress_xml_path: PATH_TO_XML/file.xml
```

To extract the content run:

``` bash
wordpress-exporter --config-file settings.yml --extract-to-json
```

The result will be a directory structure with the Wordpress content transformed into JSON files that are ready to be imported.

Use the [generic-importer](https://github.com/contentful/generic-importer.rb) import the content to Contentful.
Default contentful structure needed to import converted wordpress data is located in the folder ``` wordpress_settings/default_contentful_structure.json ```.

## Step by step

1. Export content of blog from Wordpress and save it as XML file.
2. Create YAML file with settings (eg. settings.yml)
3. Setup required parameters in settings file:
    
    ```yml
    data_dir: PATH_TO_ALL_DATA
    wordpress_xml_path: PATH_TO_XML_FILE
    ```
    All generated data like ```content types```, ```entries```, ```assets``` will be saved at ```data_dir``` path.

4. Run command to extract data from XML file and generate default structure of content types :
    
    ```
    wordpress-exporter --config-file wordpress_settings/wordpress_settings.yml --extract-to-json
    ```
    It will extract data from XML file and save as JSON files.

    To skip the creation of the default content type structure add an additional argument ```--omit-content-model```

    ```
    wordpress-exporter --config-file wordpress_settings/wordpress_settings.yml --extract-to-json --omit-content-model
    ```
    It will extract only data from XML file.

5. (Optional). There is possibility to convert **markup** embedded in posts content to **markdown**
    
    ```
    wordpress-exporter --config-file wordpress_settings/wordpress_settings.yml --convert-markup
    ```
    Only post's content will be modified. Other attributes do not change.

6. Create files with content types structure. In directory ```wordpress_settings``` is attached ```default_contentful_strucuture.json``` file.
    Might be useful, because the structure of Wordpress is very static.
    
    ```
    wordpress-exporter --config-file wordpress_settings/wordpress_settings.yml --create-contentful-model-from-json
    ```

    Files with the content type structure will be saved at ```data_dir/collections```.

7. Use [Contentful-importer](https://github.com/contentful/generic-importer.rb) to import data to Contentful     platform.
