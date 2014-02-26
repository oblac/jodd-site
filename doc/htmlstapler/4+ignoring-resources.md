# Ignoring resources

Sometimes, not all resources should be stapled, i.e. bundled with
*HtmlStapler*.

Which resources to ignore?

* resources with dynamic content, that can change during the application
  execution; like some dynamically generated javascript
* resources that depends on its path. For example, some javascripts may
  try to dynamically load other javascripts located in the same folder
  or located in some subfolder. Since bundle path is changed to the
  root, this will not work any more (see example below).

To explicitly ignore a resource, add dummy parameter: `jodd-unstaple` in
the url; for example: `/dynamic.js?p1=v1&jodd-unstaple`

All links with this parameter will not be stapled into the bundle and,
therefore, not removed from the page.



## IE optional condition tags

Resources defined between IEs optional condition tags are **not**
collected into bundles. They are optional and IE only, so stapling them
does not have sense.



## Example: TinyMCE

This example gives better explanation of the above second point, when
resources should be ignored. Let's say we are using [TinyMCE editor][1].
It's javascript library that dynamically loads it's plugins, stored in various subfolders.

If we follow common usage pattern, TinyMCE javascript files will be
stored in the one subfolder under the webroot: `tiny_mce`. So, the usage
would be like this:

~~~~~ html
    <html>
    	<head>HtmlStapler + TinyMCE</head>
    	<script type="text/javascript" 
            src="/tiny_mce/tiny_mce.js"></script>
    	<script type="text/javascript">
    		tinyMCE.init({
    			...
    		});
    	</script>
    ...
~~~~~

If we run this page with *HtmlStapler* enabled, it won't work! Why?
Because the content of `tiny_mce.js` is stored in the bundle (with other
potential javascripts) and it is loaded from the different path
(`/jodd-bundle`), and not from the `tiny_mce` folder. So TinyMCE can't
find and load any plugin.

One way to solve this is to simply ignore TinyMCE from stapling by
adding the `jodd-unstaple` parameter:

~~~~~ html
    <html>
    	<head>HtmlStapler + TinyMCE</head>
    	<script type="text/javascript"
            src="/tiny_mce/tiny_mce.js?jodd-unstaple"></script>
    	<script type="text/javascript">
    		tinyMCE.init({
    			...
    		});
    	</script>
    ...
~~~~~

If you insist in having TinyMCE main JS stapled, then you have to move
subfolder from `tiny_mce` to the root so to be found. Unfortunately,
this way you loose the transparency of using *HtmlStapler*, so it is not
considered as a good idea. Better idea is to programmatically set the
correct paths (if possible) on TinyMCE initialization.

The same applies to any other JavaScript libraries, like [CKEditor][2], etc.

[1]: http://www.tinymce.com
[2]: http://ckeditor.com/

<js>docnav('htmlstapler')</js>