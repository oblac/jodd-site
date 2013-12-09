# Setup

<div class="doc1"><js>doc1('madvoc',20)</js></div>
*Madvoc* uses convention over configuration to make setup and
configuration simple as possible. It doesn't depend on any external
(XML) files; by default all configuration is done in plain Java.

## Installation

It is easy: put *Jodd* jars on classpath and *Madvoc* filter has to be
registered in `web.xml`\:

~~~~~ xml
    <?xml version="1.0" encoding="UTF-8"?>
    <web-app ...>
    	...
    	<filter>
    		<filter-name>madvoc</filter-name>
    		<filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
    		<init-param>
    			<param-name>madvoc.webapp</param-name>
    			<param-value>madvoc.MyWebApplication</param-value>
    		</init-param>
    		<init-param>
    			<param-name>madvoc.configurator</param-name>
    			<param-value>madvoc.MySimpleConfigurator</param-value>
    		</init-param>
    		<init-param>
    			<param-name>madvoc.params</param-name>
    			<param-value>/madvoc*.props</param-value>
    		</init-param>
    	</filter>
    	<filter-mapping>
    		<filter-name>madvoc</filter-name>
    		<url-pattern>/*</url-pattern>
    		<dispatcher>REQUEST</dispatcher>
    		<dispatcher>INCLUDE</dispatcher>
    		<!--dispatcher>FORWARD</dispatcher-->
    	</filter-mapping>
    	...
    </web-app>
~~~~~

`MadvocServletFilter` has the following optional parameters:

* `madvoc.webapp` - class name of
  *Madvoc* web application. Default is `jodd.madvoc.WebApplication`.
  Custom web applications must be a sublcass of default
  `WebApplication`.
* `madvoc.configurator` - class name of
  optional `Madvoc` configurator. Default configurator is
  `jodd.madvoc.config.AutomagicMadvocConfigurator`. Custom configurator
  is any implementation of `MadvocConfigurator` interface.
* `madvoc.params` - wildcard pattern of *Madvoc* properties files from
  classpath. Optional parameter.

The purpose of `MadvocServletFilter` is to initially create web
application, performs its initialization, and to creates and invokes the
configurator. After everything is up and ready, `MadvocServletFilter`
simply dispatches HTTP requests to `MadvocController`.

## Alternative Installation

There is another way to install *Madvoc*, using `MadvocContextListener`
instead the filter. This can be useful when you need to start web
application as early as possible. Of course, `MadvocServletFilter` still
needs to be configured, but now *Madvoc* parameters are set as context
parameters:

~~~~~ xml
    <?xml version="1.0" encoding="UTF-8"?>
    <web-app ...>

    	<listener>
    		<listener-class>jodd.madvoc.MadvocContextListener</listener-class>
    	</listener>
    	<context-param>
    		<param-name>madvoc.webapp</param-name>
    		<param-value>madvoc.MyWebApplication</param-value>
    	</context-param>
    	<context-param>
    		<param-name>madvoc.params</param-name>
    		<param-value>/madvoc.props</param-value>
    	</context-param>

    	...
    	<filter>
    		<filter-name>madvoc</filter-name>
    		<filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
    	</filter>
    	<filter-mapping>
    		<filter-name>madvoc</filter-name>
    		<url-pattern>/*</url-pattern>
    		<dispatcher>REQUEST</dispatcher>
    		<dispatcher>INCLUDE</dispatcher>
    		<!--dispatcher>FORWARD</dispatcher-->
    	</filter-mapping>
    	...
    </web-app>
~~~~~

## WebApplication

Web application is one central point for managing (i.e. registering)
*Madvoc* components and configuration. It is very first object that is
created by `MadvocServletFilter`. *Madvoc* uses
[*Petite*](/doc/petite/index.html) IoC container internally for storing
and wiring components. `WebApplication` class is very extensible, so
writing custom web applications is piece of cake.

Here is what happens during `WebApplication` initialization phase:

1.  `initWebApplication()` - initializes logger and creates *Madvoc*
    internal *Petite* container and registers itself in it. Rarely
    modified.
2.  `registerMadvocComponents()` - registers all *Madvoc* components.
    Custom and additional components may be registered after the
    registration of default components (i.e. after `super()`).
3.  `defineParams(Properties properties)` - defines parameters for
    *Madvoc* internal container. If `madvoc.params` is defined, then
    argument properties will be loaded from properties file content.
    Overridden method may add additional parameters, not defined in
    specified properties.
4.  `init(MadvocConfig, ServletContext)` - place for main *Madvoc*
    configuration. `MadvocConfig` is component that holds main global
    *Madvoc* configuration. Here user may define custom interceptor
    stack, default extension, result type and so on. Empty by default.
5.  `initActions(ActionsManager)` - intended for additional manual
    action registration and manipulation. Empty by default.
6.  `initResults(ResultsManager)` - intended for additional manual
    results registration and manipulation. Empty by default.
7.  `configure(MadvocConfigurator)` - takes `MadvocConfigurator` defined
    in `web.xml`, wires it in the internal container and invokes
    configurators `configure()` method. Rarely overridden for
    modification.

Methods `initAction` and `initResults` are just convenient helpers since
corresponding *Madvoc* component is sent as argument. Anyhow, one may
perform complete initialization and configuration in the main `init`
method.

Good practice is to always override `WebApplication` with custom
implementation from very beginning, even if empty, since good chances
are that *Madvoc* needs to be customized.
{: .example}

Here is how custom web application may looks like:

~~~~~ java
    public class MyWebApplication extends WebApplication {

    	@Override
    	public void registerMadvocComponents() {
    		super.registerMadvocComponents();
    		registerComponent(MyMadvocConfig.class);
    		registerComponent(MyRewriter.class);
    	}

    	@Override
    	protected void init(MadvocConfig madvocConfig, ServletContext servletContext) {
    		((AdaptiveFileUploadFactory) madvocConfig.getFileUploadFactory())
            .setBreakOnError(true);
    	}
    }
~~~~~

There is also destroying phase: method `destroy()` will be called when
web application is shutting down, invoked by
`MadvocServletFilter.destroy()`.

## MadvocConfigurator

Defined in `web.xml`, `MadvocConfigurator` implementation purpose is to
configure the whole web application: to register actions, results and so
on. `MadvocConfigurator` instance is wired into internal IoC container,
so all *Madvoc* components are availiable.

Default `MadvocConfigurator` implementation is
`AutomagicMadvocConfigurator`. Despite the funny name, it is really one
nice configurator. It searches the class path for all classes which
names ends with \'Action\' and \'Result\' suffixes. Each such class will
be loaded and introspected to determine if it represents valid *Madvoc*
entity and then, if so, registered into the web application.

Action class must have `@MadvocAction`. All public methods of the action
class annotated with `@Action` are registered as action methods.
Similarly, result class must be a subclass of `ActionResult` to be
registered as a result type handler.

By default, complete class path is scanned, including the content of
almost all JAR files (java runtime libraries are excluded). To speed up
the search (although usually not a big issue) and to resolve potential
access issues, it is possible to narrow the search just to important
jars or paths.

Important thing to understand is that this is just one way how *Madvoc*
may be configured. It would be very easy to create XML-based
configurator, that would read all data from some XML file rather to scan
the class path.

Extending the `AutomagicMadvocConfigurator` is another alternative way
how additional configuration can be applied to the `Madvoc`, besides
described `init` methods:

~~~~~ java
    public class MySimpleConfigurator extends AutomagicMadvocConfigurator {

    	@PetiteInject
    	MadvocConfig madvocConfig;

    	@Override
    	public void configure() {
    		super.configure();

    		// manual action configuration
    		actionsManager.register(IncognitoRequest.class, "hello", "/incognito.html");

    		// result aliasing
    		madvocConfig.registerResultAlias("/hello.all", "/hi-all");
    	}
    }
~~~~~

## Components

*Madvoc* core functionality is defined and grouped in modular units: the
components. *Madvoc* components are simple POJO java classes, wired
together in the internal [*Petite*](/doc/petite/index.html)* IoC
container. Components are registered during initialization phase of
`WebApplication`.

Following components are available:

![Petite components](components.png)

* `ActionMethodParser` - creates action configurations from action
  method and action class. Used during action method registration,
  parses action classes and scan for *Madvoc* annotations. At the end,
  builds action path from various read elements. Reads interceptor
  information as well. Creates `ActionConfig` as a result.
* `ActionPathMapper` - lookups `ActionConfig` from action path and
  request method. It also deals with supplement actions and reverse
  action mapping.
* `ActionPathRewriter` - allows action path (i.e. url) rewriting.
  Invoked before action lookup.
* `ActionsManager` - manager for all actions. Used for actions
  registration and holds all action configurations.
* `InjectorsManager` - manager for default injectors for request,
  session and context injection and outjection. Provides instances of
  all default injectors.
* `InterceptorsManager` - manager for all interceptors. Provides some
  method for working with interceptors. Interceptors are implicitly
  registered by their usage.
* `MadvocConfig` - simple global *Madvoc* configuration.
* `MadvocController` - heart and the brain of Madvoc. Lookups action
  configuration from requested action path, invokes interceptors and
  actions and renders action results.
* `ResultMapper` - Maps action results to result path.
* `ResultsManager` - manager for all results. Used for results
  registration and holds all results type handlers.
* `ScopeDataManager` - manager and cache for injection/outjection
  variables of action classes.

## Custom components

All *Madvoc* components are recognized by base class name (name of last
non-`abstract` and non-`Object` class). Therefore, replacing the
existing component is simple: just override the component and register
new class during initialization phase. *Madvoc* will recognize the base
type and corresponding component will be replaced with the new one.

*Madvoc* enforces use of existing components when creating new, modified
versions. All components are very extensible and it is easy to change
default behavior. On the other hand, it would be not so easy to write it
all again just from interfaces. So, for writing completely new
components, it is advisable to create and register new classes.

Of course, *Madvoc* is not limited to existing components - any class
may be registered in *Madvoc* and be wired with any other component.

There are several ways how *Madvoc* component may be registered. The
common and preferable way is using `registerComponent(Class)` method,
that resolves component name from top base class. On the other hand, it
is possible to register component instance with
`registerComponent(Object)` as well. Finally, both methods have variant
with explicit component name, when some component is registered with
some provided name.

## MadvocConfig

Here is the default *Madvoc* configuration:

* `actionAnnotations` - list of annotations that mark action methods.
  Default value: **\{Action.class}**
* `encoding` - encoding, used for e.g. request and response. Default
  value: **UTF-8**.
* `fileUploadFactory` - upload factory implementation, used for
  uploading files. Default: `AdaptiveFileUploadFactory`.
* `defaultResultType` - default value: `ServletDispatcherResult.NAME`.
* `defaultInterceptors` - default array of interceptors, default value:
  `ServletConfigInterceptor.class`.
* `defaultActionMethodNames` - methods names that doesn't appears in
  action path. Default value: **\{"view","execute"}**.
* `defaultExtension` - extension, default value: \'**html**\'.
* `supplementAction` - supplement action, default value: `null`.
* `createDefaultAliases` - should *Madvoc* create default aliases.
* `rootPackage` - root package, default value: `null`.
* `detectDuplicatePathsEnabled` - if set it would be not possible to
  register two actions with same action path. Default value: `true`.
* `actionPathMappingEnabled` - if set reverse action path mapping would
  be enabled. Default value: `false`.
* `preventCaching` - if *Madvoc* should prevent browser caching by
  setting response header params before rendering results. Default
  value: `true`.
* `requestScopeInjectorConfig` - just a reference to request scope
  injector configuration.
* `strictExtensionStripForResultPath` - tells result mapper to strip
  extension only if it is equal to defined one, during result path
  creation. Default value: `false`.
* `attribute*` - various *Madvoc* attributes, by default all are
  prefixed with `_m_`.

Moreover, *MadvocConfig* holds and manages map of result aliases.

This is **not** the complete set of *Madvoc* settings, just the global
ones. Each *Madvoc* component may contain its own subset of settings,
e.g.: `RequestScopeInjector` (from `InjectorsManager` component).

## Madvoc parameters

There is more convinient way for *Madvoc* configuration, suitable in
most cases. Configuration may be specified as
[parameters](/doc/petite/parameters.html) of internal *Petite*
container. Parameters may be set manually or read from the classpath (as
described above). Parameters names actually represents path in internal
container up to desired bean property that has to be setup. All
registered components may be configured this way. Here is an example of
`madvoc.properties`\:

~~~~~
    injectorsManager.requestScopeInjector.injectAttributes=false
    injectorsManager.requestScopeInjector.injectParameters=true
    madvocConfig.defaultExtension=html
~~~~~

*Madvoc* parameters are applied to all components maintained by internal
*Petite* container. But some elements are created lazy, during the
run-time, on their first use. Here we are talking about **results** and
**interceptors**. They are **not** maintained by internal *Petite*
container. Still, you are able to configure them and access via class
name:

~~~~~
    jodd.madvoc.interceptor.EchoInterceptor.enabled=false
~~~~~
