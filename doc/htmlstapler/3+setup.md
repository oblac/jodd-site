# Setup

<div class="doc1"><js>doc1('htmlstapler',22)</js></div>
It's quite easy to setup *HtmlStapler*, easy like 1-2-3. Well, it's only 1-2 :)

### Step #1

Register `HtmlStaplerFilter` filter in `web.xml`\:

~~~~~ xml
    ...
    	<filter>
    		<filter-name>htmlstapler</filter-name>
    		<filter-class>jodd.htmlstapler.HtmlStaplerFilter</filter-class>
    	</filter>
    	<filter-mapping>
    		<filter-name>htmlstapler</filter-name>
    		<url-pattern>/*</url-pattern>
    	</filter-mapping>
    ...
~~~~~

### Step #2

Configure filter behavior either with filter init parameters or by
extending the filter class and configure it manually in Java.

`HtmlStaplerFilter` has one bonus feature included: HTML stripping!
{: .example}

And that is all!

## Configuration

*HtmlStapler* is quite flexible and so is the filter. Configuration is
located in filter class and in `HtmlStaplerBundlesManager`. You can
configure the following parameters (i.e. properties):

### Filter configuration

* `enabled` - turns the filter and *HtmlStapler* on and off.
* `stripHtml` - bonus feature (!): while processing HTML page,
  *HtmlStapler* can also minimize the HTML by removing the unnecessary
  spaces. For this we use *Lagarto* `StripHtmlTagAdapter`.
* `resetOnStart` - if existing bundle files should be deleted on server
  start. Default value is `true`.
* `useGzip` - default is `false`; indicates if bundles should be
  compressed using GZIP, for even more speed (more in the next page:)
* `cacheMaxAge` - value for cache response header: `max-age` (in the
  seconds). By default it's set to one month. If set to 0, header
  parameter will not be set.
* `strategy` - the name of the strategy.

### HtmlStaplerBundlesManager configuration

* `bundleFolder` - path to bundles folder where bundles files will be
  created. By default it is a system temp folder, but it is recommended
  to use *Lagarto*-specific folder.
* `staplerPath` - the path for stapler links, `jodd-bundle` by default.
* `sortResources` - flag that specifies if resource links should be
  sorted before bundle id (i.e. a digest) is created.
* `downloadLocal` - by default, local resources are copied from file
  system, using web root folder. If this does not work, local files can
  be downloaded instead.
* `localAddressAndPort` - local address and port that will be used for
  downloading local resources if specified so.
* `notFoundExceptionEnabled` - if some resource is not found (by
  developers mistake) this flag defines if the exception should be
  thrown (default behavior), or just warn message should be logged.
* `localFilesEncoding` - encoding of local files, `UTF-8` by default.

## And more...

As said, `HtmlStapler` is easy to extend.

One nice idea might be to use `FileLFUCache` for loading bundle files in
`HtmlStaplerServlet`. You can do this easily by overriding
`sendBundleFile()`.

Another idea might be to integrate javascript/css compressors - just
override `onResourceContent()`.

Consider to add a \'development\' flag that disables *HtmlStapler*
during development (`enable` property).

Not satisfied with the digest creation? Override `createDigest()` and
use your own.

If you are not sure which strategy to use, go with pragmatic
`RESOURCE_ONLY`.

