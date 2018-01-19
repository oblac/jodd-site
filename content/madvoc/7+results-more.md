# Results (cont.)

More features and topics about Results.

## Aliases

Hard-coding URLs and method names in result values is not considered
as a good practice. *Madvoc* offers way to define path _aliases_ to
prevent hard-coding. Aliases can be defined in following ways:
in action annotation or manually in *Madvoc* configuration.

Either way defined, aliases may be used in result value, surrounded by
`<` and `>` signs.

Aliases are also useful for marking 'open' points for integration
with 3rd party code. You may mark some important action method
with alias name and then allow 3rd party code to use it.

### Aliases defined in annotation

Aliases may be defined using `@Action`'s element `alias` on target action.

One of the previous examples can be re-written in the following way:

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

Alias is defined in the `IndexAction` class: alias name is `index` and value equals to the action path: `/index.html`. Therefore, behavior of the `OneAction#execute` action remains identical.

Aliases are convenient for redirection results.
{: .attn}

### Default aliases

Besides explicit aliases, every *Madvoc* action has it's default
alias. Default alias is named from actions class and method name:

`default_alias = <action class name> + '#' + <action method name>`

This way you can reach to any action method in your application.

### Aliases defined by ActionsManager

Aliases also may be registered manually by using `ActionsManager` component:

~~~~~ java
    actionsManager.registerPathAlias("/hello.all.html", "/hi-all");
~~~~~

This gives even more flexibility! You can rewrite the whole result path and make action go to totally different target JSP.

## Overriding action path within result path

By default, result path consist of action path and result value.
Often is necessary for an action to return to result path of another
action, defined in the same action class. Following action illustrates this:

~~~~~ java
    @MadvocAction
    public class FormAction {

    	@Action
    	public void view() {
    	}

    	@Action(extension = NONE)
    	public String post() {
    		return "#";
    	}
    }
~~~~~

This is a common case in web applications. Some form is mapped to action
path: `/form.html`. This action (method: `view()`) just prepares form
for presentation. Second action is mapped to `/form.post` (no extension)
and serves as form handler that will be invoked when user submits a form.
What is different now is that this action doesn't forward to new page
(e.g. `/form.post.jsp`). Because of special prefix characters used
(`#`) it strips a word from _action path_ starting from its end. So,
the result path is just: `/form`. And this means that the both actions
will share the same resulting page, e.g. `/form.jsp`.

Think about `#` as a 'BACK' command for actions path.
{: .attn}

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
    		return "##list.ok";
    	}
    }
~~~~~

Similarly, first action (`/foo.list.html`) prepares some data for
listing and dispatches to result page: `/foo.list.ok.jsp`. Now, the
second action (`/foo.add.html`) adds new element in this collection, but
should return to the same page. Therefore, result path is changed from
`/foo.add.html.ok` to `/foo.list.ok`. *Madvoc* will dispatch to the very
same page, showing all elements from collection, including the new one.

Note that we had to use two `#` signs to move two segments back in action path.
We had to skip both extension (`html`) and method name (`add`) in action path
to get to the same root: `/foo`.

When using `#` there is one more thing to know. As we explained, result path
consist of action path and result value. Dispatcher result uses both to
find matching JSP. For dispatcher it is important to know which part is
action part (and that can be reduced) and which part is result value
(that can be appended during finding matched JSP). When you return `#`
to override the action path, everything after that sign is considered
to be the action path! Consider the following hello-world example:

~~~~~ java
    @MadvocAction
    public class HelloAction {
        @Action
        public String world() {
            return ...;
        }
    }
~~~~~

What we have here is an action mapped to: `/hello.world.html`. If we return
`"ok"`, that string will be result value.
Dispatcher would try to match following JSPs:
`/hello.world.html.ok.jsp`, `/hello.world.html.jsp`,
`/html.world.ok.jsp`, `/hello.world.jsp`... In other words, result value
remains the same while action path is getting shorten.

But if we return `#ok` then only action path is going to be modified and
result value would be `null`. Dispatcher would just try to match following:
`/hello.world.ok.jsp`, `/hello.world.jsp`... That might be different
from what expected. In order to specify the result value while using
the `#` you need to add additional dot to separated value from path.
So if we return `#.ok` the action path will be reduced but result value
would be `"ok"`. Dispatcher would try to match following JSPs:
`/html.world.ok.jsp`, `/hello.world.jsp`...

## Result path cheat-sheet

Following table summarize default behavior of `ResultMapper` - *Madvoc*
component dedicated for building result paths from results and action
path.

| action path                | result value    | result path             |
|----------------------------|-----------------|-------------------------|
| *                          | /foo            | /foo                    |
| *                          | /foo.ext        | /foo.ext                |
| /zoo/boo.foo               | ok              | /zoo/boo.foo.ok         |
| /zoo/boo.foo               | doo.ok          | /zoo/boo.foo.doo.ok     |
| /zoo/boo.foo               | #               | /zoo/boo                |
| /zoo/boo.foo               | #ok             | /zoo/boo.ok             |
| /zoo/boo.foo               | #.ok            | /zoo/boo.ok             |
| /zoo/boo.foo               | #doo.ok         | /zoo/boo.doo.ok         |
| /zoo/boo.foo               | #doo..ok        | /zoo/boo.doo.ok         |
| /zoo/boo.foo               | (void) or (null)| /zoo/boo.foo            |
| /zoo/boo.foo               | ##ok            | /zoo/ok                 |
