# Download Jodd

*Jodd* may be used on any platform where there is a suitable **Java 8**
runtime environment. *Jodd* may be used successfully on many platforms,
including Linux, UNIX, Windows, MacOSX.

*Jodd* is **FREE** software released under the terms of the [BSD
license](/license.html).

## Maven repositories

*Jodd* jars are published on **Maven central** repository.

### Maven

~~~xml
	<dependency>
		<groupId>org.jodd</groupId>
		<artifactId>jodd-xxx</artifactId>
		<version><%=@config[:jodd][:version]%></version>
	</dependency>
~~~

### Gradle

~~~
compile 'org.jodd:jodd-xxx:<%=@config[:jodd][:version]%>'
~~~

### SBT

~~~
libraryDependencies += "org.jodd" % "jodd-xxx" % "<%=@config[:jodd][:version]%>"
~~~

### Ivy

~~~xml
	<dependency org="org.jodd" name="jodd-xxx" rev="<%=@config[:jodd][:version]%>"/>
~~~

## Java 9

Well. Sorry.


## BOM (Bill Of Material)

*Jodd* BOM is provided as `org.jodd:jodd-bom`.

Enjoy!
