# FAQ

## May I use embedded Tomcat?

With Tomcat, running *Madvoc* application is really simple:

~~~~~ java
    Tomcat tomcat = new Tomcat();
    tomcat.setPort(8080);
    String workingDir = System.getProperty("java.io.tmpdir");
    tomcat.setBaseDir(workingDir);
    tomcat.addWebapp("/", webRoot.getAbsolutePath());
    tomcat.start();
~~~~~

The `webRoot` is a root of the web application. Simple as that!

If you don't want to use `web.xml`, just extend the `MadvocContextListener` and mark it with `@WebFilter`.


## How to exclude some action paths from Madvoc?

Usually, *Madvoc* is configured to interpret all action requests.
But sometimes we just want to exclude certain paths to be 'caught' by *Madvoc*.
For example, Google webmaster tool requires to have certain HTML page for domain
verification with exact content.

It is very easy to exclude some action paths by using custom `MadvocController`, like this:

~~~~~ java
    public class FooMadvocController extends MadvocController {

    	private static final String GOOGLE = "google";

    	@Override
    	public String invoke(
                String actionPath, HttpServletRequest servletRequest,
                HttpServletResponse servletResponse) throws Exception {

            if (actionPath.startsWith(GOOGLE)) {
    			return actionPath;
    		}
    		return super.invoke(actionPath, servletRequest, servletResponse);
    	}
    }
~~~~~

Now all action paths that starts with `google` will be ignored by
*Madvoc* and, therefore, served by Tomcat. When method `#invoke()`
returns a non-null value it is indication that *Madvoc* didn't consume
the action. That is all!


## How to read web components mappings?

*Madvoc* provides one action for debugging purposes and inspection of
internal *Madvoc* state. That is `ListMadvocConfig` class. If you want to use it, your *Madvoc* action class should extend it.

This method provides several `collectNnn()` method that fetch Madvoc configuration of web components. This configuration is also outjected.


## Validation?

Although validation of user input is necessary part of every web
application, *Madvoc* doesn't offer a solution for it. The reason why
is that, in our opinion, validation is not part of just web layer, but
instead it is spread across service layer as well. Therefore, web
framework should not be tight so single validation framework.


## Different Result types?

Sometimes you want your action to return one result type if one condition is set
and the other result type if some other condition is set instead.
If both result types can be set with strings (like dispatcher and forward)
you are fine. But if types are different classes, you have to use different
trick.

In this case just have action method return `Object`. Return any result
class from your action and everything will still works. Nice!
