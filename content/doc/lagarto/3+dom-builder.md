# DOM Builder

*Lagarto* is an event-base parser. While this gives great performances
and low memory consumption, sometimes it is more convenient to build a
DOM tree first and then to manage it later. Of course, creating DOM
requires more memory and more processing time.

*Lagarto* introduces `DOMBuilder` interface, for various implementations of
DOM builders. Default implementation, `LagartoDOMBuilder` uses tag visitor
to build a DOM from HTML content. It may be used like this:

~~~~~ java
	LagartoDOMBuilder domBuilder = new LagartoDOMBuilder();
	Document doc = domBuilder.parse(content);
~~~~~

`DOMBuilder` instance always returns a `Document` - the root DOM tree
node. From there you can work on the DOM tree using common `Node`
methods.

## HTML content and DOM Builder

As we said on the previous page, processing HTML (like eg browsers do)
requires a second step: building a DOM tree from the input tokens.

While *Lagarto* parser strictly follows the HTML5 rules, `LagartoDOMBuilder`
follows only a subset of the DOM-building specification! Here is why.

By default, `LagartoDOMBuilder` follows all the rules that does not involve
any movements of DOM nodes. This is done on purpose, so to get the
exact tree to what you have provide. If you passed HTML with some tags
that are not suppose to be nested, `LagartoDOMBuilder` would not complain
and you will get exactly what you had on input.

In most cases, this is perfectly fine, as you are probably not using
all the tricks of HTML5 for the sake of better readability. But if you
need some more rules, you can turn them on! By enabling them, resulting
DOM tree can get modified per HTML5 rules. We have implemented the most
common of these rules and exceptions, but haven't covered them all (yet).
So if you have some quite weird HTML, you might expect different tree
then what you have in browser. Don't run away yet, it never happened
in the real life that *Lagarto* was not enough for the job!

`LagartoDOMBuilder` is not (yet) a strict implementation of HTML5
DOM-building rules; but it is good-enough for most cases!
{: .attn}

Just don't forget this and carry on :)

## Custom DOM Builder

There are few ways how user can use it's own version of `TagVisitor`
for building the DOM tree. One such way is by extending the method:
`createDOMDomBuilderTagVisitor()` where you can provide your own
implementation of `DOMBuilderTagVisitor`. For example:

~~~~~ java
	LagartoDOMBuilder domBuilder = new LagartoDOMBuilder() {
		@Override
		protected DOMBuilderTagVisitor createDOMDomBuilderTagVisitor() {
			return new MyDOMBuilderTagVisitor();
		}
	}
	Document doc = domBuilder.parse(content);
~~~~~

This way you can modify the original behavior of DOM builder. For
example, you may build DOM tree by treating the HTML content as Internet
Explorer (by processing conditional comments) or tree without certain
tags or comments etc.

### Conditional comments

Here is an example of custom DOM builder that treats HTML as non-IE
browser:

~~~~~ java
	LagartoDOMBuilder domBuilder = new LagartoDOMBuilder() {
		@Override
		protected DOMBuilderTagVisitor createDOMDomBuilderTagVisitor() {
			return new DOMBuilderTagVisitor(this) {
				@Override
				public void condComment(
						CharSequence expression,
						boolean isStartingTag,
						boolean isHidden,
						CharSequence comment) {

					String cc = expression.toString().trim();

					if (cc.equals("if !IE") == false) {
						enabled = cc.equals("endif");
					}
				}
			};
		}
	};
	Document doc = domBuilder.parse(content);
~~~~~

This DOM builder simply ignores all conditional comments except one that
specifies non-IE browsers (`if !IE`).

Note the usage of field `enabled` in the line #15. It's internal field
that can be used to enable and disable DOM tree creation. Here we use it
to disable DOM tree creation for all content between conditional tags
except for those specified for non-IE browser.

## After parsing

During parsing, `LagartoDomBuilder` also collects some information that
are available after:

* `getErrors()` - if errors are collected during parsing, this methods
  will return list of all errors as they appear.
* `getParsingTime()` - return parsing time in milliseconds.

## Jerry

But that's not all:) While using Lagarto DOM API is sufficient, it is
easier to parse and manipulate HTML content using API that looks more
like JQuery - including using CSS selectors.

For that *Jodd* provides a tool called [*Jerry*](/doc/jerry/index.html),
built on Lagarto DOM tree and [CSS selector engine](/doc/csselly/index.html).

## Lagarto configuration

*Lagarto* can be configured and fine tuned in many ways to parse and
interpret input content. See more details about [Lagarto parsing modes](lagarto-properties.html).
