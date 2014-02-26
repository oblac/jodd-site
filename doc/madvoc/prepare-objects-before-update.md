# Prepare objects before update

Typical problem with web applications is update of (domain) objects. It
is done in two steps: the first is presenting HTML form with only
editable properties of an object, and, the second, is the actual update
when form is submitted. The problem is that on submission in second step
we must be aware of what object\'s properties to update.

The obvious solution is to put values of all non-editable object
properties in the form using hidden input fields. Some web framework
then would inject all those values into an empty domain object and it
becomes ready for actual update.

However, this problem has its disadvantageous: values of all object
properties should be presented in the form, hidden or not. Not only that
this makes forms bigger and increases amount of posted (and sent) data,
slows down the runtime and development time (all hidden values has to be
properly encoded, too), but it also reduces the maintainability, since
every time a property is changed, added or removed from the object, all
forms where object is used have to be manually updated.

## Preparable actions

*Madvoc* offers another approach for this problem: to run some logic to
load an object from the database, so that when parameters are set they
can be set on this object. This may be done by using
`PrepareInterceptor` before `ServletConfigInterceptor`. During action
preparation object would be loaded from the database and after
parameters will be injected in the loaded object.

First (good) consequence is that usually, there is no need for extra
code in action method for viewing the form. Second (bad) consequence is
that `prepare()` needs ID parameters to load object from database.
Hopefully, *Madvoc* saves from getting IDs from parameters manually:
`IdRequestInjectorInterceptor`. It simply injects only parameters that
ends with ".id"!

There is one more (and last) caveat: we have to be sure that empty
request parameters are not ignored. By default, everything is ok, empty
parameters are not ignored. Anyhow, this can be set by setting *Madvoc*
parameter:
`injectorsManager.requestScopeInjector.ignoreEmptyRequestParams`.

## Putting all together

It is all about the interceptors. Default interceptors stack:

~~~~~ java
    public class AppInterceptorStack extends ActionInterceptorStack {

    	public AppInterceptorStack() {
    		super(
    				IdRequestInjectorInterceptor.class,
    				PrepareInterceptor.class,
    				ServletConfigInterceptor.class
    		);
    	}
    }
~~~~~

## Usage

Here is the most interesting part of an action from web application that
uses *Madvoc*, [Spring][1] and [Hibernate][2].

~~~~~ java
    @MadvocAction
    @InterceptedBy(AppInterceptorStack.class)
    public class BankEditAction implements Preparable {

        // injected by spring, on action creation, before injections
    	@Inject
    	BankService bankService;

    	@In @Out
    	Bank bank;

    	@Override
    	public void prepare() {
            // returns null if entity is null
    		bank = bankService.findBankById(bank);
    	}

    	@Action
    	public void view() {}

    	@Action
    	public Object store() {
    		// validate somehow
    		bankService.storeBank(bank);            // merge it by hibernate
    		return OK;
    	}
    }
~~~~~

Plain and simple. The same action is used both for creating new or
updating existing banks. Next example is more complicated: it is a form
where user enters employee data and where it assigns a client to which
employee belongs.

~~~~~ java
    @MadvocAction
    @InterceptedBy(AppInterceptorStack.class)
    public class EmployeeEditAction implements Preparable {

    	@Inject
    	ClientService clientService;	// injected by spring

    	@In	@Out
    	Employee employee;

    	@In @Out
    	Client client;

    	@Override
    	public void prepare() {
    		employee = clientService.findEmployeeById(employee);
    		if (client == null) {
    			// reads client from current employee, if exist
    			client = employee != null ? employee.getClient() : null;
    		} else {
    			client = clientService.findClientById(client);
    		}
    	}

    	@Action
    	public void view() {}

    	@Action
    	public Object store() {
    		// validate somehow
    		employee.setClient(client);		// set employee's client
    		clientService.storeEmployee(employee);
    		return OK;
    	}
    }
~~~~~

[1]: http://www.springsource.org/
[2]: https://www.hibernate.org/