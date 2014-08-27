# Manual registration

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
        result(TextResult.class);

        action()
                .path("/hello")
                .mapTo(BooAction.class, "foo1")
                .bind();

        action()
                .path("/world")
                .mapTo(BooAction.class, "foo2")
                .interceptedBy(EchoInterceptor.class)
                .extension(NONE)
                .bind();
    }
~~~~~

First we define all results - just don't forget you need to add
default *Madvoc* results as they are now not added automatically.
Then we just define one action after another. It's easy as that :)

<js>docnav('madvoc')</js>