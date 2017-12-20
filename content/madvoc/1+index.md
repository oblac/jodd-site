---
javadoc: 'madvoc'
---

# Madvoc

*Madvoc* is MVC framework that uses conventions and annotations in a pragmatic
way to simplify web application development. It is really easy to use; a significant
effort is put into making usage simple. There are no external (xml)
configurations, actions are simple POJOs, it is compatible with any view
technology and so on... What's best is that its developer friendly:
*Madvoc* offers several ways how it can be configured or used,
so you can use whatever matches your coding preferences.

## One minute tutorial

This is a simple *Madvoc* action:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@In
    	String name;

    	@Out
    	String value;

    	@Action
    	public String world() {
    		value = "Hello World!";
    		return "ok";
    	}
    }
~~~~~

This action class and a method defines the following mappings:

~~~~~
/hello.world.html → HelloAction#world() → /hello.world.ok.jsp
~~~~~

The action method takes one input request parameter (`name`) and prepares
one request attribute for the output (`value`). Action is also intercepted
by default interceptor stack.

This action uses only default configuration; but everything can be
configured to work differently. For example, the following action is also
an *Madvoc* action:

~~~~~ java
    @MadvocAction
    public class BookAction {

        @RestAction("{bookId}")
        public Book get(@In int bookId) {
        }
    }
~~~~~

This time the mappings is:

~~~~~
GET /book/123 → BookAction#get() → jsonOf(Book)
~~~~~

Make and use _your own_ *Madvoc* conventions, easily!
