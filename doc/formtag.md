# Form tag

Common task in web development is populating form with existing values.
This is one of those repetitive tasks: each text field has to be
HTML-encoded, then there are checkboxes and radios, select boxes with
options and so on. `Jodd` offers one very simple way how to populate
forms.

## Usage

It is trivial: just wrap form with `Form` tag. That is all. Example:

~~~~~ html
    <j:form>
    <form id="form" method="post" action="....">
    	<input type="text" name="foo.text">
    </form>
    </j:form>
~~~~~

`Form` tag simply parses forms HTML and searches for form fields. For
each form field it reads `name` attribute and resolves the value
assigned to the same name from various scopes, starting from page to the
application scope. In above example, `Form` tag will try to resolve
`foo.text` value from scopes.

When value is found, it will be used to populate form field. In case of
text fields, value will be HTML-encoded; for checkboxes and radios field
will be checked, and so on.

Above example would render to:

~~~~~ html
    <form id="form" method="post" action="....">
    	<input type="text" name="foo.text" value="some foo.text value">
    </form>
~~~~~

Once again, `Form` tag supports **ALL** types of form fields.
