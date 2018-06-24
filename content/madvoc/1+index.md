---
javadoc: 'madvoc'
---

# Madvoc

*Madvoc* is a MVC framework that uses conventions and annotations in a pragmatic way to simplify the development of web applications. A significant effort is put into making usage of *Madvoc* simple. There are no external (xml) configurations, actions are simple POJOs, it is compatible with any view technology and so on... What's best is that it is _developer friendly_: *Madvoc* offers several ways how it can be configured and used, so you can use whatever matches your coding preferences.

In a hurry? Want to start right-away? Check [Joy](/joy).
{: .attn}

## One minute tutorial

Here is a simple *Madvoc* _action_ (request handler):

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

This action class and a method define the following mapping:

~~~~~
/hello.world → HelloAction#world() → /hello.world.ok.jsp
~~~~~

This is NOT the only way how mappings works! In fact, *Madvoc* advocate users to change the defaults to whatever the convention is in use.
{: .attn}

The action method takes one input request parameter (`name`) and prepares one request attribute for the output (`value`). Action is also intercepted by default interceptor stack (default configuration is defined outside of actions).

While this action uses only default configuration; almost everything can be configured to work differently. For example, the following action is also an *Madvoc* action - this time one that defines a REST endpoint:

~~~~~ java
    @MadvocAction
    public class BookAction {

        @RestAction("{bookId}")
        public Book get(@In int bookId) {
        }
    }
~~~~~

The REST mappings is:

~~~~~
GET /book/123 → BookAction#get() → Book.json
~~~~~

Quite simple, yet powerful. Go and make _your own_ *Madvoc* conventions, easily!
