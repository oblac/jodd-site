# Lagarto ![Lagarto!](lagarto.png)

<js>javadoc('lagarto')</js>

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

*Lagarto* is to HTML what **ASM** is to bytecode :)
{: .example}

## Lagarto Family

Lagarto is just a HTML/XML content parser, but many other cool things in
*Jodd* are built on top of it:

* ![HtmlStapler](/doc/htmlstapler/stapler.png) [*HtmlStapler*](/doc/htmlstapler/index.html) - packages HTML resources,
* ![StripHtml](striphtml.png) [*StripHtml*](strip-html.html) - compress HTML page,
* ![Decora](../decora/decora.png) [*Decora*](/doc/decora) - web decoration framework,
* ![CSSelly](../csselly/csselly.png) [*CSSelly*](/doc/csselly) - CSS3 selectors parser,
* ![Jerry](../jerry/jerry.png) [*Jerry*](/doc/jerry) - JQuery in Java.
