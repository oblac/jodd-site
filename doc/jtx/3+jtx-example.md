# JTX example

<div class="doc1"><js>doc1('jtx',20)</js></div>
To understand the concepts of *JTX* its best to see an example. To make
things simpler, our transactional resource will be a simple `String`
value. Let's create one such class:

~~~~~ java
    public class WorkSession {

    	static String persistedValue = "jodd";
    	String sessionValue;
    	boolean readOnly;
    	int txno;			// transaction number

    	public WorkSession() {	// start session in non-tx mode
    	}
    	public WorkSession(int txno) {	// start tx session
    		this.txno = txno;
    	}

    	public void writeValue(String value) {
    		if (txno == 0) {	// no transaction
    			persistedValue = value;
    			return;
    		}
    		// under transaction
    		if (readOnly == true) {
    			throw new UncheckedException();
    		}
    		sessionValue = value;
    	}

    	public String readValue() {
    		if (sessionValue != null) {
    			return sessionValue;
    		}
    		return persistedValue;
    	}

    	// commit
    	public void done() {
    		if (sessionValue != null) {
    			persistedValue = sessionValue;
    		}
    		sessionValue = null;
    	}

    	// rollback
    	public void back() {
    		sessionValue = null;
    	}
~~~~~

Now we are ready to begin our journey:)

## ResourceManager

The first thing is to create a `JtxResourceManager` for our resource.
The main method to implement is `beginTransaction()`. It starts a
transaction on our resource depending on transaction mode.

Since we will use `JtxTransactionManager`, propagation behavior and
timeout will be already supported! Therefore, our resource manager has
only to deal with isolation and read-only attribute. We will ignore
isolation to make things simpler. Here is how resource manager may look
like:

~~~~~ java
    public class WorkResourceManager implements JtxResourceManager<WorkSession> {

    	int txno = 1;

    	public Class<WorkSession> getResourceType() {
    		return WorkSession.class;
    	}

    	public WorkSession beginTransaction(JtxTransactionMode jtxMode, boolean active) {
    		if (active == false) {
    			return new WorkSession();
    		}
    		WorkSession work = new WorkSession(txno++);
    		work.readOnly = jtxMode.isReadOnly();
    		return work;
    	}

    	public void commitTransaction(WorkSession resource) {
    		resource.done();
    		txno--;
    	}

    	public void rollbackTransaction(WorkSession resource) {
    		resource.back();
    		txno--;
    	}

    	public void close() {
    	}
    }
~~~~~

Quick overview of what we have done in `beginTransaction()`\: the
`active` flag tells us if real transaction should be started or we are
working in auto-commit mode. When it is set, we create a
transaction-aware resource. Since isolation is ignored, we only need to
pass read-only flag.

## Usage

Now we are ready to use *JTX*\:

~~~~~ java
	// [1] create jtx manager and register our resource manager
	JtxTransactionManager jtxManager = new JtxTransactionManager();
	jtxManager.registerResourceManager(new WorkResourceManager());

	// [2] request jtx
	JtxTransaction jtx = manager.requestTransaction(
			new JtxTransactionMode().propagationRequired().readOnly(true));

	// [3] requrest resource i.e. start jtx
	WorkSession work = jtx.requestResource(WorkSession.class);

	// [4] work
	work.writeValue("new value");

	// [5] done
	jtx.commit();

	// [6] cleanup
	manager.close();
~~~~~

The most important thing to remember is that in step #2 we are just
**requesting** a jtx transaction. Not until the next step, #3, the real
transaction will be started. Again, we are **requesting** a resource,
therefore, if we call it several time in a row, the same resource
instance will be returned.

## Worker

*JTX* also provides `LeanJtxWorker`, a class that utilizes
`JtxTransactionManager` and makes it more convenient for use when
transaction is requested over different context, i.e. with transaction
nesting. Basically, everything stays the same, except `LeanJtxWorker`
would return `null` when new transaction is not created on its request,
meaning that current transaction matches the requested transaction
attributes (mostly propagation).
