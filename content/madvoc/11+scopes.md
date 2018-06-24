# Scopes

*Madvoc* scope is a class that performs injection and outjection using the values available in some context; such as: request, session, *Madvoc* components...

Scopes are defined and used by the `@Scope` annotation and scope class. Since scopes are frequently used, all default scopes in *Madvoc* has it's own annotation, too.

These are the available scopes:

+ `@Body` - injects the RAW body string.
+ `@Cookie` - reads/writes cookies. Can inject all cookies of given name.
+ `@Header` - injects/outjects values from request/response header.
+ `@JsonBody` - injects the JSON body, parsed to a target's type.
+ `@MadvocContext` - injects any *Madvoc* component.
+ `@Request` - process request attributes and parameters.
+ `@ServletContext` - deals with servlet context attributes.
+ `@Session` - deals with session attributes.

## Custom Scope

Scopes are implementation of the `MadvocScope`. You can defined your own implementation by extending this class and providing the implementation of any of defined methods. Not all methods have to be implemented!

Custom scope can be used with the generic `@Scope` annotation, where scope class is passed as annotation value. OR - even better - by creating a new scope annotation that is annotated with the `@Scope`:

~~~~~ java
    @Documented
    @Retention(value = RetentionPolicy.RUNTIME)
    @Target({ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER})
    @Scope(MyCustomScope.class)
    public @interface MyCustom {
}
~~~~~

## Request Scope

Request scope is one very powerful scope. It knows how to inject anything related to the request: parameters, uploaded files, attributes. `RequestScope` can be fine-tuned with few parameters, explained in class `RequestScopeCfg`.

Besides the default behavior of injecting _values_, `RequestScope` may inject some pure servlet class into the target. Injection point may be any of the following types:

+ `HttpServletRequest`
+ `ServletRequest`
+ `HttpServletResponse`
+ `ServletResponse`
+ `HttpSession`
+ `ServletContext`
+ `AsyncContext`
+ `ActionRequest`

## ServletContext Scope

Similarly, `ServletContextScope` injects the subset of servlet classes into the target.

Example:

~~~~~ java
    @MadvocAction
    public class MiscAction {

      @In @ServletScope
      HttpSession session;

      @In @Request
      HttpServletResponse servletResponse;

      ...
~~~~~

