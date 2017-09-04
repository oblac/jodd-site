---
javadoc: 'lagarto'
---

# Lagarto

*Lagarto* is an all purpose fast and versatile **event**-based HTML
parser. It can be used to modify or analyze some markup content,
allowing to easily assemble custom complex transformations and code
analysis tools.

Using *Lagarto* is very simple. Target HTML code is parsed and each HTML
element is *visited* by user callback methods. For example, the
following HTML snippet:

~~~~~ html
    <html>
      <body>Hello</body>
    </html>
~~~~~

would fire the following set of events:

~~~~~ java
    start();  // parsing start
    tag();    // for opening 'html' tag
    text();   // for new line and spaces up to the next tag
    tag();    // for opening 'body' tag
    text();   // for text 'Hello'
    tag();    // for closing 'body' tag
    text();   // for new line and spaces up to the next tag
    tag();    // for closing 'html' tag
    end();    // parsing end
~~~~~

This makes *Lagarto* very, very fast; in fact it is one of the fastest
parsers out there.

## DOM Builder

*Lagarto* DOMBuilder is an extension made on *Lagarto* parser that
builds a DOM tree from the input HTML. This way you can manipulate
tree more convenient, with minor performance sacrifice.

## Jerry

If you feel like a JavaScript-ninja, go ahead and use *Jerry*! It is
jQuery in Java. Write your code for reading or manipulating HTML similar as you
would with jQuery. Now, that is convenient :)

## Lagarto Family

Lagarto is just a HTML/XML content parser, but many other cool things in
*Jodd* are built on top of it:

* [*CSSelly*](/csselly/) - CSS3 selectors parser.
* [*Jerry*](/jerry/) - JQuery in Java.
* [*HtmlStapler*](/htmlstapler/) - packages HTML resources.
* [*StripHtml*](strip-html.html) - compress HTML page.
* [*Decora*](/decora/) - web decoration framework.
