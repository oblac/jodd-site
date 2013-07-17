# Tx with Proxetta

Up to now, all database statements were executed in auto-commit mode.
This is not how it should be in practice. Services must ensure atomicity
of the operation, so it anything breaks during the execution, complete
operation has to be rolledback.

Obviously, we are talking about the transactions here. *Jodd* provides
its custom simplified transaction support. Transactions in *Jodd* are
done across several transactional resources (one of them may be a
database). *Jodd* transactions does **not** support distributed
transactions, two-phase commits and all those features that are part of
large, huge, enterprise systems. Instead, it offers what you really need
in most cases: pragmatic transactions layer that works without J2EE
container without much trouble.

Naturally, we do not want to manually manage transactions. Instead, we
will use aspects to describe where transactions should be managed and
which type of transaction is in use. *Proxetta* will find all annotated
service methods and manage transactions around.

There are not much code in this step, but it is a hard-core one. Stay
with us!

## Initializing Proxetta

*Jodd* already offers an advice for methods annotated with
`@Transaction` annotation: `AnnotationTxAdvice`. Let's apply it on all
annotated service methods of beans registered in application *Petite*
container. Since we have to integrate *Proxetta* with the *Petite*,
*Proxetta* has to be initialized *before* the *Petite* container.
`AppCore` is now modified to:

~~~~~ java
    public class AppCore {
    	...
    	public synchronized void start() {
    		AppUtil.resolvePaths()
    		initLogger();
    		initProxetta();
    		initPetite();
    		initDb();
    		...				// init everything else
    	}

    	Proxetta proxetta;

    	void initProxetta() {
    		ProxyAspect txServiceProxy = new ProxyAspect(AnnotationTxAdvice.class,
    			new MethodAnnotationPointcut(Transaction.class) {
    				@Override
    				public boolean apply(MethodInfo mi) {
    					return isPublic(mi) &&
    							isTopLevelMethod(mi) &&
    							matchClassName(mi, "*Service") &&
    							super.apply(mi);
    				}
    			});
    		proxetta = Proxetta
                    .withAspects(txServiceProxy)
                    .loadsWith(this.getClass().getClassLoader());
    	}
    	...
    }
~~~~~

We defined here our transactional proxy by setting the advice and
pointcut on all method annotated with `@Transaction`. Pointcut is
defined also on public, top level methods, of all classes which name
ends with \'`Service`\'.

Once when *Proxetta* is ready, it has to be use during bean registration
in *Petite* container. Like many things in *Jodd*, this is done by
extending - or use provided solution: `ProxettaAwarePetiteContainer`\:

~~~~~ java
    public class AppCore {
    	...
    	void initPetite() {
    		petite = new ProxettaAwarePetiteContainer(proxetta);
    		...
    	}
    	...
    }
~~~~~

## Transaction Manager

`JtxTransactionManager` is transaction manager responsible for
transactions propagation and resource managers. In general, it works
across several transaction resource types. However, if we are sure that
we gonna use just one transactional resource and that is a database
(that is often true) we can use the simplified version of transaction
manager: `DbJtxTransactionManager`. It is simplified just in sense of
usage, all underlying mechanisms are the same. For example, it is easier
to create such manager by just providing `ConnectionProvider` instance.

Our advice must be somehow aware of transaction manager, in order to
control transactions. Advice `AnnotationTxAdvice` communicates
with the rest of the world through `AnnotationTxAdviceManager`. To
refresh our knowledge: *Proxetta* advice defines the code that will be
actually inserted around pointcuts using byte code manipulation.
Advice's code has to be written with that in mind. Therefore, it may
happens that code that compiles and looks correct doesn't work in
run-time, once applied on target methods. Usually, the easiest way for
advice to communicate with the other parts of the application is through
some global static field. This is how we will set the instance of
`AnnotationTxAdviceManager` and make it available for the advice.

Third and the last thing is the change of used session provider.
Sessions now doesn't have to be stored in thread storage since they are
transactional resource and managed by transactional manager. So we will
use `DbJtxSessionProvider` to provide sessions when needed. We will use
the default version that expect that transaction exist and will throw an
exception if not. In practice this means that database access must
occurs behind the `@Transaction` methods.

Here are described changes applied on `initDb()`\:

~~~~~ java
    public class AppCore {
    	...
    	JtxTransactionManager jtxManager;
    	ConnectionProvider connectionProvider;

    	void initDb() {
    		petite.registerBean("dbpool", CoreConnectionPool.class);
    		connectionProvider = (ConnectionProvider) petite.getBean("dbpool");
    		connectionProvider.init();

    		// transactions
    		jtxManager = new DbJtxTransactionManager(connectionProvider);
    		jtxManager.setValidateExistingTransaction(true);
    		AnnotationTxAdviceSupport.manager
                    = new AnnotationTxAdviceManager(jtxManager, "$class");
    		DbSessionProvider sessionProvider = new DbJtxSessionProvider(jtxManager);

    		// global settings
    		DbDefault.debug = true;
    		DbDefault.connectionProvider = connectionProvider;
    		DbDefault.sessionProvider = sessionProvider;

    		...
    	}

    	void stopDb() {
    		jtxManager.close();
    		connectionProvider.close();
    	}
~~~~~

So everything what is said above is set just in few lines. Lets cover
some more details. In line #13, we ask transaction manager to validates
existing transactions before participating in them. This is not
necessary, but it makes us declaring transactions more precisely.
`AnnotationTxAdviceManager`, as said, is used by advice. It reads
annotations, holds configuration and offers way to handle transactions.
Second` `argument specifies what will be the transaction context (i.e.
tx owner) using simple patterns. Second requests for transactions inside
the same transaction context is ignored. Practically this means that if
class is set as transactional context (`"$class"`), first method call
will create the transaction and all nested calls of other transactional
methods of the same class will not request new transactions.
Alternatively, we could use method context (`"$class#$method"`), or just
public context where there are no nested transactions (any constant
string, e.g. "`tx`").

Once again, this is just one way how *Jodd* can be configured...

## Transactions declaration

Service methods has to be annotated to declare transactions on them:

~~~~~ java
    import static jodd.jtx.JtxPropagationBehavior.PROPAGATION_SUPPORTS;

    @PetiteBean
    public class FooService {

    	@PetiteInject
    	AppDao appDao;

    	@Transaction(propagation = PROPAGATION_SUPPORTS, readOnly = false)
    	public void storeUser(User user) {
    		appDao.store(user);
    	}

    	@Transaction(propagation = PROPAGATION_SUPPORTS)
    	public User findUserById(long id) {
    		return appDao.findById(User.class, Long.valueOf(id));
    	}
    }
~~~~~

## Recapitulation

We learned here how to configure JTX and how to declaratively set
transaction using annotations.

