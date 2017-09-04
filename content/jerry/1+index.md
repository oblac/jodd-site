---
javadoc: 'jerry'
---

# Jerry

*Jerry* is a [jQuery][1] in Java. *Jerry* is a fast and
concise Java Library that simplifies HTML document parsing, traversing
and manipulating. *Jerry* is designed to change the way that you parse
HTML content.

*Jerry* belongs to <var>jodd-lagarto</var> module and has no dependencies
other than Jodd's.

## What does Jerry code look like?

~~~~~ java
    import static jodd.jerry.Jerry.jerry;
    ...
    Jerry doc = jerry(html);
    doc.$("div#jodd p.neat").css("color", "red").addClass("ohmy");
~~~~~

## How Jerry works?

We tried to keep *Jerry* API identical to jQuery as much as possible; in
some cases you can simply copy some jQuery code and paste it in Java! Of
course, some differences exist due to environments variation the code is
executed in.

### Creating document

In Java we do not have the document context as in browsers and
javascript, so we need to create one first. To do that, simply pass HTML
content to *Jerry* static factory method. That will create a root
*Jerry* set, containing a `Document` root node of the parsed DOM tree.

`Jerry.jerry(html)` contains a set with just **one** node - root `Document`
node of parsed HTML content. This is a starting point for *Jerry* usage.
{: .attn}

What happens in the background is that *Lagarto* parser (default implementation:
`LagartoDOMBuilder`) is invoked to build a DOM tree.

*Jerry* uses *Lagarto DOM* parser for parsing the content and building the DOM tree.
{: .attn}

It is possible to set different implementation of DOM builder. *Jerry* itself
is not responsible for parsing HTML and building the tree, it takes any DOM
tree that is created by a DOM Builder.

### Using CSS selectors

You can use most of standard CSS selectors
and also most of the jQuery CSS selectors extensions. CSS selectors are
supported by [*CSSelly*](/csselly).

### Differences

As *Jerry* speaks Java, there are some differences in API made to make
*Jerry* API more Java friendly. For example, `css()` method accepts an
array of property/values, and not a single string.

~~~~~ java
    jerry(html).
        $("tr:last").css("background-color", "yellow", "fontWeight", "bolder");
~~~~~

Similarly, `each()` method receives a callback instance and it is not so
fluent as in javascript;):

~~~~~ java
    doc.$("select option:selected").each(new JerryFunction() {
    		public boolean onNode(Jerry $this, int index) {
    			str.append($this.text()).append(' ');
    			return true;
    		}
    	});
~~~~~

### Unsupported stuff

As *Jerry* is all about **static** manipulation of HTML content, all
jQuery methods and selectors that are related to any dynamic activity
are not supported. This includes animations, Ajax calls, selectors that
depends on CSS definitions...

### Add-ons

*Jerry* provides some add-ons that does not exist in jQuery. First, there are
few methods that return `Node` of given DOM tree (similar to javascript).
Then there are some new methods that have more meaning in Java world. One of the
functional new methods is the `form()` method. It collects all parameters for
given form, allowing easy form handling. Here is an example:

~~~~~ java
    doc.form("#myform", new JerryFormHandler() {
        public void onForm(Jerry form, Map<String, String[]> parameters) {
            // process form and parameters
        }
    });
~~~~~


## Configuration

*Jerry* internally uses [*Lagarto DOM*](/lagarto) builder to parse
input content and to produce HTML code. The builder is configurable and
supports predefined parsing modes for HTML, XHTML and XML.

By default, *Jerry* uses the builder in HTML parsing mode. Here is an
example how to change the predefined parsing mode:

~~~~~ java
    JerryParser jerryParser = Jerry.jerry();
    LagartoDOMBuilder domBuilder = (LagartoDOMBuilder) jerryParser.getDOMBuilder();
    domBuilder.enableHtmlMode();
    // more configuration...
    Jerry jerry = jerryParser.parse(html);
~~~~~

All configuration and *Lagarto DOM* builder fine-tuning must be done before
the parsing is executed.

Check all details about [configuration and parsing modes](/lagarto/lagarto-properties.html) for *Lagarto*,
parser and DOM builder used by *Jerry*.

[1]: http://jquery.com/
