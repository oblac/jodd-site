# Download Jodd

*Jodd* may be used on any platform where there is a suitable **Java 8**
runtime environment. *Jodd* may be used successfully on many platforms,
including Linux, UNIX, Windows, MacOSX.

*Jodd* is **FREE** software released under the terms of the [BSD
license](/license.html).

## Maven repositories <i class="fa fa-arrow-circle-o-down"></i>

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
compile: 'org.jodd:jodd-xxx:<%=@config[:jodd][:version]%>'
~~~

### SBT

~~~
libraryDependencies += "org.jodd" % "jodd-xxx" % "<%=@config[:jodd][:version]%>"
~~~

### Ivy

~~~xml
	<dependency org="org.jodd" name="jodd-xxx" rev="<%=@config[:jodd][:version]%>"/>
~~~

## Java 9 <i class="fa fa-coffee"></i>

*Jodd* can run on **Java 9**, too. However, you have to use the `jre9` version of `jodd-core` component. It is published as the same artifact, but with the _classifier_.

If you use other *Jodd* components, you will need to exclude default dependency on `jodd-core` and use the `jre9` version. Here is how this can be done in _Gradle_:

~~~groovy
    compile ('org.jodd:jodd-core:4.1.3:jre9') {
        force = true
    }
    compile ('org.jodd:jodd-joy:4.1.3') {
        exclude group: 'org.jodd', module:'jodd-core'
    }
~~~

With above code we force the usage of `jre9` classifier and exclude default transitive dependency on `jodd-core`.

## BOM (Bill Of Material)

*Jodd* BOM is provided as `org.jodd:jodd-bom`.

## All-in-One Bundle <i class="fa fa-paper-plane-o"></i>

We also provide *Jodd* bundle: `jodd-all`. It is available on Maven central
repository as well (`org.jodd:jodd-all`). You can download it from here:

<div class="button"><a href="https://repo1.maven.org/maven2/org/jodd/jodd-all/<%=@config[:jodd][:version]%>/jodd-all-<%=@config[:jodd][:version]%>.jar">
	jodd-all-<%=@config[:jodd][:version]%>.jar
	<div class="sub">(<%=@config[:jodd][:size]%> MB)</div>
</a></div>

You can also download
[source](https://repo1.maven.org/maven2/org/jodd/jodd-all/<%=@config[:jodd][:version]%>/jodd-all-<%=@config[:jodd][:version]%>-sources.jar)
and [javadoc](https://repo1.maven.org/maven2/org/jodd/jodd-all/<%=@config[:jodd][:version]%>/jodd-all-<%=@config[:jodd][:version]%>-javadoc.jar)
bundles.

Enjoy!