# Jodd as JBoss AS 7 module

*Jodd* jars may be registered as [JBoss AS 7](http://jbossas.jboss.org/)
modules. While you can register each *Jodd* jar as different module,
the best practice is to set _all_ of them as one JBoss module.
Here is how.

## Steps for making *Jodd* module.

Here are the steps to create *Jodd* module in JBoss AS7.
Value of `${JBOSS_HOME}` represents the home folder
where JBoss AS is installed.

### 1. Create module folder for *Jodd*

\\
Go to `${JBOSS_HOME}/modules` folder. Create folders: `/jodd/main`.

### 2. Copy *Jodd* jars to created folder

\\
Copy *Jodd* jars to created folder: `${JBOSS_HOME}/modules/jodd/main`.
You can copy all *Jodd* jars, or just those you are using.

### 3. Add `module.xml`

\\
Create `module.xml` in the same folder with content similar to:

~~~~~ xml
	<?xml version="1.0" encoding="UTF-8"?>

	<module xmlns="urn:jboss:module:1.1" name="jodd">

	    <resources>
	        <resource-root path="jodd-core-3.6-RC2-SNAPSHOT"/>
	        <resource-root path="jodd-bean-3.6-RC2-SNAPSHOT.jar"/>
	        ...
	    </resources>

	    <dependencies>
	      <module name="javax.mail.api" />
	      <module name="javax.servlet.api" />
	      <module name="javax.servlet.jsp.api" />
	    </dependencies>

	</module>
~~~~~

List *Jodd* jars as `resources`. List *Jodd* dependencies under the
`dependencies`. We have listed here dependencies for the email and servlets.

Done.