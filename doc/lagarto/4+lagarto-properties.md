# Lagarto properties

There are two sets of *Lagarto* configuration: for `LagartoParser` and
`LagartoDOMBuilder`.

## LagartoParser configuration

### calculatePosition

By default disabled, this property enables calculation of elements
position: line, column (approx) and offset. It **makes processing slow**!

### enableConditionalComments

When set to `true` (default) *Lagarto* parser will detect IE conditional
comments. If you know that your HTML does not have any you can disable
this property to gain some more speed. If disabled and conditional
comment is found, *Lagarto* will either send an error for revealed
conditional comment tags or threat downlevel-hidden codnitional comments
as regular comments.

### parseSpecialTagsAsCdata

Special tags (in *Lagarto*) are: `style`, `script` and `xmp`. This flag
determines if special tags content should be parsed or not - in other
words, is it treated as PCDATA or CDATA section. When not parsed,
content is simply taken as it is, so using signs like `<` or `&` is
allowed. Otherwise, the content has to be correctly encoded.

## LagartoDOMBuilder configuration

`LagartoDOMBuilder` is *Lagarto DOM* builder and has few additional
properties that can be used to read and generate HTML, XHTML or XML
content.

### caseSensitive

Defines if tag names and attribute names are case sensitive.

### ignoreComments

Irrelevant from content type, this flag simply defines if resulting DOM
tree should contain comments or not.

### voidTags

List of [void elements][1] names. By default, it contains
all HTML5 void elements. If set to `null`, then there are no void
elements.

### selfCloseVoidTags

When an element is a void element, this flag defines if it can be
self-closed or if it should have the standard end tag.

### impliedEndTags

Enables rules for implicit end tags. There are a number of tags that do
not requre the use of a closing tag for valid HTML (`body`, `li`, `dd`,
`dt`, `p`, `td`, `tr`,...). When this flag is on, these tags are
implicitly closed if needed and no error/warning is outputed.

This feature somewhat slows down the parsing. If you are closing all
your tags, consider switching this feature off, to improve performances.

### ignoreWhitespacesBetweenTags

This flag is used for XML modes, to ignore all whitespace content
between two start or two end tags. Whitespace content between one open
and one closed tag is still not ignored.

### collectErrors

When enabled, `LagartoDomBuilder` will collect all errors during parsing
and provide them via method `getErrors()`.

### conditionalCommentExpression

Specifies expression for IE conditional comments that evaluates `true`.
By default, it is `"if !IE"`, meaning the HTML code will be treated as
non-IE browser. If set to `null`, all conditional comments will be part
of the DOM tree.

## Predefined parsing modes

There are 3 predefined parsing modes: HTML, XHTML and XML. They can be
easily set by calling `enableXxxMode()` on `LagartoDOMBuilder`. These
methods will configure the builder to work with HTML, XHTML or XML code.
Here are the details.

### HTML mode (default)

~~~~~ java
    ignoreWhitespacesBetweenTags = false;           // collect all whitespaces
    caseSensitive = false;                          // HTML is case insensitive
    parseSpecialTagsAsCdata = true;                 // script and style tags are CDATA
    voidTags = HTML5_VOID_TAGS;                     // list of void tags
    selfCloseVoidTags = false;                      // don't self close void tags
    impliedEndTags = true;                          // some tags end is implied
    enableConditionalComments = true;               // enable IE conditional comments
    conditionalCommentExpression = "if !IE";        // treat HTML as non-IE browser
~~~~~

### XHTML mode

~~~~~ java
    ignoreWhitespacesBetweenTags = false;           // collect all whitespaces
    caseSensitive = true;                           // XHTML is case sensitive
    parseSpecialTagsAsCdata = false;                // all tags are parsed the same
    voidTags = HTML5_VOID_TAGS;                     // list of void tags
    impliedEndTags = false;                         // no implied tag ends
    selfCloseVoidTags = true;                       // self close void tags
    enableConditionalComments = true;               // enable IE conditional comments
    conditionalCommentExpression = "if !IE";        // treat XHTML as non-IE browser
~~~~~

### XML mode

~~~~~ java
    ignoreWhitespacesBetweenTags = true;            // ignore whitespaces that are no content
    caseSensitive = true;                           // XML is case sensitive
    parseSpecialTagsAsCdata = false;                // all tags are parsed the same
    voidTags = null;                                // there are no void tags
    selfCloseVoidTags = false;                      // don't self close empty tags (can be changed!)
    impliedEndTags = false;                         // no implied tag ends
    enableConditionalComments = false;              // disable IE conditional comments
    conditionalCommentExpression = null;            // don't use
~~~~~

User can further change these predefined modes by setting individual
flags.
{: .example}

## Void and self-closing elements

(X)HTML modes are aware of void elements. *Lagarto DOM* builder tries to
follow the specification and, therefore:

* void elements in HTML mode are **not** self-closed
* void elements in XHTML mode are self-closed

Regular, content elements are closed with close tag, even if it is an
empty element.

XML mode is not aware of void elements. By default, empty elements are
closed by closing tag, but that can be change to self-closing tags.

## Fixing malformed content

*Lagarto DOM* tries to handle malformed content in an user-friendly way.
Fixing errors also depends on parsing mode. Every error is logged as a
warning.

As said, *Lagarto DOM* is not strict about the content and can't be
used for validation.

## Using predefined modes

Here is how predefined parsing modes can be used.

~~~~~ java
    LagartoDOMBuilder lagartoDOMBuilder = new LagartoDOMBuilder();
    Document doc = lagartoDOMBuilder.enableHtmlMode().parse(content);
~~~~~

[1]: http://dev.w3.org/html5/spec/Overview.html#void-elements
