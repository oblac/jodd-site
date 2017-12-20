# Configuration

## MadvocConfigurator

Defined in `web.xml`, `MadvocConfigurator` implementation purpose is to
configure the whole web application: to register actions, results and so
on. `MadvocConfigurator` instance is wired into internal IoC container,
so all *Madvoc* components are available.

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


## Components

*Madvoc* core functionality is defined and grouped in modular units: the
components. *Madvoc* components are simple POJO java classes, wired
together in the internal [*Petite*](/petite/) IoC
container. Components are registered during initialization phase of
`WebApplication`.

Following components are available:

* `ActionMethodParser` - creates action configurations from action
  method and action class. Used during action method registration,
  parses action classes and scan for *Madvoc* annotations. At the end,
  builds action path from various read elements. Reads interceptor
  information as well. Creates `ActionConfig` as a result.
* `ActionPathMapper` - lookups `ActionConfig` from action path and
  request method. It also deals with reverse action mapping.
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

## Madvoc parameters

There is more convenient way for *Madvoc* configuration, suitable in
most cases. Configuration may be specified as
[parameters](/petite/parameters.html) of internal *Petite*
container. Parameters may be set manually or read from the classpath (as
described above). Parameters names actually represents path in internal
container up to desired bean property that has to be setup. All
registered components may be configured this way. Here is an example of
`madvoc.properties`:

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
