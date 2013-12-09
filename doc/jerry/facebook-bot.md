# Build Facebook bot in 2 easy hours

<div class="doc1"><js>doc1('jerry',22)</js></div>
To demonstrate the power of [*Jerry*](index.html) (*jQuery in Java*), we
created a little Facebook bot, just in two hours, and just for fun:) The
task was to create a bot that will:

1. login to Facebook account,
2. list friends proposals, and
3. send a few \'*Add friend*\' requests.

Since the idea was to use *Jerry*, we are not using Facebook API, OAUTH
authorization etc; moreover Facebook API doesn't provide all available
functionality on purpose. Just good old send request - get response -
parse, parse, parse technique.

Content of Facebook pages may change in future and example may stop
working.
{: .example}

Note: the purpose of this practice is **PURELY EDUCATIONAL**. We do not
want to make any harm, break a law, kill a puppy etc. If we do violate
something, **please let us know**, and we will make all necessary
actions. Thank you for understanding!
{: .attn}

Once again, this is just a practice and the resulting code and the
design is not the best possible. Now, let's start the clockwatch!

## 0:00 - 0:10 Setting up project

The first step is to set up the Java project in our IDE (*IntelliJ
IDEA*). We need just two library sets:

* **Jodd v3.3.1**
* **HttpClient v4.1.2** (several jars)

This is just a warmup. Next, check if Firefox and Firebug plugin are
installed and working. We will need Firebug later to analyze HTML
content and sniff the requests.

This examples uses 3rd party lib (HttpClient). See
[similar example](facebook.html) build only with *Jerry* and *Http*.
{: .example}

## 0:11 - 0:55 HTTP connection tools

Lets create few simple HTTP-related utility methods over HttpClient.
Basically, we need two methods, one to send GET request and the other to
send POST request. However, this is not so trivial as it sounds.

First, we must to think about the session, i.e. cookies. Each request
must send and receive cookies from the host. So every time we send some
request, we need to pass previous set of cookies. This will simulate
user session in browser. Next, our request must be able to follow
redirects automatically. And lets not forget to set custom
\'User-Agent\' header, so Facebook host does not denies us
automatically.

After few tries and errors, we come with this interface - it's not the
perfect one, but it works:

~~~~~ java

    public class HttpUtil {

    	/**
    	 * Creates HTTP client. Uses Firefox User-Agent to fool Facebook.
    	 * Sets cookies from provided CookieStore.
    	 */
    	private static DefaultHttpClient createHttpClient(CookieStore cookieStore) {
    		...
    	}

    	/**
    	 * Sends GET request.
    	 */
    	public static Response get(
                String url, CookieStore cookieStore) throws IOException {
    		...
    	}

    	/**
    	 * Sends POST request.
    	 */
    	public static Response post(
    			String action, Map<String, String> parameters, CookieStore cookieStore)
    			throws IOException {
    		...
    	}
    }
~~~~~

For implementation details you can [download the full
source](fbookbot.zip). The `Response` class is a simple bean that
collects several HTTP response products of interest: returned HTML
content, status line and cookies.

## 0:56 - 1:00 Top-level methods

The main method must be simple:

~~~~~ java
    public static void main(String[] args) throws IOException {
    	Response response;

    	response = loginToFacebook(EMAIL, PASS);

    	response = findFriends(response);

    	listAndAddFriends(response, new MutableInteger(0));
    }
~~~~~

## 1:01 - 1:15 Login to Facebook

The idea is to load main Facebook page, find the login form and take all
input parameters. Then set the username and password and post the form.
After quick analysis of the front page, we find out that the login form
has the following id: `#login_form`. So, let's finally see *Jerry* in
action:

~~~~~ java
	static Response loginToFacebook(String email, String pass) throws IOException {
		Response response = HttpUtil.get("http://www.facebook.com", null);

		Jerry doc = Jerry.jerry(response.getHtml());
		Jerry loginForm = doc.$("#login_form");

		String action = loginForm.attr("action");

		Map<String, String> loginFormParams = JerryUtil.form(loginForm);
		loginFormParams.put("email", email);
		loginFormParams.put("pass", pass);

		return HttpUtil.post(action, loginFormParams, response.getCookieStore());
	}
~~~~~

As said: find the form, get all form parameters, set email and password,
and finally, post the form. Do not forget the cookies! On the first
(GET) request we collect cookies that are passed in the second (POST)
request. Let's see how to collect form parameters:

~~~~~ java
    public static Map<String, String> form(Jerry form) {
    		final Map<String, String> map = new HashMap<String, String>();
    		form.first().$(":input").each(new JerryFunction() {
    			public boolean onNode(Jerry $this, int index) {
    				String name = $this.attr("name");
    				String value = $this.attr("value");
    				map.put(name, value);
    				return true;
    			}
    		});
    		return map;
    	}
~~~~~

This method is trivial and not complete. You should use `form()` method from
*Jerry*; that one returns all parameters including value of select boxes,
checkboxes, textareas etc.

## 1:16 - 1:20 Find friends

This one is simple: just load the 'find friends' page on facebook. Of
course, we still need to pass the cookies to maintain the session.
*Jerry* is not working here:)

~~~~~ java
    static Response findFriends(Response response) throws IOException {
    		response = HttpUtil.get(
    			"http://www.facebook.com/find-friends/browser/?ref=tn",
    			response.getCookieStore());
    		return response;
    	}
~~~~~


## 1:21 - 1:35 List friends

This one is not so hard. We just need to iterate the list of friends
recommendations. However, we need to find some more data: facebook user
id, the form id (used as CSRF shield) and the facebook id of each
friend. Thanx to *Jerry*, this is easy:)

~~~~~ java
	static void listAndAddFriends(
            final Response response, final MutableInteger numberOfFriendsToInvite) {
		Jerry doc = Jerry.jerry(response.getHtml());

		// find user id
		Jerry userLink = doc.$("#pageHead #headNav ul#pageNav li.topNavLink a");
		final String facebookUserId = extractId(userLink);

		// find form id
		Jerry input = doc.$("input#post_form_id");
		final String postFormId = input.attr("value");

		// parse friends
		Jerry form = doc.$("form.friendBrowserForm");

		form.$("ul.uiList li div.fsl").each(new JerryFunction() {
			public boolean onNode(Jerry $this, int index) {
				String friendName = $this.find("a").text();

				String friendFacebookId = extractId($this.$("a"));

				System.out.println(friendFacebookId + " > " + friendName);
				return true;
			}
		});
	}
~~~~~

As we didn't want to spam and invite all
friends at once, we are passing the `numberOfFriendsToInvite`: it's
the number of top listed friends that will be invited. So, for
example, if you pass '3', only first three friends will be added, the
rest will be just listed.

## 1:36 - 2:00 Add friends

Adding friends required some more thinking. The problem is that form is
posted using Ajax and all information how the request is built is stored
in the javascript. *Jerry* does not see that. So we can analyze the
javascript code, which is painful, or... simply sniff the request in the
Firebug.

![fb](fbookbot1.png){: .b}

Now things are getting better - we just need to send a POST request as
displayed above. So the final piece of the code is:

~~~~~ java
	static void addFriend(
			String facebookUserId,
			String friendFacebookId,
			String postFormId,
			Response response) throws IOException {

		HashMap<String, String> params = new HashMap<String, String>();
		params.put("__user", facebookUserId);
		...

		response = HttpUtil.post(
			"http://www.facebook.com/ajax/add_friend/action.php?__a=1",
			params, response.getCookieStore());
		System.out.println(response.getStatusLine());
	}
~~~~~

## Now... relax

After two hours of coding, you deserved a break;) Run the bot and see it
in action:

~~~~~
    login...
    finding friends...
    listing friends...

    facebook user id: id=11111111111
    post form id: 50f2346f9d4c58ab17b7675298a10ec8
    id=222222 > John Doe
    >>> adding friend: id=222222
    HTTP/1.1 200 OK
    id=3333 > Kim Jong Un
    >>> adding friend: id=3333
    HTTP/1.1 200 OK
    id=4444 > Bellucci Mon.
    id=5555 > Depp Johny
    id=6666 > Pitt Brad
    ...
~~~~~

And... friendship requests are sent:)

## Download

If you are interested in more implementation details, feel free to
[download the full source code](fbookbot.zip). Again, this is just a
quick-n-dirty code, coded in two hours.

