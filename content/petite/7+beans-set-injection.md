# Beans set injection

There is one great (and new) feature of *Petite* container: it is
possible to inject set of beans that are of the same type. All beans
registered in the *Petite* container that implements some interface can
be injected as a `Set` collection into a target bean.

## Example

Since this may sound a bit abstract at first sight, here is a simple
example. Lets say we have an interface `SuperHero`:

~~~~~ java
    public interface SuperHero {
    	String getHeroName();
    }
~~~~~

Here are two `SuperHero` implementations marked as *Petite* beans:

~~~~~ java
    @PetiteBean
    public class Batman implements SuperHero {
    	public String getHeroName() {
    		return "Batman";
    	}
    }

    @PetiteBean
    public class Batgirl implements SuperHero {
    	public String getHeroName() {
    		return "Batgirl";
    	}
    }
~~~~~

We can assume that there will be more `SuperHero` implementations, but
at this moment we are not yet sure how many.

Now, we need to call all our superheros at one place, no matter how many
implementations there are. All you have to do is specify the injection
target as a `Set` field that has generics type of beans that has to be
injected:

~~~~~ java
    @PetiteBean
    public class GothamCity {

    	@PetiteInject
    	private Set<SuperHero> superHeros;

    	public void callForHelp() {
    		for (SuperHero superHero : superHeros) {
    			System.out.println(superHero.getHeroName());
    		}
    	}
    }
~~~~~

After retrieving `GothamCity` from container, the field `superHeroes`
will contain an `Set` instance. Set will contain all `Petite` beans that
are of type `SuperHero`. Easy as that!

## Some features

* It works only for **fields**. Due to Java limitation (generic type
  erasure) it is possible to read generic type only of fields. So set
  injection will not work for methods and parameters.
* field names do not play any role in injection, just generic type.
* Set instance will be always created, even if there are no matching
  beans. This prevents null-checking.
* Only `Collection`, `Set` and `HashSet` can be used as field type.
  Although internal code practically allows all `Collection` types, we
  wanted to prevent possible vagueness of having other types (e.g.
  having a `List` with no defined beans order).

## For What It's Worth

We can think of interface methods as messages and target beans as
message destinations (hey, who said *Event Bus* ? :) Let's see this
idea in action.

Let's imagine that there is a requirement to send an notification
e-mail every time when some user interaction occurs - e.g. when user
confirms some payment. We don't have to be theoretical physicists to
come with an interface like this one:

~~~~~ java
    public interface PaymentEvent extends AppEvent {
    	void paymentFinished(User user, Payment payment);
    }
~~~~~

Now we can code an implementation, `EmailPaymentEvent`. This one knows
how to send an e-mail that contains all payment data to the user.

Let's now focus on usage in `PaymentService` - business class that
actually performs the payment and that should call the event after
successful payment.

### Common approach

Usually, we could simply wire these beans, i.e. inject
`EmailPaymentEvent` into the `PaymentService`\:

~~~~~ java
    @PetiteBean
    public class PaymentService {

    	@PetiteInject
    	EmailPaymentEvent emailPaymentEvent;

    	public void processOrder(User user, Payment payment) {
    		...	// business code
    		emailPaymentEvent.paymentFinished(user, payment);
    	}
    }
~~~~~

And this would work. But...

### Some problems

Sending emails can be a long process - especially if some reports has to
be generated in PDF, etc.. Why stopping the user request thread for
this? We could change the `PaymentEvent` code to support executors
thread pool - but, to be hones, that is not the right place for that.
Event doesn't have to be aware of the way how it is invoked.

Moreover, lets say that we need to send a SMS to the user, too,
indicating successful payment. So we can code another class that sends
an e-mail and wire it to the services. That would be too much
error-prone work.

### The new way

The solution is obvious - we can build a façade layer that will
dispatch event call to all our implementations. However, we still have
to manually wire all our implementations in the façade. So, the event
delegation and dispatching logic would be hard-wired to the event
implementations.

Instead, we can have the following code:

~~~~~ java
    @PetiteBean
    public class PaymentEventDispatcher implements PaymentEvent {

    	@PetiteInject
    	Set<PaymentEvent> paymentEvents;

    	void paymentFinished(User user, Payment payment){
    		// process paymentEvents any way you need:
    		// using thread pools, iterative etc.
    	}
    }
~~~~~

So adding a new payment event is just about writing the implementation -
and that's it! Everything will continue working as before.

Someone may noticed that `PaymentEventDispatcher` is also a
`PaymentEvent` - since it is a dispatcher and façade, it make sense.
But wait, since `PaymentEventDispatcher` is also part of the *Petite*
context, wouldn\'t it be also inside the injected set? Good thinking,
but no - *Petite* is smart, so it will not put target injection instance
in the set.

This gives us a new freedom - we can have independent dispatcher logics
that would work for different events. For example, we can have a
parallel executor, or iterative one, already implemented as an abstract
dispatcher class that can be reused for your needs.

## New concept - your ideas?

This is a new concept in *Petite*. Although the explained functionality
will stay, we feel there is more behind this idea that can enrich this
concept.

Please feel free to contact us with your ideas about this interesting
subject;)
