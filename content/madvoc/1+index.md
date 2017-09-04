---
javadoc: 'madvoc'
---

# Madvoc

*Madvoc* is MVC framework that uses CoC and annotations in a pragmatic
way to simplify web application development. It is easy to use, learning
curve is small and it is easy to extend. There are no external (xml)
configuration, actions are simple POJOs, it is compatible with any view
technology, its pluggable and so on... What's best is that it offers
several ways how it can be configured or used, so you can tweak it
to match your coding preferences.

## One minute tutorial

Simple POJO action:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@In
    	String name;

    	@Out
    	String value;

    	@Action
    	public String world() {
    		System.out.println("HelloAction.world " + name);
    		value = "Hello World!";
    		return "ok";
    	}
    }
~~~~~

Above action class defines action method `HelloAction#world()` that is
mapped to the following url: `/hello.world.html`. The resulting view for
dispatching is: `/hello.world.ok.jsp`. Action takes one input request
parameter (`name`) and prepares one request attribute for the output
(`value`). Action is also intercepted by default interceptor stack.

Action from above example uses only defaults; but, it can be
configured and written in different ways. For example, the following action
is also working in *Madvoc*:

~~~~~ java
    @MadvocAction
    public class BookAction {

        @RestAction("${bookId}")
        public Book get(@In int bookId) {
        }
    }
~~~~~

Method `BookAction#get` handles GET urls like: `/book/123` and displays
the result using `/book/get.jsp` template.

Make and use _your own_ *Madvoc* conventions!

## Action lifecycle

<div class="clearfix">

<div style="width:80px; background:#fcc; padding: 40px 10px; margin: 60px 10px 10px 0; text-align:center; float:left;border: 1px solid #999"><b>action path</b></div>

<div style="padding: 100px 0 0 0; margin: 0; float:left"><i class="fa fa-arrow-right"></i></div>

<div style="width:120px; background:#eee; padding: 40px 10px; margin: 60px 10px 10px 10px; text-align:center; float:left;border: 1px solid #999"><b>MadvocController</b></div>

<div style="padding: 100px 0 0 0; margin: 0; float:left"><i class="fa fa-arrow-right"></i></div>

<div style="width:250px; background:#ddf; padding: 10px ; margin: 20px 10px 10px 10px; float:left; border: 1px solid #999"><div><b>Filters</b></div>

    <div style="width:90px; background:#ccf; padding: 10px ; margin: 20px 10px 10px 10px; float:left; border: 1px solid #999"><b>Interceptors</b>

        <div style="width:40px; background:#ffc; padding: 21px 10px; margin: 10px; text-align:center; border: 1px solid #999"><b>Action</b></div>
    </div>

    <div style="padding: 70px 0 0 0; margin: 0; float:left"><i class="fa fa-arrow-right"></i></div>

    <div style="width:60px; background:#cfc; padding: 40px 10px; margin: 20px 10px 10px 10px; text-align:center; float:left;border: 1px solid #999"><b>Result</b></div>
</div>

</div>

`MadvocController` receives HTTP request and lookup for `ActionConfig`
(action configuration) for requested action path. If action path is
registered, `MadvocController` instantiates new `ActionRequest` -
encapsulation of action request and action method proxy.

Interceptors intercept the request being sent to and returning from the
action. In some cases, interceptor might keep an action from executing.
Interceptors can also change the state of an action before it executes.

Filters wraps interceptors, actions and results, similar to servlet filters.

Once execution of the action and all interceptors is complete, the
action request is sent to result to render the results.
