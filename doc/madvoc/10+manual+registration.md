# Manual registration

<div class="doc1"><js>doc1('madvoc',20)</js></div>
By default, *Madvoc* registers all actions by scanning the classpath
and looking for the appropriate annotations. On the one hand, 
this is very developer friendly, but on the other hand, user may get
lost without a nice overview of what is actually registered.

For that reason, it is possible to register _everything_ in *Madvoc* 
manually. Here is how.


## ManualMadvocConfigurator

Obviously, we have to change the default *Madvoc* configurator 
(defined in `web.xml`) to `ManualMadvocConfigurator`. This configurator
does not register anything. Instead it provides few methods and a 
builder for easier, fluent registration in pure Java. Here is an example:

~~~~~ java
    public void configure() {
        action()
                .path("/hello")
                .mapTo(BooAction.class, "foo1")
                .result(TextResult.class)
                .bind();

        action()
                .path("/world")
                .mapTo(BooAction.class, "foo2")
                .interceptedBy(new EchoInterceptor())
                .extension(NONE)
                .result(TextResult.class)
                .bind();
    }
~~~~~

It's easy as that :) Also, don't forget NOT to create more interceptor
instances then needed, as they can be shared among the actions!
