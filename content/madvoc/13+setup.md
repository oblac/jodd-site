# Configuration

## AutomagicMadvocConfigurator

Despite the funny name, it is really one nice *Madvoc* component. It searches the class path for all classes which names ends with `Action` suffixes. Each such class will be loaded and introspected to determine if it represents valid *Madvoc* entity and then, if so, registered into the web application.

Action class must have `@MadvocAction` annotation in order to be registered this way. All public methods of the action class annotated with `@Action` are registered as action methods. Similarly, result class must be a subclass of `ActionResult` to be registered as a result type handler.

By default, complete class path is scanned, including the content of almost all JAR files (java runtime libraries are excluded). To speed up the search (although usually not a big issue) and to resolve potential access issues, it is possible to narrow the search just to important jars or paths.

Important thing to understand is that this is just one way how *Madvoc* may be configured. You can simply ignore the magic and performan manual registration of the actions.

## Madvoc parameters

*Madvoc* components may be configured by `madvoc.props` - file with [parameters](/petite/parameters.html). Parameter names actually represents the path in internal container up to desired bean property that has to be setup. All registered components may be configured this way.

~~~~~
    injectorsManager.requestScopeInjector.injectAttributes=false
    injectorsManager.requestScopeInjector.injectParameters=true
    actionsManager.pathMacroClass=jodd.madvoc.macro.RegExpPathMacros
    asyncActionExecutor.foo=3
~~~~~

Web components are configured by their short class name:

~~~~~
    appendingInterceptor.enabled=false
~~~~~

## What can be configured?

There is no single point of configuration in *Madvoc*. To make configuration more visible, all configuration is set in `*Cfg` classes. They do not have any special purpose - it is just a way to group them for each component and to make them more visible to the users.