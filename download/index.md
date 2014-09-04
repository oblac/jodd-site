# Download Jodd

*Jodd* may be used on any platform where there is a suitable **Java 5+**
runtime environment. *Jodd* may be used successfully on many platforms,
including Linux, UNIX, Windows, MacOSX.

*Jodd* is **FREE** software released under the terms of the [BSD
license](/license.html).

* [Release notes](/release.html)
* [Release history](/history.html)
* [What's comming next](/beta.html) (betas, snapshots...) - the list might
not be complete

Please find some information in how *Jodd* is organized
into the [modules](../doc/module.html).

## Jodd Bundle

*Jodd* Bundle is one jar with most modules bundled together.
Distribution archive contains bundle jar (with sources jar)
and jars of remaining modules.

<div class="button"><a href="jodd-@@{VERSION}.zip">
	jodd-@@{VERSION}.zip
	<div class="sub">(2.5 MB)</div>
</a></div>

### Mobile version

Single jar that contains selected utilities and tools from modules
<var>jodd-core</var>, <var>jodd-bean</var> and <var>jodd-props</var>;
small in size.

[jodd-mobile-@@{VERSION}.jar](jodd-mobile-@@{VERSION}.jar) (350 KB)

## Maven

*Jodd* jars are published on Maven central repository.

<div class="button button-long">
	<a href="http://repo1.maven.org/maven2/org/jodd/" target="_blank">
		repo1.maven.org/maven2/org/jodd
	</a>
</div>

* groupId: **org.jodd**
* artifactId: **jodd-\<module_name\>**
* version: @@{VERSION}

*Jodd* provides "bill of materials"
([BOM](http://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)).

## Beta (SNAPSHOT)
{: #beta}

Please note that beta version is not always available.

### Snapshot Repo

[oss.sonatype.org/content/repositories/snapshots/org/jodd][1]

{::comment}+BETA{:/comment}
### Bundle

jodd-@@{BETA}.zip](jodd-@@{BETA}.zip)

{::comment}+BETA{:/comment}

## Misc

Some various *Jodd*-related stuff.

+ [**Jodd in 10 minutes**](/download/jodd-in-10-minutes.pdf) - presentation, covers version 3.2.7


[1]: https://oss.sonatype.org/content/repositories/snapshots/org/jodd/
