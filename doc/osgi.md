# Jodd & OSGi

All *Jodd* jars are OSGi bundles. So you can use them as any other
OSGi bundle out there.

However, there is one important thing to take care of: the _initialization_.

When used in common, non-OSGi enviroment, *Jodd* performs initialization
automatically, by finding present modules on the class path. The purpose
of *Jodd* initialization is to determine which modules are available,
so they can use each other. For example, if you have a web application
built on *Madvoc*, you may also add the <var>jodd-proxetta</var> to the
classpath - *Madvoc* will then use some *Proxetta* features to
provide even more power to the users.

In OSGi environment, each bundle is loaded by different class loader.
Therefore, *Jodd* modules can not figure what other *Jodd* modules
are available. For that reason, you need to initialize *Jodd* bundles
manually.

One way is to add an `Activator` in your bundle and do something like:

~~~~~ java
	public class Activator implements BundleActivator {

		public void start(BundleContext bundleContext) throws Exception {
			JoddCore.init();
			JoddBean.init();
			JoddUpload.init();

			System.out.println(Jodd.isModuleLoaded(Jodd.CORE));
			System.out.println(Jodd.isModuleLoaded(Jodd.BEAN));
			System.out.println(Jodd.isModuleLoaded(Jodd.UPLOAD));
			//...
		}
~~~~~

That's really all you have to do :) Of course, if you reload *Jodd* module,
you would need to re-init it again.

## Automatic activation

The very first thing we gonna do next in this are is to add `Activator`
to each *Jodd* bundle, so that you don't have to do this manually.