# Madvoc routing

*Madvoc* supports one more way to configure mappings between
action paths, actions and results. That is using
using _routes_. *Madvoc* may read a routing
file from classpath and parse routes from it.

Default file name is `madvoc-routes.txt`. There is no
strict definition of how this file looks like, we didn't
want to hardcode the syntax. Still, there are some rules
how routes are defined. Here are the rules.

## Text-related rules

If line ends with `\\`, it continues to the next line.
If line starts with the `#` it is a comment and it will be ignored.

## Action paths and methods

All paths starts with the `/`. First such path is the action path
and it must exists. Second such path is result path and its optional.

Action method is defined by first word that contains a hashchar (`#`).
Method is defined in the form: `className#methodName`.

HTTP method name can be anywhere in the line, it just has to be
a separate word.

All routes information can be quoted with single or double quotes.

Here are some routes (content is not inlined on purpose):

~~~~~
`/hello.html` "jodd.madvoc.action.HelloAction#view"
GET	/helloWorld.html 	jodd.madvoc.action.HelloAction#world
	/zigzag/${id} 		jodd.madvoc.action.ArgsAction#zigzag	/zigzag
~~~~~

It's simple as that :)

## Action Results

Action results may be specified for action or registered for global use.

To specify action result handler simply write the action result class name
(ending with `.class`) anywhere in the line, after the action path is defined:

~~~~
/book/${id}  jodd.madvoc.action.BookAction#get  jodd.madvoc.result.MyResult.class
~~~~

To define action results that should be globally available (such dispatcher,
forwarder...) just list them with class names (that ends with `.class`).
*Madvoc* router will recognize class references and process
them according to the class type.

~~~~
...
\# register results
com.myapp.MyResult.class
~~~~

Don't forget to register default *Madvoc* rules!

## Macros

Simple replacement macros are supported, too.
If a line starts with `@` and contains a `=` sign somewhere in it,
it is a macro definition. Macros are references later with macro name
and `@` as a prefix. Macros are simply replaced with their values.
Example:

~~~~~
@jma = jodd.madvoc.action
GET 	/sys/user/${id}		@jma.sys.UserAction#get		/sys/user/get
~~~~~

Here we used macro `jma` to reduce the package name into a shorter macro.

## Wrappers

Wrappers (interceptors and filter) are applied on set of routes.
They can be specified in lines that starts with `[` and ends with `]`.
For example:

~~~~~
@echo =	jodd.madvoc.interceptor.EchoInterceptor.class, \
		jodd.madvoc.interceptor.DefaultWebAppInterceptors.class

[@echo]

`/hello.html` "jodd.madvoc.action.HelloAction#view"
~~~~~

Here we used the macro `echo` to make wrapper area more visible and the whole
file cleaner.

## Aliases

Alias is the last, unprocessed word - the word that is not a path, action
method definition, HTTP method etc. For example:

~~~~~
/alpha.ciao.html 	jodd.madvoc.action.AlphaAction#ciao
/alpha.hello.html 	jodd.madvoc.action.AlphaAction#hello       hello
~~~~~

Second path is aliased with `hello`.

## Flags

Flags, like an `async` flag are defined by words prefixed with `#`. So
you just can put `#async` anywhere in the line to flag the action.

## Routing rulez

As you can see, routing format is not hard coded, but there are some
rules to follow. If you like, you can, for example,
put HTTP methods to be first or later in the line and so on.

Good practice is to mix routing with manual configuration.
Register default's manually and use routing for everything else.

Routing configuration is enabled by `RouteMadvocConfigurator`.
Routing file name can be changed in `MadvocConfig`.

<js>docnav('madvoc')</js>