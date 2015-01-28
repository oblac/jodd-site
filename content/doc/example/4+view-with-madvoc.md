# View with Madvoc

The first step of this example will be to just enable *Madvoc* and prepare it for future enhancements.

## web.xml

Lets register *Madvoc* in `web.xml`.

~~~~~ xml
	...
	<!-- madvoc -->
	<filter>
		<filter-name>madvoc</filter-name>
		<filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
	</filter>
	<filter-mapping>
		<filter-name>madvoc</filter-name>
		<url-pattern>/*</url-pattern>
		<dispatcher>REQUEST</dispatcher>
	</filter-mapping>
	...
~~~~~

This is the minimal *Madvoc* configuration. Remember that *Madvoc*
may be also registered using servlet context listeners.

## Index action

Lets add an empty index action.

~~~~~ java
    import jodd.madvoc.meta.MadvocAction;
    import jodd.madvoc.meta.Action;

    @MadvocAction
    public class IndexAction {

    	@Action
    	public void view() {
    	}

    }
~~~~~

Now action path `/index.html` is mapped to `IndexAction#view()` action
that renders `index.jsp`.

## Index JSP view

The only thing left is the JSP page, `index.jsp`, that will be executed
as the result of above index action:

~~~~~ html
    <html>
    <head>
    	<title>Jodd</title>
    </head>
    <body>
    ...hello madvoc...
    </body>
    </html>
~~~~~

## Run!

Go ahead, your first web application is done, run Tomcat! You should see
something like this in the console:

~~~~~
INFO jodd.madvoc.Madvoc - Madvoc starting...
INFO jodd.madvoc.Madvoc - Default Madvoc web application created.
INFO jodd.madvoc.Madvoc - Configuring Madvoc using default automagic configurator
INFO jodd.madvoc.config.AutomagicMadvocConfigurator - Madvoc configured in 150 ms. Total actions: 1
INFO jodd.madvoc.Madvoc - Madvoc is up and running.
~~~~~

This means everything is just fine. Open your browser and go to
`http://localhost:8080/index.html`. You should see your text from JSP:)

## Madvoc action as welcome file

Tomcat can't use *Madvoc*s action (or any \'dynamic\' paths) as a
welcome file (default file that will be used when no specific file is
specified in the URL). To make `/index.html` to be one of welcome files,
we need to redirect to it from simple JSP page:

web.xml:

~~~~~ xml
    ...
    <welcome-file-list>
    	<welcome-file>redirect.jsp</welcome-file>
    </welcome-file-list>
    ...
~~~~~

redirect.jsp:

~~~~~ html
    <%%
    	jodd.servlet.DispatcherUtil.redirect(request, response, "/index.html");
    %>
~~~~~

Now (after the Tomcat restart, of course) you can navigate just to:
`http://localhost:8080` and your index action will be invoked.

## Use the same encoding

*Madvoc* and JSP should use the same encoding, which is by default
UTF-8. We can set encoding for all JSP files in `web.xml`\:

~~~~~ xml
    ...
    <jsp-config>
    	<jsp-property-group>
    		<url-pattern>*.jsp</url-pattern>
    		<page-encoding>UTF-8</page-encoding>
    	</jsp-property-group>
    </jsp-config>
    ...
~~~~~

Last two steps are just common tasks, that will keep things in order.
Now we are ready to continue.

## Custom web application

Minimal *Madvoc* configuration is often not enough. We will immediately
extend it; doing this early is consider as a good practice. Note that in
*Jodd*, all customization is done using pure Java, usually by extending
some classes. The same applies here - we will add our `AppWebApplication` by
extending the `WebApplication` and register it in `web.xml`.

~~~~~ java
    import jodd.madvoc.WebApplication;

    /**
     * Web application.
     */
    public class AppWebApplication extends WebApplication {
    }
~~~~~

Registerd new web appication class in `web.xml`:

~~~~~ xml
    ...
    <filter>
    	<filter-name>madvoc</filter-name>
    	<filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
    	<init-param>
    		<param-name>madvoc.webapp</param-name>
    		<param-value>jodd.example.AppWebApplication</param-value>
    	</init-param>
    </filter>
    ...
~~~~~

Now we are ready to extend and customize the *Madvoc*.

## Parameters

Although it is possible to configure *Madvoc* in Java, it make sense to
put some configuration in properties, more human-readable file. Let's
enable *Madvoc* file parameters, just in case we need them later.

~~~~~ xml
    ...
    <filter>
    	<filter-name>madvoc</filter-name>
    	<filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
    	<init-param>
    		<param-name>madvoc.webapp</param-name>
    		<param-value>jodd.example.AppWebApplication</param-value>
    	</init-param>
    	<init-param>
    		<param-name>madvoc.params</param-name>
    		<param-value>/madvoc.props</param-value>
    	</init-param>
    </filter>
    ...
~~~~~

Add an empty `madvoc.props` file to classpath or resource root. We gonna put
some *Madvoc* parameters in there later. Note that we are using *Props*, our
own solution for super-properties. For now just treat it as a regular
properties file, except it is UTF-8 encoded.

## Input and output

The major thing about web frameworks is how to receive and set
parameters. This is so easy with *Madvoc*, so that the following code is
self explanatory:

~~~~~ java
    import jodd.madvoc.meta.MadvocAction;
    import jodd.madvoc.meta.Action;

    @MadvocAction
    public class IndexAction {

    	@In
    	String name;

    	@Out
    	String world;

    	@Action
    	public void view() {
    		if (name != null) {
    			world = name.toUpperCase();
    		}
    	}
    }
~~~~~

And the appropriate `index.jsp` change:

~~~~~ html
    <html>
    <head>
    	<title>Jodd</title>
    </head>
    <body>
    ...hello ${world}...
    </body>
    </html>
~~~~~

Simple, right?! Now open following url:
`http://localhost:8080/index.html?name=madvoc` and the resulting page
will contain the uppercased name.

Yeah!

## Recapitulation

We have configured one *Madvoc* action, for the index page. We also set
some common Tomcat stuff for development. Finally, we extended
*Madvoc* and enabled props file, in order to be able to configure it
later easily.
