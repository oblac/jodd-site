# Start Jodd Joy

*Joy* combines all the *Jodd* micro-frameworks and configures them to work together.

## Web application

Everything starts with a listener. *Jodd* works with Servlets 3.x, and it does not depend of `web.xml` - in fact, we recommend not to use it. That being said, the best way to start the *Joy* is to simply extend the `JoyContextListener` and add `@WebListener` annotation:

~~~~~java
    @WebListener
    public class AppContextListener extends JoyContextListener {
    }
~~~~~

## Properties

While you can configure everything manually, some settings are convenient to exist in the external property file. For that purpose *Joy* reads the `joy*.props` and `joy*.properties` from the classpath. So just add `joy.props` to the resources.

## Database

By default, *Joy* expects that your application is going to use some relational database. If so, just add default configuration:

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

## Run!

Yes, that is _all_ you need to set! Just run it! Simple as that :)

## Configuring Joy

One thing to remember is that there are multiple ways how to configure and use *Jodd* microframeworks. You can use properties file, or annotations, or just plain java.

In case of *Joy*, you can simply use the same listener: `AppContextListener`. Just override the method `createJoy()` and... configure everything:

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

Important note: most `JoddJoy` `with()` methods return a wrapper over the microframework component. This wrapper holds some *Joy*-related configuration. Of course, you can access the microframework component from this wrapper.

