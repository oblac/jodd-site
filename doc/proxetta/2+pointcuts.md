# Pointcuts

*Proxetta* pointcuts are defined in pure Java. Pointcut is simple
interface: `ProxyPointcut` with just one method: `apply()` that should
return `true` if target method is a pointcut and if proxy should wraps
it. Since pointcut is written in Java, user may define a pointcut in
various ways.

The following example shows the definition of pointcut on all methods
that are marked with custom annotation: `@Log`.

~~~~~ java
    ProxyPointcut pointcut = new ProxyPointcutSupport() {
    	public boolean apply(MethodInfo methidInfo) {
    		return lookupAnnotation(methodInfo, Log.class) != null;
    	}
    };
~~~~~

Moreover, `MethodInfo` provides various information about the method:
class name and signature, method name, number of arguments, access flag,
return type... It also returns `ClassInfo` and `AnnotationInfo`
instances, with additional class and annotation information. All this
information may be use to fine-tune on which methods to apply a proxy.
And since all this information is stored as simple types and Strings,
pointcut definition becomes easy, but powerfull - all in plan Java.

When scanning classes for pointcuts, *Proxetta* examines all methods of
target class and of all its superclasses, up to the `Object`. Final
methods are ignored, since they can't be overridden. Moreover, only
public methods of superclasses are available for proxyfication if not
overridden.
{: .attn}

All class and method information is available as strings (due to
bytecode manipulation).

## ProxyPointcutSupport

Abstract class `ProxyPointcutSupport` helps in pointcut definition,
since it has implemented several common helper methods, such as for
checking if method is public, using wildcard match for method names etc.

Additionally, some common pointcuts are already defined: for all setters
(`AllSettersPointcut`), getters (`AllGettersPointcut`) and all public
methods (`AllMethodsPointcut`); as well as for all methods annotated with
some annotation (`MethodAnnotationPointcut`).

<js>docnav('proxetta')</js>