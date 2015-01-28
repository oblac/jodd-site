# Facebook browser with Jerry & Http

In one of our [examples](facebook-bot.html) we used Commons library for all
HTTP connection. Here is the example how to browse the same, facebook site
using just *Jerry* and *Http* libraries, keeping everything small, fast and
easy.

Here is the code example that performs login to Facebook:

~~~~~ java
	final HttpBrowser browser = new HttpBrowser();

	HttpRequest request = HttpRequest.get("www.facebook.com");
	browser.sendRequest(request);

	String page = browser.getPage();
	Jerry doc = Jerry.jerry(page);

	// process login form
	doc.form("#login_form", new JerryFormHandler() {
		public void onForm(Jerry form, Map<String, String[]> parameters) {

			String formAction = form.attr("action");
			HttpRequest loginRequest = HttpRequest.post(formAction);

			for (Map.Entry<String, String[]> entry : parameters.entrySet()) {
				String[] values = entry.getValue();
				String name = entry.getKey();

				for (String value : values) {
					loginRequest.form(name, value);
				}
			}

			// overwrite form parameters
			loginRequest.form("email", "your-email-here", true);
			loginRequest.form("pass", "your-password-here", true);

			browser.sendRequest(loginRequest);
		}
	});

	// this is your personal page:
	System.out.println(browser.getPage());
~~~~~

The code is easy and self-explanatory. First we load the main Facebook page
(we get redirected to https inside `HttpBrowser` but you don't need to know
that :). Then we use *Jerry* to quickly find the login form and to collect all
form parameters. We need to override `email` and `pass` parameter - thats why
we used `form()` method with a boolean argument set to `true`. Finally, we do
post a login request. The response is your personal Facebook page. Note that
many things in Facebook are loaded after the page is loaded, so you will not
see everything on the loaded page. You can continue with sending request
to other links to get more content.
