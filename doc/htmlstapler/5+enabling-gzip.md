# Enabling GZip

Using GZIP response is a common tool for reducing the number of bytes
sent over the \'wire\', to gain better performances. Using GZIP filter
with *HtmlStapler* will work, of course, but there is room for more
optimization! Why gzipping the bundle content every time requested?

For those who want to gain some CPU clocks, *HtmlStapler* and
`GZIPFilter` can be configured in such way so all bundles are gzipped
ones, on creation. When requested, the gzipped bundle content is
returned. Let's see how.

## GZIP filter

Enable `GZIPFilter` in the `web.xml`, but configure it to ignore the
stapler bundle paths:

~~~~~ xml
    ...
    	<filter>
    		<filter-name>gzip</filter-name>
    		<filter-class>jodd.servlet.filter.GzipFilter</filter-class>
    		<init-param>
    			<param-name>threshold</param-name>
    			<param-value>128</param-value>
    		</init-param>
    		<init-param>
    			<param-name>match</param-name>
    			<param-value>*</param-value>
    		</init-param>
    		<init-param>
    			<param-name>exclude</param-name>
    			<param-value>/jodd-bundle</param-value>
    		</init-param>
    	</filter>
    	<filter-mapping>
    		<filter-name>gzip</filter-name>
    		<url-pattern>/*</url-pattern>
    	</filter-mapping>
    ...
~~~~~

We assume that *HtmlStapler* filter is configured to use default
`/jodd-bundle` path.

## HtmlStaplerFilter

Now, let's turn on the gzip feature for `HtmlStaplerFilter`.

~~~~~ xml
    	<filter>
    		<filtr-name>jodd-html-stapler</servlet-name>
    		<filter-class>jodd.htmlstapler.HtmlStaplerFilter</filter-class>
    		<init-param>
    			<param-name>useGzip</param-name>
    			<param-value>true</param-value>
    		</init-param>
    	</filter>
    	<filter-mapping>
    		<filter-name>jodd-html-stapler</filter-name>
    		<url-pattern>/*</url-pattern>
    	</filter-mapping>
    ...
~~~~~

Enjoy extra speed!

<js>docnav('htmlstapler')</js>