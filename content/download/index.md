# Download Jodd

*Jodd* may be used on any platform where there is a suitable **Java 8+**
runtime environment. *Jodd* may be used successfully on many platforms,
including Linux, UNIX, Windows, MacOSX.

*Jodd* is **FREE** software released under the terms of the [BSD
license](/license.html).

* [Release notes](/release.html)
* [Release history](/history.html) - warning, long page!
* [What's coming next](/beta.html) (betas, snapshots...) - the list might
not be complete

Please find some information in how *Jodd* is organized
into the [modules](../doc/modules.html).

## Maven repositories

*Jodd* jars are published on **Maven central** and **jCenter** repository.
Snapshots are released on **jCenter** only.

### Maven

~~~~~ xml
	<dependency>
		<groupId>org.jodd</groupId>
		<artifactId>jodd-xxx</artifactId>
		<version><%=@config[:jodd][:version]%></version>
	</dependency>
~~~~~

### Gradle

~~~~~
compile: 'org.jodd:jodd-xxx:<%=@config[:jodd][:version]%>'
~~~~~

### SBT

~~~~~
libraryDependencies += "org.jodd" % "jodd-xxx" % "<%=@config[:jodd][:version]%>"
~~~~~

### Ivy

~~~~~ xml
	<dependency org="org.jodd" name="jodd-xxx" rev="<%=@config[:jodd][:version]%>"/>
~~~~~


## All-in-One Bundle

We also provide *Jodd* bundle: `jodd-all`. It is available on Maven central
repository. But you can also download it from here with just one click:

<div class="button"><a href="https://repo1.maven.org/maven2/org/jodd/jodd-all/<%=@config[:jodd][:version]%>/jodd-all-<%=@config[:jodd][:version]%>.jar">
	jodd-all-<%=@config[:jodd][:version]%>.zip
	<div class="sub">(<%=@config[:jodd][:size]%> MB)</div>
</a></div>

You can also download
[source](https://repo1.maven.org/maven2/org/jodd/jodd-all/<%=@config[:jodd][:version]%>/jodd-all-<%=@config[:jodd][:version]%>-sources.jar)
and [javadoc](https://repo1.maven.org/maven2/org/jodd/jodd-all/<%=@config[:jodd][:version]%>/jodd-all-<%=@config[:jodd][:version]%>-javadoc.jar)
bundles.

Enjoy!