# Results (cont.)

<div class="doc1"><js>doc1('madvoc',20)</js></div>
More features and topics about Results.

## Aliases

Hard-coding URLs is not considered as good practice. *Madvoc* offers way
to define path aliases to prevent URL hard-coding. Aliases can be
defined in following ways: in action annotation or in *Madvoc*
configuration.

Either way defined, aliases are used in result value, surrounded by
\'`<`\' and \'`>`\' signs.

### Aliases defined in annotation

Aliases may be defined using `@Action`\'s element \'`alias`\' on target
action.

The previous example can be re-written in the following way:

~~~~~ java
    // Target action (/index.html)
    @MadvocAction
    public class IndexAction {

    	@Action(alias="index")
    	public void view() {
    	}
    }
~~~~~

~~~~~ java
    // Calling action (/one.html)
    @MadvocAction
    public class OneAction {

    	String value;

    	@Action
    	public String execute() {
    		value = "173";
    		return "redirect:<index>?value=${value}";
    	}
    }
~~~~~

Alias is defined in the `IndexAction` class: alias name is \'`index`\'
and value equals to the full action path, including the extension:
\'`/index.html`\'. Therefore, behavior of the `OneAction#execute` action
remains identical.

Aliases defined in annotations are convenient for `redirect:` results.
{: .example}

### Default aliases

Above concept can be simplified by enabling default path aliases in
`MadvocConfig`. If this option is enabled then every action by default
will have an generated alias. Default alias is generated like this:

`default_alias = <action class name> + '#' + <action method name>`

### Aliases defined by ActionsManager

Aliases also may be registered manually by using `ActionsManager`
component:

This gives even more flexibility, since this way makes possible to
register alias values without extensions, or with just half of the path
etc. For example, it is possible to define whole result path as an
alias, what is virtually equal to specifying result path from the
outside of method! For example:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public void all() {
    	}
    }
~~~~~

Action is mapped to `/hello.all.html` and result path of this action is
`/hello.all`. (this is just a result path; appropriate result type
handler adds the extension). Since result path is previously defined as
an alias, this action will return the replaced result path, i.e. the
alias value: that dispatcher will here forward to: `/hi-all.jsp`.

Aliases defined by `ActionManager` are convenient for `dispatch`\:
results.
{: .example}

## Overriding result path

By default, result value is added to action path (without extension) to
form the result path. Very often is necessary for an action to return to
result path of another action, defined in the same action class.
Following action illustrates this:

~~~~~ java
    @MadvocAction
    public class FormAction {

    	@Action
    	public void view() {
    	}

    	@Action
    	public String post() {
    		return "#";
    	}
    }
~~~~~

This is a common case in web applications. Some form is mapped to action
path: `/form.html`. This action (method: `view()`) just prepares form
for presentation. Second action is mapped to `/form.post.html` and
serves as form handler that will be invoked when user submits a form.
What is different now is that this action doesn\'t forward to new page
(e.g. `/form.post.ok.jsp`). Because of special character used
(\'**#**\') it strips a word from action path starting from its end. So,
the result path is just: `/form`. Since default result type is
\'dispatch\', only the following page will be taken in account:
`/form.jsp`. And those are the very same result paths and pages as for
the first action.

Good practice is to introduce string constant with name \'**BACK**\' and
value "**#**".
{: .example}

Another example:

~~~~~ java
    @MadvocAction
    public class FooAction {

    	@Action
    	public String list() {
    		return "ok";
    	}

    	@Action
    	public String add() {
    		return "#list.ok";
    	}
    }
~~~~~

Similarly, first action (`/foo.list.html`) prepares some data for
listing and dispatches to result page: `/foo.list.ok.jsp`. Now, the
second action (`/foo.add.html`) adds new element in used collection but
should return to the same page. Therefore, result path is changed from
`/foo.add.ok` to `/foo.list.ok`, so *Madvoc* will dispatch to the very
same page, showing all elements from collection, including the new one.

Using one prefix \'**#**\' character allows to remove method name from
action path when building the result path. Speaking more generic,
\'**#**\' prefix removes one word from action path. Having more
\'**#**\' characters in the front will continue with the practice,
allowing to overwrite class name as well:

~~~~~ java
    @MadvocAction
    public class FooAction {

    	@Action
    	public String hello() {
    		return "##boo.list.ok";
    	}
    }
~~~~~

This action is mapped to `/foo.hello.html`, but the result will be
forwarded to `/boo.list.ok.jsp`.

While using one \'**#**\' character to override method name make sense
since all logic stays in one action class, using double \'**#**\' is not
consider as good practice and should be avoided if possible.

Overriding result path functionality is part of *Madvoc* core, not
result type handlers.
{: .attn}

## Full action path in result path

By default, *Madvoc* results manager is friendly with action paths that
contains extension (e.g. .html, .json, .do ...). As said, while the
result path is built, the extension is stripped from the action path.

Of course, actions can be mapped to action paths without any particular
extension, e.g. `/user.save`. Here *Madvoc*does not know if action path
has an extension or not, therefore it will strip everything after last
dot. In most cases when action path does not have an extension, we do
not want to strip anything while building result path.

For example, action path might be `/user.save `(resolved from action
`UserAction#save()`). As said, *Madvoc* would consider \'`.save`\' as
the extension and would strip it before result path creation.

To prevent action path extension stripping, action should return a
string that starts with a dot (**.**). That indicates *Madvoc* not to
strip the extension when building the result path. In above example if
action method return `".ok"` (note the starting dot), the result path
will be `/user.save.ok` (instead of just `/user.ok`). By returning just
a dot `"."`, result path will be the same as action path: `/user.save`.

If extension for an action method is explicitly set to `Action.NONE`,
*Madvoc* will consider that and will not peform the extension stripping.
Moreover, there is a `MadvocConfig` flag that indicates *Madvoc* to
strip only if extension is equal to defined one.

## Custom result types

Custom result type handler has to extend `ActionResult` class. It has to
provide result type name and to override `render()` method. Here is an
real-life example of custom result type handler for generating [JSON][1] results.

Generating JSON from existing objects might be not so easy sometimes:
some object values has to be omitted, or objects come from ORM mapper
that uses lazy initialization, so using reflection and deep-scanning is
not enough or may produce unexpected results. Idea is to manually
control what to serialize in action method. So, this example will use
result objects, similar to \'raw\' result types.

First thing is to create `JsonData`, wrapper for
`flexjson.JSONSerializer, `or any other JSON serializer (simplified
version):

~~~~~ java
    public class JsonData {

    	private static final String RESULT = JsonResult.NAME + ':';
    	private static final String[] DEFAULT_JSON_EXCLUDES
                = new String[] {"class", "*.class"};

    	private final JSONSerializer jsonSerializer;
    	private final Object target;

    	public JsonData(Object target) {
    		this(target, true);
    	}

    	public JsonData(Object target, boolean excludeDefault) {
    		this.target = target;
    		jsonSerializer = new JSONSerializer();
    		if (excludeDefault == true) {
    			jsonSerializer.exclude(DEFAULT_JSON_EXCLUDES);
    		}
    	}

    	public JsonData include(String... includes) {
    		jsonSerializer.include(includes);
    		return this;
    	}

    	public JsonData exclude(String... excludes) {
    		jsonSerializer.exclude(excludes);
    		return this;
    	}

    	public String toJsonString() {
    		return jsonSerializer.serialize(target);
    	}

    	@Override
    	public String toString() {
    		return RESULT;
    	}
    }
~~~~~

Here is the `JsonResult` result type handler (simplified version):

~~~~~ java
    public class JsonResult extends ActionResult {

    	public static final String NAME = "json";
    	public JsonResult() {
    		super(NAME);
    	}

    	@Override
    	public void render(
    			ActionRequest request, Object resultObject,
    			String resultValue, String resultPath) throws Exception {

    		if (resultObject instanceof JsonData == false) {
    			return;
    		}

    		// write output
    		HttpServletResponse response = request.getHttpServletResponse();
    		response.setContentType(MimeTypes.MIME_TEXT_PLAIN);
    		PrintWriter writer = null;
    		try {
    			writer = response.getWriter();
    			writer.println(((JsonData) resultObject).toJsonString());
    		} finally {
    			StreamUtil.close(writer);
    		}
    	}
    }
~~~~~

And the usage:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public JsonData view() {
    		Object foo = ... // create object somehow
    		return new JsonData(foo, true).exclude("address");
    	}
    }
~~~~~


[1]: http://www.json.org/

*[JSON]: JSON (JavaScript Object Notation) is a lightweight data-interchange format.
