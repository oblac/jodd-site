# Skip action paths

Usually, *Madvoc* is configured to interpret all action requests with
the same extension (`.html` by default). But sometimes we need to
prevent some action paths to be \'caught\' by *Madvoc*. For example,
Google webmaster tool requires to have certain html page for domain
verification with exact content.

It is very easy to 'skip' some action paths by using custom
`MadvocController`, like this:

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
