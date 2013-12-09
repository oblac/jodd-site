<js>javadoc('jtx')</js>

# JTX ![JTX](jtx.png)

<div class="doc1"><js>doc1('jtx',20)</js></div>
*Jodd* provides great, little, stand-alone transaction manager, *JTX*.
It is a significant change in traditional thinking, since no (j2ee)
application server is required; *JTX* may be used in any Java code.

*JTX* is built to be roughly similar to **JTA** up to certain point; but
without complexity. It's goal is to works well with every-day
web/desktop applications; not to manage heavy-weight requirements such
as transactions across multiple domains, etc.

In a nutshell *JTX* provides a transaction model that supports
transaction demarcation over any number of resources - of any kind. Of
course, the emphasis is put on database transactions; there is a layer
built on top of *JTX* to integrate it well with *Db* and *Proxetta*
frameworks. *JTX* may be used programmatically through simple API or
declaratively using annotations.

## JTX in action

A picture is worth a thousand words, a good code example even more;)
Here is one real-life example how *JTX* is used declaratively.

~~~~~ java
    ...
	@Transaction
	public String view() {
		// read data db
		return result;
	}

	@ReadWriteTransaction
	public void store(int id) {
		// save data to db
	}

	@Transaction(propagation = PROPAGATION_REQUIRED, readOnly = false, timeout = 100)
	public void update(int id) {
		// save data to db
	}
    ...
~~~~~

Cool, isn't it:) This example already shows several *JTX* features,
like using custom annotations, but its definitely not the only way how
*JTX* can be used.

Following *JTX* pages explains the concept behind the framework and its
usage.