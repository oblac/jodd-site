# CSSelly

*CSSelly* is a Java implementation of the W3C Selectors Level 3
specification.

It's small, fast and extendable. *CSSelly* parses string containing CSS
selectors; this data may be used by any HTML parser. Yet it works the
best with *Lagarto* DOM tree and our [*Jerry*](/doc/jerry/index.html),
the HTML parser with JQuery friendly API.

## Usage

### Parsing

~~~~~ java
    CSSelly csselly = new CSSelly("div:nth-child(2n) span#jodd");
    List<CssSelector> selectors = csselly = csselly.parse();
~~~~~

### Selecting

Here is how parsed CSS selectors information may be used on `Document`,
a root node of some HTML content parsed by *Lagarto*.

~~~~~ java
    NodeSelector nodeSelector = new NodeSelector(document);
    LinkedList<Node> selectedNodes = nodeSelector.select("div#jodd li");
~~~~~

Resulting list is a set of nodes that matches selector.

See [*Jerry*](/doc/jerry/index.html) for more convenient HTML
manipulation, using JQuery-friendly API.
{: .example}

## Supported selectors

### Default

* `*` any element
* `E` an element of type E
* `E[foo]` an E element with a "foo" attribute
* `E[foo="bar"]` an E element whose "foo" attribute value is
  exactly equal to "bar"
* `E[foo~="bar"]` an E element whose "foo" attribute value is
  a list of whitespace-separated values, one of which is exactly equal
  to "bar"
* `E[foo^="bar"]` an E element whose "foo" attribute value
  begins exactly with the string "bar"
* `E[foo$="bar"]` an E element whose "foo" attribute value
  ends exactly with the string "bar"
* `E[foo*="bar"]` an E element whose "foo" attribute value
  contains the substring "bar"
* `E[foo|="en"]` an E element whose "foo" attribute has a
  hyphen-separated list of values beginning (from the left) with
  "en"
* `E:root` an E element, root of the document
* `E:nth-child(n)` an E element, the n-th child of its parent
* `E:nth-last-child(n)` an E element, the n-th child of its parent,
  counting from the last one
* `E:nth-of-type(n)` an E element, the n-th sibling of its type
* `E:nth-last-of-type(n)` an E element, the n-th sibling of its type,
  counting from the last one
* `E:first-child` an E element, first child of its parent
* `E:last-child` an E element, last child of its parent
* `E:first-of-type` an E element, first sibling of its type
* `E:last-of-type` an E element, last sibling of its type
* `E:only-child` an E element, only child of its parent
* `E:only-of-type` an E element, only sibling of its type
* `E:empty` an E element that has no children (including text nodes)
* `E#myid` an E element with ID equal to “myid”.
* `E F` an F element descendant of an E element
* `E > F` an F element child of an E element
* `E + F` an F element immediately preceded by an E element
* `E ~ F` an F element preceded by an E element

### Extension

Here is the list of additional pseudo classes and pseudo functions
supported by *CSSelly*:

* `:first`
* `:last`
* `:button`
* `:checkbox`
* `:file`
* `:header`
* `:image`
* `:input`
* `:parent`
* `:password`
* `:radio`
* `:reset`
* `:selected`
* `:checked`
* `:submit`
* `:text`
* `:even`
* `:odd`
* `:eq(n)`
* `:gt(n)`
* `:lt(n)`
* `:contains(text)`

## Custom user classes and functions

*CSSelly* allows user to create custom pseudo classes and functions.

### Custom pseudo class

For custom pseudo classes extend the `PseudoClass` and implement method `match(Node node)`. This method should return `true` if a node is matched. You may also override method `getPseudoClassName()` if you don't want to auto-generate pseudo class name from class name. For example:

~~~~~ java
    public static class MyPseudoClass extends PseudoClass {
        @Override
        public boolean match(Node node) {
          return node.hasAttribute("jodd-attr");
        }

        @Override
        public String getPseudoClassName() {
          return "some-cool-name";
        }
    }
~~~~~

Then register your pseudo class with:

~~~~~ java
    PseudoClassSelector.registerPseudoClass(MyPseudoClass.class);
~~~~~

From that moment you will be able to find all nodes with the attribute `jodd-attr` using the `:some-cool-name` pseudo class.

### Custom pseudo function

Similar to pseudo classes, for custom pseudo function implement the `PseudoFunction` class. This time, however, you need to also implement a method
that parses input expression. This expression is later passed to the matching method. Here is an example, lets make a function that matches all nodes with certain name length:

~~~~~ java
    public static class MyPseudoFunction extends PseudoFunction {
        @Override
        public Object parseExpression(String expression) {
            return Integer.valueOf(expression);
        }

        @Override
        public boolean match(Node node, Object expression) {
            Integer size = (Integer) expression;
            return node.getNodeName().length() == size.intValue();
        }

        @Override
        public String getPseudoFunctionName() {
            return "super-fn";
        }
    }
~~~~~

Register this function with:

~~~~~ java
    PseudoFunctionSelector.registerPseudoFunction(MyPseudoFunction.class);
~~~~~

You can use it like this: `:super-fn(3)` to match all nodes with names size equal to 3.

## Escaping

*CSSelly* supports escaping characters using backslash, e.g.: "`nspace\:name`" refers to the tag name
"`nspace:name`" (that uses namespaces) and not for pseudo class "`name`".

