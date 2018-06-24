# Actions

Action in *Madvoc* is a user code that handles some request. The three most important terms regarding the actions are:

+ **action path** - the HTTP request path, i.e. the URL path (server name stripped);
+ **action** - handler method, mapped to an action path, processes requests; and
+ **result** - handler for whatever action method returns, provides
  a response (using e.g. JSP). Often results threat returned object
  as a _result path_.

Most of the configuration in *Madvoc* is done by convention. Remember that *Madvoc* provides equally valid way to defined everything by hand - or by custom convention.
{: .attn}

## Action path

**Action** is action _method_ defined in action class, mapped to some URL - the **action path**. *Madvoc* uses naming convention and annotations to define action path from action method. By default, action path is built from the package name, class name and method name of an action or its annotations, using the following convention:

~~~~~
    action path = /<action_package>/<action_class>.<action_method>
~~~~~

* `action_method` - part of the action path that comes from action
  method, by default it is a method name;
* `action_class` - part of the action path that comes from action class,
  by default it is un-capitalized class name with the last word
  stripped (e.g. `HelloWorldAction.class` would give `helloWorld`);
* `action_package` - optional part of the action path that comes from
  action's package.

This behavior is simple to change: either globally, either for specific action method.

## Action class & action method

The bare minimum for creating an action is putting annotations on POJO class and one of its methods that is going to handle the action path request:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public void world() {
    	}
    }
~~~~~

This action class and action method is mapped to the following action path: `/hello.world`. As said, each part of action path may be set explicitly in annotations; the following action:

~~~~~ java
    @MadvocAction("holla")
    public class HelloAction {

    	@Action("mundo")
    	public void world() {
    	}
    }
~~~~~

is mapped to `/holla.mundo`. Moreover, action paths are built by simple string concatenation, so it is possible to set more complex paths using annotations:

~~~~~ java
    @MadvocAction("foo/boo")
    public class HelloAction {

    	@Action("zoo/hello.exec")
    	public void world() {
    	}
    }
~~~~~

This action is mapped to: `/foo/boo.zoo/hello.exec`.

One action class may contain more then one actions (action methods). This happens often, especially when you have set of similar requests over the same resource.

### Action path extensions

*Madvoc* does not know about the action path extensions (`.html`, `.jpg`...). You have to map the full path you need to an action.

By default, *Madvoc* strips the `.html` from requested path if exact mapping is not found. For example, when user requests `/hello.world.html`, *Madvoc* will not find action for it and will use: `/hello.world` instead.

There is a configuration option that configures this behavior. You can set *Madvoc* to be strict and not strip `.html` by default. Or you can change which extensions should be stripped.

Why this? We could not find any reasonable convention that would define the extension value. If you think of one, let us know.

## Full action path

To override *Madvoc* action naming conventions without additional coding, just specify the full action path in the annotation by using the prefix '**/**':

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action("/bonjour-monde.html")
    	public void world() {
    	}
    }
~~~~~

Obviously, this action is mapped to `/bonjour-monde.html`. When action
path defined in `@Action` starts with '**/**' it is considered as
**full** action path and all other names (e.g. class name) are
ignored.

## Action packages

By default, packages are ignored and not used when building action paths.
Nevertheless, it make sense to group several action paths (i.e. action
classes) in one folder (i.e. package). *Madvoc* provides way how to
include packages when building action paths.

You may do this with custom `WebApp`:

~~~~~ java
    public class MyApp extends WebApp {

		@Override
		protected void configureMadvoc(MadvocConfig madvocConfig) {
    		madvocConfig
    			.getRootPackages()
    			.addRootPackageOf(IndexAction.class);
    	}
    }
~~~~~

Alternatively, you may add custom `@MadvocComponent` and configure the same during the `Init` phase.

Root package is defined by a package name and a path that package is mapped to. For web root you may omit the path. Also, the package name can be defined by passing the action class, like in above example. Therefore, above configuration snippet defines one root package (package where `IndexAction` class belongs to) mapped to the web root (`/`).

When root packages are defined, *Madvoc* will use package name of action classes relative to the build action path. The package name is relative from the root package. The following action:

~~~~~ java
    package org.jodd.madvoc.doc;

    @MadvocAction
    public class HelloAction {

    	@Action
    	public void world() {
    	}
    }
~~~~~

is mapped to `/doc/hello.world`, if the root package is defined using the `org.jodd.madvoc` package.

You can specify more then one root package. Be careful not to overlap mapping
paths!

It is possible to specify custom action package using `@MadvocAction` annotation on a package level (in the `package-info.java`). This will register the root package in the same way as we would do manually.

Sometimes developer wants to group some action classes in separate subpackages, but doesn't want to change the action path (e.g. the root path). By specifying `@MadvocAction("/")` on sub-packages *Madvoc* will map all containing classes to the web root, as they were there and not in the sub-package:

~~~~~ java
    @MadvocAction("/")
    package com.....;

    import jodd.madvoc.meta.MadvocAction;
~~~~~

## HTTP request methods

By default, *Madvoc* ignores the value of HTTP request method. No matter if it is a POST, GET or any other method, the same mapped action method will be invoked. To map only certain HTTP method, use *Madvoc* annotations, like this:

~~~~~ java
    @MadvocAction
    public class FormAction {

    	@POST @Action
    	public void store() {
    	}
    }
~~~~~

This action method is mapped to `/form.store` and will be invoked only for `POST` HTTP request methods. `GET` and others will simply return error 404 (page not found).

## Default action methods

As seen, *Madvoc* uses action method name (or annotation value) for creating the action path. It is possible to have action path that doesn't include action method name - what is often case for 'common' pages (such as `index.html`, `about.html`, `error.html`). By default, *Madvoc* will ignore action method name for methods named as `execute` and `view`. Such action methods are so-called the **default** ones. So, the following action:

~~~~~ java
    @MadvocAction
    public class IndexAction {

    	@Action
    	public void view() {
    	}
    }
~~~~~

is just mapped to `/index` (if you remember, `/index.html` would work as well).

Default action names are part of *Madvoc* configuration and can be customized.

Alternatively, `@Action` annotation value element may be set to `NONE`. Then the method name will be ignored when building action path. Therefore, following action has the same action path mapping:

~~~~~ java
    @MadvocAction
    public class IndexAction {

    	@Action(Action.NONE)
    	public void foo() {
    	}
    }
~~~~~

## Action mapping cheat-sheet

Following table summarizes the default behavior of `ActionMethodParser` - a *Madvoc* component dedicated for building action paths from registered actions.

| package | class   | method        | action path       |
|---------|---------|---------------|-------------------|
| *       | *       | /foo          | /foo              |
| *       | /boo    | foo           | /boo.foo          |
| (none)  | boo     | foo           | /boo.foo          |
| (none)  | boo     | view/execute  | /boo              |
| /zoo    | boo     | foo           | /zoo/boo.foo      |

