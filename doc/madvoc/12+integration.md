# Integration

By default, *Madvoc* action objects are created by `MadvocController`
and they are not aware of anything else then *Madvoc* and servlet
context. However, for any web application actions must somehow reference
the _outside_ world, e.g. service layer. Common need is to have
*Madvoc* actions to be aware of some application context, managed by
[Spring][1] or *Petite*, that also maintains business
components.

Trivial solutions, such manual lookup of components from business
container is out of question for serious application. The goal is to
make injection automatically.

## AnnotatedFieldsInterceptor

One solution is usage of interceptor that will inject bean references
from business context into action before action invocation. For that
*Madvoc* offers abstract `AnnotatedFieldsInterceptor`. It has to be
implemented by providing custom annotation class that will be used for
annotating action's fields. Interceptor would scan action class for
such annotated fields (caching is included), performs name lookup and
injects fetched bean into the action.

## Petite integration

It is very easy to integrate [*Petite*](/doc/petite/index.html)* with
*Madvoc*, to make all actions, interceptors and results type aware of
some *Petite* application context (typically, the service layer). It is
just matter of using `PetiteWebApplication` instead of
`WebApplication`:

~~~~~ xml
    <web-app ...>

    	...
    	<filter>
    		<filter-name>madvoc</filter-name>
    		<filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
    		<init-param>
    			<param-name>madvoc.webapp</param-name>
    			<param-value>jodd.madvoc.petite.PetiteWebApplication</param-value>
    		</init-param>
    	</filter>
    	...
    </web-app>
~~~~~

`PetiteWebApplication` creates and configures *Petite* container that is
supposed to hold application context. It also registers *Petite*-aware
variants of some *Madvoc* components, so actions, interceptors and
result type handler will be **created** within this application context.
Creating bean in *Petite* means that bean will be created, wired and
initialized within *Petite* context, but not registered.

*Madvoc* uses *Petite* container internally; there is no reason to use
it for application purposes. `PetiteWebApplication` provides different,
separate instance, that serves as application context.
{: .attn}

*Petite* container is maintained by`PetiteWebApplication`. By default,
the container is created and simply auto-configured using full
available class path at that time. However, it is easy to change this
default behavior and even provide some external instance of *Petite*
container.

## Petite and session scope

To enable session scoped *Petite* beans, it is required to register
the following listener:

~~~~~ xml
    <web-app ...>
    	...
    	<listener>
    		<listener-class>
                jodd.servlet.RequestContextListener
            </listener-class>
    	</listener>
    	...
    </web-app>
~~~~~

`RequestContextListener` store request in the current thread and all
child threads, so it can be easily accessible. It also keep
track of sessions.

<js>docnav('madvoc')</js>

[1]: http://www.springsource.org/