# Lagarto Parser

To parse HTML/XML content with *Lagarto* you must do just two steps:

1.  create a *Lagarto* parser instance providing content; and then
2.  invoke parsing using the implementation of `TagVisitor`\:

In other words:

~~~~~ java
    LagartoParser lagartoParser = new LagartoParser(htmlContent);
    TagVisitor tagVisitor = new FooTagVisitor();
    lagartoParser.parse(tagVisitor);
~~~~~

## Events

While content is parsing, *Lagarto* calls various callback methods of
`TagVisitor`. Here is the list of most important callbacks; check the
javadoc for more details.

### start() and end()

Invoked before and after content is parsed.

### text(CharSequence)

Invoked on plain text.

### comment(CharSequence)

Invoked on HTML comment. Argument contains just comment content, without
comment boundaries.

### tag(Tag)

Invoked on a HTML tag: open, close or empty tag. Argument is a `Tag`
instance, that contains further information about the tag: tag name,
attributes, depth level and so on.

`Tag` instance is **reused** during visiting HTML code for better
performances! The same instance is passed to **all** callback methods.
{: .attn}

### script(Tag, CharSequence)

Invoked on all script tags. Passed is a script `Tag` instance and the
body.

See javadoc for other callback methods. Also, you can use
`EmptyTagVisitor` to write your own visitors in more convenient ways.

## Errors in HTML

*Lagarto* is very error-friendly. It will try to do its best to resolve
an error and continue parsing. Every error is reported by invoking
`error()` method of a visitor. By default, errors are written in the log
as warnings.

By default, *Lagarto* will append the file offset where the error
occurs. Optionally, by enabling property, *Lagarto* can calculate the
real position of the error in the file: it's line and column.

The format of error position is the following: `[line:column @offset]`.
Please note that error is not exactly at the calculated character, but
somewhere near.

## Writer and adapter

*Lagarto* may be used not only for parsing and analyzing HTML content,
but also for modifying it. For that purpose you can use `TagWriter` and
`TagAdapter`.

`TagWriter` is a simple `TagVisitor` that writes content to some
`Appendable`. So, if you pass `TagWriter` instance to `parse()` method
the resulting code will be the same as the input HTML code.

`TagAdapter` is a generic adapter for underlying `TagVisitor`. It may be
used over some e.g. `TagWriter` to perform some HTML transformation.

This approach allows to perform HTML modifications during just **one**
parsing! For example, if you have 3 different adapters that modifies
HTML code in some way, they all can be applied during just single
content parsing.

## LagartoParserEngine

The core parsing engine is implemented in an abstract class:
`LagartoParserEngine`. It's purpose is to be used for creating custom
or specific parsers. `LagartoParser` is just simple generic parser built
on top of this parsing engine.

## LagartoServletFilter

One common use of *Lagarto* is as servlet filter. There it may parse and
modify the content before it is written to the output stream. For this
purpose there is `LagartoServletFilter`, an abstract filter that can be
overridden.

### SimpleLagartoServletFilter

`LagartoServletFilter` is quite generic filter and can be used by any
other parsing tool or solution. Anyhow, in most cases, the
`SimpleLagartoServletFilter` will be enough. Here user just has to
override one method to build custom `LagartoParsingProcessor`. Inside
the implementation, user builds set of nested `TagAdapter`s and pass it
to the method `invokeLagarto()`.

~~~~~ java
    public class AppLagartoServletFilter extends SimpleLagartoServletFilter {

    	@Override
    	protected LagartoParsingProcessor createParsingProcessor() {
    		return new LagartoParsingProcessor() {
    			@Override
    			protected char[] parse(
                        TagWriter rootTagWriter, HttpServletRequest request) {

    				TagAdapter1 tagAdapter1 = new FooTagAdapter(rootTagWriter);
    				TagAdapter2 tagAdapter2 = new BarTagAdapter(tagAdapter1, request);

    				char[] content = invokeLagarto(tagAdapter2);
    				return content;
    			}
    		};
    	}
    }
~~~~~

In above example we created *Lagarto* servlet filter with two content
processors (i.e. tag adapters) that execute during the same **single**
parsing operation. In other words, HTML content is parser only once, but
the content is modified by two different processors. In some cases this
may save time and prevent from double parsing!

<js>docnav('lagarto')</js>