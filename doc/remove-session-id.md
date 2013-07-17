# Remove session ID from URLs

Most of the time the session ID does not appear in the URL (unless
cookies are disabled). Still, in some rare cases, the session ID will
appear in the URL. This is consider as a security issue.

Consider the following example: welcome page (defined in `web.xml`) is
protected by your application in some filter or *Madvoc* interceptor.
There you protect pages access from anonymous access and redirect users
to some login page. So lets see what happens when you open *the clean*
browser (without previous history and cache) and go to the site.

On the first access to the protected page, Tomcat has no idea if your
browser supports cookies or not. The only safe solution is to do
URL rewriting and to append session ids to the url.
Therefore, on the first access, there will be session id in
the URL after redirecting to the login page.

The easiest way to solve this is to provide a welcome page or welcome
servlet that isn't password protected (and that requests a session).

Second solution is to use `RemoveSessionFromUrlFilter`. This filter does
the following:

* if the session id is found in the request URL, the session will be
  invalidated; so the exposed session id becomes invalid
* removes session id from URLs

You can register this filter in a common way and map it to all patterns:

~~~~~ xml
    <web-app ...>
    	...
    	<filter>
    		<filter-name>RemoveSessionFromUrl</filter-name>
    		<filter-class>jodd.servlet.filter.RemoveSessionFromUrlFilter</filter-class>
    	</filter>
    	<filter-mapping>
    		<filter-name>RemoveSessionFromUrl</filter-name>
    		<url-pattern>/*</url-pattern>
    	</filter-mapping>
    	...
    </web-app>
~~~~~
