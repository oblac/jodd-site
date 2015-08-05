# Download Jodd

*Jodd* may be used on any platform where there is a suitable **Java 7+**
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

## Jodd Bundle

*Jodd* Bundle is one jar with most modules bundled together.
Distribution archive contains bundle jar (with sources jar)
and jars of remaining modules.

<div class="button"><a href="jodd-<%=@config[:jodd][:version]%>.zip">
	jodd-<%=@config[:jodd][:version]%>.zip
	<div class="sub">(2.5 MB)</div>
</a></div>

### Mobile version

Single jar that contains selected utilities and tools from modules
<var>jodd-core</var>, <var>jodd-bean</var> and <var>jodd-props</var>;
small in size.

[jodd-mobile-<%=@config[:jodd][:version]%>.jar](jodd-mobile-<%=@config[:jodd][:version]%>.jar) (350 KB)

## Maven repositories

*Jodd* jars are published on **jCenter** and **Maven central** repository.
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
'org.jodd:jodd-xxx:<%=@config[:jodd][:version]%>'
~~~~~

### SBT

~~~~~
libraryDependencies += "org.jodd" % "jodd-xxx" % "<%=@config[:jodd][:version]%>"
~~~~~

### Ivy

~~~~~ xml
	<dependency org="org.jodd" name="jodd-xxx" rev="<%=@config[:jodd][:version]%>"/>
~~~~~
