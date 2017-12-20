# Manual registration

By default, *Madvoc* registers all actions by scanning the classpath
and looking for the appropriate annotations. On the one hand,
this is very developer friendly, but on the other hand, user may get
lost without a nice overview of what is actually registered.

For that reason, it is possible to register _everything_ in *Madvoc*
manually. Here is how.

## MadvocApp

Meet the `MadvocApp` class, the one that provides manual registration of the *Madvoc*!
This is an abstract class, so if you want to use it you have to extend it.

First, define custom madvoc application (manually):

~~~~~ java
    public class MyApp extends MadvocApp {
        @Override
        public void start() {

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

            interceptor(EchoInterceptor.class, i->i.setPrefixIn("====> "));
        }
    }
~~~~~

This class now has to be registered in the `WebApp`:


~~~~~ java
    WebApp webApp = WebApp
        .createWebApp()
        .registerComponent(MyApp.class)
        .start();
~~~~~

## Inline

But wait, you can have the same using inline registration:

~~~~~ java
    WebApp webApp = WebApp
        .createWebApp()
        .start(madvoc -> madvoc
            .result(TextResult.class)
            .action()
                .path("/hello")
                .mapTo(BooAction.class, "foo1")
                .bind()
            .action()
                .path("/world")
                .mapTo(BooAction.class, "foo2")
                .interceptBy(EchoInterceptor.class)
                .bind()
            .interceptor(EchoInterceptor.class, i->i.setPrefixIn("====> ")
            )
        );
~~~~~

It's up to you which way you prefer more.
