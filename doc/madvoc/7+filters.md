# Filters

<div class="doc1"><js>doc1('madvoc',20)</js></div>
**Action Filters** are similar to action interceptors: they run before action
method and after the result is rendered! That is a main difference:
interceptors are executed before rendering result.

Action Filters looks very much like Servlet filters. However, it is much easier
to configure an action filter and to map it to certain actions.

Everything said for action interceptors can be applied to action filters!
Filters are defined with `@FilteredBy` annotation, that can be used
in the very same way as interceptors. For example:

~~~~~ java
    @MadvocAction
    @FilteredBy(AppendingFilter.class)
    @InterceptedBy(DefaultWebAppInterceptors.class)
    public class FilterAction {

        @Action
        public void view() {
        }
    }
~~~~~

This action class defines one filter and one interceptor (on all its action
methods). Note that filters are always executed _first_, before interceptors.