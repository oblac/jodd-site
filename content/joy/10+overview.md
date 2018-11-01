# Joy Overview

*Joy* configures all *Jodd* micro-frameworks and binds them to work together.

## Custom Joy

While *Joy* runs with the `JoyContextListener`, the main class is `JoddJoy`. This class runs *Jodd* micro-frameworks and connects them together. To access the `JoddJoy` and add your own additional configuration, you need to extends the listener:

~~~~~java
    @WebListener
    public class AppContextListener extends JoyContextListener {
        protected JoddJoy createJoy() {
            final JoddJoy joy = super.createJoy();
            // add custom configuration and settings here
            return joy;
        }
    }
~~~~~

## Settings

Before going further, note that vast configuration can be set in `joy.props` files. You can have one or more files, it is important just to be correctly prefixed.

For example:

~~~~~
    joy.db.pool.driver=${jdbc.driverClassName}
    joy.db.pool.url=${jdbc.url}
    ...

    joy.db.query.debug=true
    joy.db.query.type=FORWARD_ONLY

    joy.db.oom.tableNames.prefix=jd_

    [joy.madvoc]
    madvocController.welcomeFile=/index.jsp
    requestScope.injectAttributes=true
~~~~~

Of course, everything can be set through the code.

## IOC container

*Joy* will scan the classpath for all the class annotated with `@PetiteBean` and add them to the *Joy* container.

## Proxies

By default, there is only one single proxy enabled: the one that looks for transaction annotations and wraps the call in the database transaction.

## Database

By default, *Joy* assumes relational database is in use. If so, just add the default configuration:

~~~~~
    # database
    jdbc.driverClassName=com.mysql.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/jodd-tutorial?useSSL=false
    jdbc.username=root
    jdbc.password=root!

    # db pool
    dbpool.driver=${jdbc.driverClassName}
    dbpool.url=${jdbc.url}
    dbpool.user=${jdbc.username}
    dbpool.password=${jdbc.password}
    dbpool.maxConnections=50
    dbpool.minConnections=5
    dbpool.waitIfBusy=true
~~~~~

If database is not in use, or if you simply don't want to use *DbOom* - just remove the settings.

## Configuring Joy

There are multiple ways how to configure and use *Jodd* micro-frameworks. You can use properties file or annotations or just plain java.

In *Joy*, you can simply use the same listener: `AppContextListener` as we shown above.

~~~~~java
    @WebListener
    public class AppContextListener extends JoyContextListener {
        @Override
        protected JoddJoy createJoy() {
            return JoddJoy.get()
                .withDb(joyDb -> ...)
                .withPetite(joyPetite -> ...)
                .withWebApp(webApp -> ...);
        }
    }
~~~~~

`JoddJoy` `with()` methods return a convenient wrapper over the *Jodd* micro-framework component. This wrapper holds some *Joy*-related configuration. Of course, you can access the micro-framework component from this wrapper.
