# Jodd modules

*Jodd* consist of _modules_. Each module represents an independent component;
library, tool or a micro-framework. Modules may depend on each other. Modules
also may depend on (only few!) 3rd party libraries.

*Jodd* modules are distributed in two flavors:

+ as a single _bundle_ jar, that contain all *Jodd* modules in one
distribution archive.
+ separate jar for each module.

Read [download](../download/index.html) instructions.

## Module initialization

All *Jodd* modules are initialized on startup and registered in the
central module, <var>jodd-core</var>. By default, initial registration
happens transparently, in static block of the modules classes.
All modules are expected to be found on the class path.

Initialization is important since some modules optionally depends on
others. If an optional dependency is available, it is going to be
used by a module, and more feature is then available to end users.

However, in some environments such OSGI, classloader lookup will not work.
 Then you need to _manually_ initialize used Jodd components.

## Modules list and dependencies

Here is the list of all *Jodd* modules with their dependencies.
Blue are mandatory dependencies, gray optional and light are 3rd party.

<var>jodd-bean</var> <var class='dep'>jodd-core</var>

<var>jodd-core</var>

<var>jodd-db</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-jtx</var> <var class='dep-opt'>jodd-proxetta</var> <var class='dep-opt'>jodd-props</var>

<var>jodd-http</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-upload</var>

<var>jodd-joy</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-petite</var> <var class='dep'>jodd-madvoc</var> <var class='dep'>jodd-vtor</var> <var class='dep'>jodd-jtx</var> <var class='dep'>jodd-db</var> <var class='dep'>jodd-proxetta</var> <var class='dep'>jodd-mail</var> <var class='dep'>jodd-log</var> <var class='dep'>jodd-lagarto</var>

<var>jodd-json</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-core</var>

<var>jodd-jtx</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-proxetta</var>

<var>jodd-lagarto</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-log</var>

<var>jodd-lagarto-web</var> <var class='dep'>jodd-lagarto</var> <var class='dep'>jodd-servlet</var> <var class='dep'>jodd-log</var>

<var>jodd-log</var>

<var>jodd-madvoc</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-props</var> <var class='dep'>jodd-upload</var> <var class='dep'>jodd-servlet</var> <var class='dep'>jodd-petite</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-proxetta</var>

<var>jodd-mail</var> <var class='dep'>jodd-core</var> <var class='lib'>mail</var> <var class='lib'>activation</var>

<var>jodd-petite</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-props</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-servlet</var> <var class='dep-opt'>jodd-proxetta</var>

<var>jodd-props</var> <var class='dep'>jodd-core</var>

<var>jodd-proxetta</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-log</var>

<var>jodd-servlet</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-upload</var>

<var>jodd-upload</var> <var class='dep'>jodd-core</var> <var class='dep-opt'>jodd-bean</var>

<var>jodd-vtor</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var>


