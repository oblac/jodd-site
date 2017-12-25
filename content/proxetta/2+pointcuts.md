# Pointcuts

*Proxetta* pointcuts are defined in pure Java. Pointcut is defined by simple functional interface: `ProxyPointcut#apply()` that should return `true` if target method is a pointcut and if proxy should be applied on it. Since pointcut applying is done in pure Java, user may define pointcuts in various proprietary ways.

The following example shows the definition of a pointcut on all methods that are marked with custom annotation: `@Log`.

~~~~~java
    ProxyPointcut pointcut = MethodWithAnnotationPointcut.of(Log.class);
~~~~~

You can combine `ProxyPointcut` definitions using `and()` and `or()`, for example:

~~~~~java
	ProxyPointcut pointcut = ((ProxyPointcut)
				methodInfo -> methodInfo.isPublicMethod()
				&& methodInfo.isTopLevelMethod())
			.and(MethodWithAnnotationPointcut.of(Log.class));
~~~~~

`MethodInfo` argument provides various information about the target method:
class name and signature, method name, number of arguments, access flag,
return type... It also returns `ClassInfo` and `AnnotationInfo`: additional class and annotation information. All this
information may be use to define on which methods to apply a proxy.
And since all this information is stored as simple types and Strings,
pointcut definition becomes easy, but powerful - all in plan Java.

When scanning classes for pointcuts, *Proxetta* examines all methods of
target class and of all its superclasses, up to the `Object`. Final
methods are ignored, since they can't be overridden. Moreover, only
public methods of superclasses are available for proxyfication if not
overridden.
{: .attn}

All class and method information is available as strings (due to
bytecode manipulation).
