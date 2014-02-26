# Advices

*Proxetta* defines advices in a unique way: they are written in the same
way as one would write overridden method in a subclass.

Advices implement the `ProxyAdvice` interface that has just one method:
`execute()`. Now, the question is how *Proxetta* references the proxy
target, i.e. the pointcut method that is proxified. Instead of having
some custom object filled with data about the target method (pointcut),
*Proxetta* introduces special \'macro\' class `ProxyTarget` for this
purpose. `ProxyTarget` is just dummy class and its methods are empty!
Usage of its methods serves just as macros that will be replaced by
appropriate and correct bytecode! After the process of replacing
`ProxyTarget` macro methods, all dependencies on `ProxyTarget` will be
gone. Macro methods are replaced with the bytecode that mimic the code
that developer would write by himself, if he would like to subclass
target class and override target method (pointcut).

Here is the definition of the advice that should log some data (on all
log pointcuts):

~~~~~ java
    public class LogProxyAdvice implements ProxyAdvice {

        public Object execute() {
            int totalArgs = ProxyTarget.argumentsCount();
            Class target = ProxyTarget.targetClass();
            String methodName = ProxyTarget.targetMethodName();
            System.out.println(">>>" + target.getSimpleName()
                    + '#' + methodName + ':' + totalArgs);
            Object result = ProxyTarget.invoke();
            System.out.println("<<<" + result);
            return result;
        }
    }
~~~~~

When *Proxetta* finds some pointcut, i.e. proxy target method on which
to apply this advice, it will **replace** all `ProxyTarget` method
invocations (i.e. macros) with correct bytecode. For example,
`ProxyTarget.argumentsCount()` will be **replaced** by appropriate
number of target method arguments.

For more complete example, if the pointcut is the method in the
following class:

~~~~~ java
    public class Foo {
    	public String someMethod(Integer first, double second) {...}
    }
~~~~~

then the proxy bytecode generated using above advice will look like:

~~~~~ java
    public class Foo$Proxy extends Foo {
    	public String someMethod(Integer first, double second) {
    		int totalArgs = 2;                       // arguments count
    		Class target = Foo.class;                // target class
    		String methodName = "someMethod"         // target method name
    		System.out.println(">>>" + target.getSimpleName()
                    + '#' + methodName + ':' + totalArgs);
    		Object result = super.someMethod(first, second);
    		System.out.println("<<<" + result);
    		return result;
    	}
    }
~~~~~

Replacements occurs in the run-time, during proxy creation, using
bytecode manipulation.

It is advisible to use `ProxyTarget` macro-methods just in simple
assignment expressions.
{: .attn}

During creation of proxy class and methods, *Proxetta* also copies
advice's constructors, static initialization blocks, fields, etc.
Advices should be written very carefully, always having in mind that
advice's code will be added to the target proxy class. Common mistake
is accessing package scoped class from advice: while it is valid for
advice, it will be not valid for target class, since it is in different
package. Another mistake is usage of static attributes declared in
advice's class - since they are copied to every class, each one will
have its own static attribute, instead of having one field for all
classes. This can be solved by using some external class that will hold
this static attribute.

Using inner classes as advices is not supported.
{: .attn}

<js>docnav('proxetta')</js>