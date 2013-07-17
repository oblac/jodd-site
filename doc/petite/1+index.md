# Petite ![Petite](petite.png "Petite!")

@@javadoc-p(petite)

*Petite* is a **IoC** container. (oh-yes-another-one). Then again, it
is easy to use since it requires no external configuration; it is
incredibly fast; it is lightweight and small so anyone can understand
how it works just from examining the code; it is extensible and open for
customization; and, finally, it is non-invasive.

## Petite Overview

The following bean shows basic *Petite* usage:

~~~~~ java
    @PetiteBean
    public class Foo {

    	@PetiteInject
    	public Foo(ServiceOne one) {...}

    	@PetiteInject("serviceTwo")
    	Service two;

    	@PetiteInject
    	public void injectService3(ServiceThree three) {...}

    	@PetiteInitMethod
    	public void init() {...}

    	public void foo() {
    	}
    }
~~~~~

In this example, `Foo` is *Petite* bean that defines several injection
points, for different services from the container.

Above example uses only defaults; however, `Petite` can be configured in
many ways.

## Reasons why

*Petite* is one of the lightest Java DI container around. Still, it
supports sufficient most of features offered by other containers. To
some it may resemble to [Guice][1]{: .external} (due to annotations
usage): and yes it does, but *Petite* was developed first and it still
has some conceptual differences.

Here are the key features:

* property, method and constructor injection points.
* Instance life-cycle management, ordered initialization methods.
* Adding external objects to container.
* Wiring external objects with container's context.
* Creating objects by container.
* Automatic registration: no XML or code needed, just annotations.
* Programmatic configuration: using plain Java.
* Scopes: Prototype, Singleton and custom scopes
* Thread local scope for thread singletons.
* HTTP session scope for session singletons.
* Designed to be extended.


[1]: http://code.google.com/p/google-guice/
