# StripHtml

`StripHtmlTagAdapter` is *Lagarto* tag adapter that can used for
reducing the size of HTML pages by removing all unnecessary characters.

`StripHtmlTagAdapter` does the following modifications to HTML page:

* removes all HTML comments.
* replaces multiple whitespaces in text with a single space character.

Note that javascript blocks are not stripped by this tag adapter.

## Using StripHtml

There are several way how to use `StripHtml`.

### With HtmlStapler

If you are already using the
[*HtmlStapler*](/htmlstapler/setup.html), you can enable/disable
html strip from its parameters.

### As servlet filter

See
[`SimpleLagartoServletFilter`](lagarto-parser.html#lagartoservletfilter)
how you can use any *Lagarto* adapter in a simple way to get you going.

### Off-line usage

Here is an example:

~~~~~ java
    File ff = new File("page.html");
    LagartoParser lagartoParser = new LagartoParser(FileUtil.readString(ff));

    StringBuilder out = new StringBuilder();
    TagWriter tagWriter = new TagWriter(out);
    StripHtmlTagAdapter stripHtmlTagAdapter = new StripHtmlTagAdapter(tagWriter);

    lagartoParser.parse(stripHtmlTagAdapter);

    System.out.println(out.toString());
~~~~~
