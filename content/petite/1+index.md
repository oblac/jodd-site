---
javadoc: 'petite'
---

# Petite

*Petite* is one great little **IoC** container and components manager. *Petite* is easy to use since it requires no external configuration; it is incredibly fast, lightweight and super-small; so anyone can quickly grasp how it works. *Petite* is quite extensible and open for customization; and non-invasive.

## Quick Overview

The following bean shows some basic *Petite* usage:

~~~~~ java
    @PetiteBean
    public class Foo {

        // dependency injected in the ctor
    	@PetiteInject
    	public Foo(ServiceOne one) {...}

        // dependency injected in a field
    	@PetiteInject("serviceTwo")
    	ServiceTwo two;

        // dependency injected with the method
    	@PetiteInject
    	public void injectService(ServiceThree three) {...}

        // dependency injected with the method
        public void injectService(
            @PetiteInject ServiceFour four) {...}

        // initialization method
    	@PetiteInitMethod
    	public void init() {...}

    	public void foo() {
    	}
    }
~~~~~

`Foo` is *Petite* bean that defines several _injection points_,
for different depending services from the container. Put this bean in the classpath and let `PetiteContainer` find it and register as a bean. Or register it manually if you like that way more.

## Why should I use it?

*Petite* is one of the lightest Java DI container around. Still, it
supports sufficient most of features offered by other containers.

Here are the key features:

+ property, method and constructor injection points.
+ Instance life-cycle management, ordered initialization methods.
+ Adding external objects to container.
+ Wiring external objects with container's context.
+ Creating objects by container.
+ Automatic registration: no XML or code needed, just annotations.
+ Programmatic configuration: using plain Java.
+ Scopes: Prototype, Singleton and custom scopes.
+ Thread local scope for thread singletons.
+ HTTP session scope for session singletons.
+ Designed to be extended.

