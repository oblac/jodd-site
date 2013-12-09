# Auth with interceptors

<div class="doc1"><js>doc1('example',22)</js></div>
Lets control page access using *Madvoc* interceptors. If user is not yet
authenticated, it will be redirected to the login page. After the
successful login, user continues with the requested page.

## AuthInterceptor

Interceptor is quite simple:

~~~~~ java
    public class AuthInterceptor extends ActionInterceptor {

    	@Override
    	public Object intercept(ActionRequest request) throws Exception {
    		HttpServletRequest servletRequest = request.getHttpServletRequest();
    		HttpSession session = servletRequest.getSession();
    		if (AuthUtil.isSessionActive(session)) {
    			return request.invoke();
    		}
    		servletRequest.setAttribute("path", DispatcherUtil.getActionPath(servletRequest));
    		return "chain:/%login%";
    	}
    }
~~~~~

`AuthUtil.isSessionActive` checks if session is active by, for example,
checking if some attribute is set in current http session. If user is
still not logged in, we will save requested action path (url + query
parameters) in request scope and chain to the login page. Chain result
type is similar as redirect, except it happens inside of *Madvoc*.

Here we are referring login page via its alias (\'`%login%`\'). This is
done so we do not have to hardcode the login page name inside java code.

## Interceptors stacks

We will have two interceptors stacks: one for public pages, one for
those that require authorization.

~~~~~ java
    // public interceptor stack (example)
    public class PublicInterceptorStack extends ActionInterceptorStack {

    	public PublicInterceptorStack() {
    		super(IdRequestInjectorInterceptor.class, PrepareInterceptor.class, ServletConfigInterceptor.class);
    	}
    }
~~~~~

~~~~~ java
    // auth interceptor stack
    public class AuthInterceptorStack extends ActionInterceptorStack {

    	public AuthInterceptorStack() {
    		super(AuthInterceptor.class, PublicInterceptorStack.class);
    	}
    }
~~~~~

One of above interceptor stacks has to be set as default. Lets assume
that most of web application content requires authentication. Therefore,
we will set `defaultInterceptors` parameter that belongs to component
`MadvocConfig`. There are two ways to do this: one is in java, in
`AppWebApplication.init()` method. Second way is setting as *Madvoc*
parameter in `madvoc.properties`\:

~~~~~
    madvocConfig.defaultInterceptors=jodd.madvoc.interceptor.EchoInterceptor, jodd.joy.madvoc.AuthInterceptorStack
~~~~~

Now, all actions with intercepted with default interceptors will be
forbidden for public access.

## Login action

Login page and action is the last part that we need to make. Login page
is simple: besides login data login form must also send path info
(previously set by interceptor):

~~~~~ html
    <j:form>
    <form action="login.post.do" method="post">
    	<input type="hidden" name="path">
    	name: <input type="text" name="user.name"/>
    	<input type="submit"/>
    </form>
    </j:form>
~~~~~

Now, lets make the login action. Obviously, we need http session to
start new user session if user authentication is ok. Although is easy to
inject `HttpSession` instance in action using `ScopeType.CONTEXT` scope,
we will create action that does not depend on servlets API.

~~~~~ java
    @MadvocAction
    @InterceptedBy(PublicInterceptorStack.class)
    public class LoginAction {

    	@PetiteInject
    	FooService fooService;

    	@Action(alias="login")
    	public void view() {
    	}

    	@In
    	User user;

    	@In
    	String path;

    	@Out(scope = ScopeType.SESSION, value = AuthUtil.AUTH_SESSION_NAME)
    	User userSession;

    	@Action(extension = "do")
    	public String post() {
    		user = fooService.findUser(user);
    		if (user == null) {
    			return "#";		// return BACK;
    		}
    		userSession = user;
    		return "redirect:" + path;
    	}
    }
~~~~~

Obviously, login page must be public - therefore the
`PublicInterceptorStack` in line #2. View action in line #9 shows the
`login.jsp`. It also defines `login` alias, used by interceptor (line
#8). Second action (`login.post.do`) tries to authenticate user. If user
data are bad, action will return back to `login.jsp`. If user exist, we
prepare the user session object. It will be outjected to the session
since annotation specifies so (line #18). At the and we instruct the
redirection to the requested path.

One consequence: if user session exist and if user for some reason
visits login page and enters wrong data, above code will terminate his
session (because of outjection of `userSession` that is `null`). This
can be fixed by injecting existing user session in the `userSession`
field, using annotation: `@InOut`.

