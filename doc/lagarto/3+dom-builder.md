# DOM Builder

*Lagarto* is an event-base parser. While this gives great performances
and low memory consumption, sometimes it is more convenient to build a
DOM tree first and then to manage it later. Of course, creating DOM
requires more memory and more processing time.

*Lagarto* provides `DOMBuilderTagVisitor` for building DOM trees from
HTML content. It can be easily used through `LagartoDOMBuilder`, like
this:

~~~~~ java
	LagartoDOMBuilder domBuilder = new LagartoDOMBuilder();
	Document doc = domBuilder.parse(content);
~~~~~

`LagartoDOMBuilder` always returns a `Document` - the root DOM tree
node. From there you can work on the DOM tree using common `Node`
methods.

## HTML content and DOM Builder

`LagartoDOMBuilder` does not validate or modify HTML content. What you
put to parse is what you get. HTML rules for closing _tag soups_ are NOT
implemented.
{: .attn}

This is very important to know: `LagartoDOMBuilder` will build the tree
from any (valid or invalid) HTML content. For example, if you put `tr`
tag inside `select` tag, `LagartoDOMBuilder` will not warn you; and
parsing will continue.

Therefore, `LagartoDOMBuilder` is not picky about it content. It will
try to process anything you give to it;)

We are working on *strict* version of `LagartoDOMBuilder`.
{: .example}

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
are awailiable after:

* `getErrors()` - if errors are collected during parsing, this methos
  will return list of all errors as they appeard.
* `getParsingTime()` - return parsing time in miliseconds.

## Jerry

But that's not all:) While using Lagarto DOM API is sufficient, it is
easier to parse and manipulate HTML content using API that looks more
like JQuery - including using CSS selectors.

For that *Jodd* provides a tool called [*Jerry*](/doc/jerry/index.html),
built on Lagarto DOM tree and [CSS selector engine](/doc/csselly/index.html).

## Lagarto configuration

*Lagarto* can be configured and fine tuned in many ways to parse and
interpret input content. See more details about [Lagarto parsing modes](lagarto-properties.html).
