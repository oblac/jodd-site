
# Madvoc Overview

We are gonna discuss now some core concepts of how *Madvoc* works and it's infrastructure.

## Starting Madvoc

Madvoc is servlet web application.

It all starts with registering `MadvocContextListener`: either in `web.xml`, using annotation or manually. Next step: register a `MadvocServletFilter` filter.

~~~~~ xml
	<listener>
		<listener-class>jodd.madvoc.MadvocContextListener</listener-class>
	</listener>

	<filter>
		<filter-name>madvoc</filter-name>
		<filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
		<async-supported>true</async-supported>
	</filter>
	<filter-mapping>
		<filter-name>madvoc</filter-name>
		<url-pattern>/*</url-pattern>
		<dispatcher>REQUEST</dispatcher>
	</filter-mapping>
~~~~~

If you use other *Jodd* frameworks in your app, consider using [Joy](/joy). It is full-featured web app bootstrap.
{: .attn}


## WebApp

`WebApp` is the central point for running *Madvoc* components. It is the very first object created by *Madvoc*. `WebApp` class is very extensible, so writing custom web applications is piece of cake.

`WebApp` is used to register all *Madvoc* components, define parameters, set routes... You may use it to configure almost everything in the application. However, most of the things can be registered and configured using just annotations and without touching the `WebApp`. Which way to use is up to you.

### Custom WebApp

To provide custom implementation of `WebApp`, just set the context parameter in `web.xml` named: `madvoc.webapp`.

## Madvoc Components

The whole *Madvoc* infrastructure consist of the _components_. Almost any feature is extracted and encapsulated into a separate component. You can simply override any existing component or register a new one if you need so.

*Madvoc* components are marked with `@MadvocComponent` and, by default, they are registered automatically from the classpath. Any class annotated with this annotation becomes a *Madvoc* component. You can have as many components as you want. So what you can do with *Madvoc* components? Like we said, you can override existing components to change the default behavior. Or you can add new components that simply configure existing ones. Custom *Madvoc* component may be also used for registering the _web components_. And so on - practically, you have the full power over the *Madvoc* infrastructure.

*Madvoc* uses *Petite* container internally for storing and wiring *Madvoc* components. This means that *Madvoc* components can be easily injected into each other: just use `@PetiteInject` annotation and the instance of referenced component will be injected once when component instance is created.


## Web Components

While *Madvoc* components are designed for the infrastructure, the so-called "_web components_" are meant for the user's web application. Web components are actions, filters, interceptors... that compose together the web application. Here is a diagram how they are related:

<div class="clearfix">

<div style="width:80px; background:#fcc; padding: 40px 10px; margin: 60px 10px 10px 0; text-align:center; float:left;border: 1px solid #999"><b>action path</b></div>

<div style="padding: 100px 0 0 0; margin: 0; float:left"><i class="fa fa-arrow-right"></i></div>

<div style="width:120px; background:#eee; padding: 40px 10px; margin: 60px 10px 10px 10px; text-align:center; float:left;border: 1px solid #999"><b>MadvocController</b></div>

<div style="padding: 100px 0 0 0; margin: 0; float:left"><i class="fa fa-arrow-right"></i></div>

<div style="width:250px; background:#ddf; padding: 10px ; margin: 20px 10px 10px 10px; float:left; border: 1px solid #999"><div><b>Filters</b></div>

    <div style="width:90px; background:#ccf; padding: 10px ; margin: 20px 10px 10px 10px; float:left; border: 1px solid #999"><b>Interceptors</b>

        <div style="width:40px; background:#ffc; padding: 21px 10px; margin: 10px; text-align:center; border: 1px solid #999"><b>Action</b></div>
    </div>

    <div style="padding: 70px 0 0 0; margin: 0; float:left"><i class="fa fa-arrow-right"></i></div>

    <div style="width:60px; background:#cfc; padding: 40px 10px; margin: 20px 10px 10px 10px; text-align:center; float:left;border: 1px solid #999"><b>Result</b></div>
</div>

</div>

`MadvocController` is the *Madvoc* component that receives a HTTP request and lookups for the `Action` instance for requested action path. If action path is registered, `MadvocController` instantiates new `ActionRequest` - encapsulation of the actual request and action's method proxy.

_Interceptors_ intercept the requests before it comes to an action and after the action has finished the handling. In some cases, interceptor might disable execution of an action. Interceptors can also change the state of an action before it executes.

Once execution of the action and all interceptors is complete, the action request is sent to an _result_ handler to render the results.

_Filters_ works similar as interceptors, except they wrap execution of both actions and results. They are similar to servlet filters.


## Component Lifecycle

Each component may go through the following phases of a component's lifecycle. Note an important difference: when a component is registered as part of the lifecycle, it will be instantiated before it will be actually used!

+ `Init` - during the initialization phase *Madvoc* components are being registered. If your component depends on the other components, this is **not** a phase you want to use: dependent components may be not initialized yet!

+ `Start` - all *Madvoc* components are registered. Web application is being loaded. Like in previous phase, should not use any web component (action, filter, interceptor, result...) during this phase. However, you may register new web components.

+ `Ready` - both *Madvoc* and web components are registered. Now you can initialize your application.

+ `Stop` - this phase happens during the shutdown.


## Ready?

This was a short overview of how *Madvoc* works. Now we can deep dive into building the web application. Let's go!