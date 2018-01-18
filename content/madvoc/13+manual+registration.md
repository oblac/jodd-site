# Manual registration

By default, *Madvoc* registers all actions by scanning the classpath
and looking for the appropriate annotations. On the one hand,
this is very developer friendly, but on the other hand, user may get
lost without a nice overview of what is actually registered.

For that reason, it is possible to register _everything_ in *Madvoc*
manually. Here is how.

## The Router

`WebApp` provides a _router_ - way to specify action handlers in an easy, developer-friendly way. One way to get to the router is by extending the `WebApp`:

~~~~~ java
    public class MyApp extends WebApp {
        @Override
        protected void initialized() {
            route()
                .path("/hello")
                .mapTo(BooAction.class, "foo1")
                .bind()
            .get("/world")
                .mapTo(BooAction.class, "foo2")
                .interceptBy(EchoInterceptor.class)
                .bind()
            .interceptor(EchoInterceptor.class, i->i.setPrefixIn("====> "));
        }
    }
~~~~~

## Inline

But wait, you can have the same using inline registration:

~~~~~ java
    WebApp webApp = WebApp
        .createWebApp()
        .start(madvoc -> madvoc
            .route()
                .path("/hello")
                .mapTo(BooAction.class, "foo1")
                .bind()
            .get("/world")
                .mapTo(BooAction.class, "foo2")
                .interceptBy(EchoInterceptor.class)
                .bind()
            .interceptor(EchoInterceptor.class, i->i.setPrefixIn("====> ")
            )
        );
~~~~~

It's up to you which way you prefer more.
