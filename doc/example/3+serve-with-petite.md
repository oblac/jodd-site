# Serve with Petite

<div class="doc1"><js>doc1('example',22)</js></div>
We have two goals here: to build service layer within *Petite* container
and to merge it with the our *Madvoc* web application. Of course, it is
vital to have Petite completely decoupled from web layer.

## Plain Old Service Core

Now, let's forget we are building a web application. We want to build a
business core of the application that can be started from the command
line (and tests cases). Lets encapsulate the application core in
`AppCore` class, that will be responsible for application lifecycle and
configuration. During the startup, `AppCore` will create and configure
the *Petite* container. One possible implementation may look like this:

~~~~~ java
    public class AppCore {

    	public void start() {
    		AppUtil.resolveDirs();
    		initLogger();
    		initPetite();
    		initDb();
    		// init everything else
    	}

    	public void stop() {
    		// close everything
    	}

    	protected PetiteContainer petite;

    	void initPetite() {
    		petite = new PetiteContainer();
    		AutomagicPetiteConfigurator pcfg = new AutomagicPetiteConfigurator();
    		pcfg.setIncludedEntries(this.getClass().getPackage().getName() + ".*");
    		pcfg.configure(petite);
    	}

    	/**
    	 * Returns application container (Petite).
    	 */
    	public PetiteContainer getPetite() {
    		return petite;
    	}
    	...
    }
~~~~~

Let's analyze `AppCore`. Upon application start, it resolve various
paths so we learn where the log folder is, where are properties etc. We
will not use this and will hardcore all the paths needed. Next thing,
various frameworks are going to be initialized as well. Usually the
logger is initialized first, so we can track what is going on as soon as
possible. As this is not part of the *Jodd*, we will skip any further
explanation and go to *Petite* initialization.

Finally, *Petite* container is created (method `initPetite()`).
Immediately after creation, *Petite* container is auto-configured using
`AutomagicPetiteConfigurator`. This
configuration scans the class path for all classes that are annotated
with `PetiteBean` annotation. Since classpath of web application may
contain many jars, we can speed up the scanning process by narrowing the
search only to certain packages. In our example, the configurator simply
scans for all packages that are bellow the package of `AppCore` - we
assume that services are somewhere bellow.

This is just one way of doing things; what matters here is the
**concept** and not the concrete values, structure or configuration used
in example.
{: .example}

That is all, *Petite* is ready for use and upon start it will find all
annotated services. Even if we don't have any service at the moment, we
can pretend that we have the full-blown application container/context
ready. We just need to find a way how to integrate it into previously
created web layer.

## Integrate Madvoc and Petite

Let's integrate *Madvoc* and *Petite* application context.

*Jodd* already provides support for this integration by
`PetiteWebApplication`, a *Petite*-ready web application class. As you
remember, we already made `AppWebApplication` for our custom needs. So
now we need to make it *Petite*-aware, i.e. to extends
`PetiteWebApplication` instead of just `WebApplication`.

By default, `PetiteWebApplication` creates it's own *Petite* container
instance that will be used as application context. Sine we have our
container instance in `AppCore`, we need to change default behavior of
`PetiteWebApplication` and use existing container from `AppCore`. It is
nothing hard, just a matter of overriding `providePetiteContainer()`.

Here is how our `AppWebApplication` might look like, integrated with the
`AppCore`\:

~~~~~ java
    public class AppWebApplication extends PetiteWebApplication {

    	final AppCore appCore;

    	public AppWebApplication() {
    		appCore = new AppCore();
    		appCore.start();
    	}

    	@Override
    	protected PetiteContainer providePetiteContainer() {
    		return appCore.getPetite();
    	}

    	@Override
    	protected void destroy(MadvocConfig madvocConfig) {
    		appCore.stop();
    		super.destroy(madvocConfig);
    	}
    }
~~~~~

And that is all: *Petite*-aware *Madvoc* web application. You will see
later how this integration actually works, now we need to add some
services.

## Simple service

Let's add an empty service:

~~~~~ java
    @PetiteBean
    public class FooService {
    }
~~~~~

Our business service is just a POJO, annotated with `@PetiteBean`
annotation. And that is all! *Petite* configurator will find all such
classes on the classpath and register them into the container.

## Service injection

Since *Madvoc* is integrated with *Petite*, we can injected our service
in the previously created `IndexAction` in this way:

~~~~~ java
    @MadvocAction
    public class IndexAction {

    	@PetiteInject
    	FooService fooService;

    	@Action
    	public void view() {
    		System.out.println(fooService);
    	}
    }
~~~~~

Injection is done just by using the `@PetiteInject` annotation on a
field! Of course, you can add setter/getter for the service field, but
usually we don\'t: we like to have our actions smaller as possible.

Note: by default, field name must match lowercased bean class name.

Hey, hurrey, it\'s starting time again! Run the Tomcat. You will notice
in the log that *Petite* bean is also registered:

~~~~~
INFO jodd.petite.config.AutomagicPetiteConfigurator - Petite configured in 47 ms. Total beans: 1
INFO jodd.madvoc.Madvoc - Madvoc starting...
INFO jodd.madvoc.Madvoc - Madvoc web application: jodd.example.AppWebApplication
INFO jodd.madvoc.Madvoc - Loading Madvoc parameters from: /madvoc.props
INFO jodd.madvoc.Madvoc - Configuring Madvoc using default automagic configurator
INFO jodd.madvoc.config.AutomagicMadvocConfigurator - Madvoc configured in 109 ms. Total actions: 1
INFO jodd.madvoc.Madvoc - Madvoc is up and running.
~~~~~

Go to `/index.html` page and you will see in the console that
`fooService` field is initialized, meaning that integration and injection
works perfectly!

## LocalRunner

As you've noticed, our business layer is decoupled from the web layer.
ood practice at this time is to build simple console-mode application
where we can play with the application services without starting the
Tomcat! Something like this:

~~~~~ java
    public class LocalRunner {

    	public static void main(String[] args) {
    		AppCore appCore = new AppCore();
    		appCore.start();
    		PetiteContainer pc = appCore.getPetite();

    		FooService fooService = (FooService) pc.getBean("fooService");
    		System.out.println(fooService);

    		appCore.stop();
    	}
    }
~~~~~

If you run this, you will see that we can reach services from the
command line application, out of container scope. Nice!

## Load parameters

Now back to the *Petite* container configuration. Usually, some of our *Petite* beans should be
configured by properties files stored on the classpath. For this
example, we will put all parameters into several properties files on
classpath root: `app.props`, `app-db.props` and so on. (Again, we are
using *Jodd* super properties, props.) Lets modify `initPetite()`
method:

~~~~~ java
    public class AppCore {
    	...
    	void initPetite() {
    		log.info("petite initialization");
    		petite = new PetiteContainer();

    		// automatic configuration
    		AutomagicPetiteConfigurator pcfg = new AutomagicPetiteConfigurator();
    		pcfg.setIncludedEntries(this.getClass().getPackage().getName() + ".*");
    		pcfg.configure(petite);

    		// load parameters
    		Props appProps = new Props();
    		appProps.loadSystemProperties("sys");
    		appProps.loadEnvironment("env");
    		PropsUtil.loadFromClasspath(appProps, "/app*.prop*");

    		petite.defineParameters(appProps);

    		// add appCore to Petite (and resolve parameters)
    		petite.addBean("app", this);
    	}
    	...
    }
~~~~~

Here we do many things. We first load system and environment variables
into props. The we load all `/app*.prop*` files from the classpath. This
includes both *Jodd* props and Java properties! All this properties will
be loaded from the files and injected into the beans!

Furthermore, we added a nice trick: `AppCore` instance is added to the
container. This way we can refer the `AppCore` instance in the
configuration `with `properties named as "`app.*`".

Don't forget to configure your IDE to copy `*.props` files to the
output folder!
{: .attn}

## Enable session scope beans

Even if not yet sure if we gonna needed, we can enable*Petite* to use
session scoped beans. The following listeners have to be registered in
`web.xml`\:

~~~~~ xml
    ...
    <!--listeners-->
    <listener>
    	<listener-class>jodd.servlet.RequestContextListener</listener-class>
    </listener>
    <listener>
    	<listener-class>jodd.servlet.HttpSessionListenerBroadcaster</listener-class>
    </listener>
    ...
~~~~~

Once when we actually add some session scoped bean, we will not be able
to run application outside of servlet container (as we don't have
session in the command line). To solve this problem, we need first to
detect if we are running under the servlet container. There are many
ways to do so, one is to detect if there is a WEB-INF string in the file
path of some file on the classpath. Next step os to replace tje session
scope with, e.g. prototype scope:

~~~~~ java
    public class AppCore {

    	protected boolean isWebApplication;

    	void initPetite() {
    		log.info("petite initialization");
    		petite = new PetiteContainer();
    		if (isWebApplication == false) {
    			petite.getManager().registerScope(SessionScope.class, new ProtoScope());
    		}
    		...
    	}

    }
~~~~~

## Recapitulation

We learned here how it is easy to create *Petite* container and register
beans. For web applications, such one we are building in this example,
there is a simple way how to integrated *Petite* container with
*Madvoc*. Once integrated, injection of container services into web
actions is just mater of declaration. Finally, we have learned how to
load *Petite* properties and how to enable configuration for session
scoped beans.
