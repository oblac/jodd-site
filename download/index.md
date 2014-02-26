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

## Jodd Bundle

*Jodd* Bundle is one jar with most modules bundled together.
Distribution archive contains bundle jar (with sources jar) and jars of remaining modules.

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

Jodd jars are published on Maven central repository.

<div class="button button-long">
	<a href="http://repo1.maven.org/maven2/org/jodd/" target="_blank">
		repo1.maven.org/maven2/org/jodd
	</a>
</div>

* groupId: **org.jodd**
* artifactId: **jodd-\<module_name\>**
* version: @@{VERSION}

## Beta (SNAPSHOT)
{: #beta}

Please note that beta version is not always available.

### Snapshot Repo

[oss.sonatype.org/content/repositories/snapshots/org/jodd][1]

{::comment}+BETA{:/comment}
### Bundle

[![download](/gfx/dl.gif) jodd-@@{BETA}.zip](jodd-@@{BETA}.zip)

{::comment}+BETA{:/comment}


## Module List and dependencies

Here is the list of all *Jodd* modules with their dependencies.
Blue are mandatory dependencies, gray optional and light are 3rd party.

<var>jodd-bean</var> <var class='dep'>jodd-core</var>

<var>jodd-core</var>

<var>jodd-db</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-jtx</var> <var class='dep-opt'>jodd-proxetta</var>

<var>jodd-http</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-upload</var>

<var>jodd-joy</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-petite</var> <var class='dep'>jodd-madvoc</var> <var class='dep'>jodd-vtor</var> <var class='dep'>jodd-jtx</var> <var class='dep'>jodd-db</var> <var class='dep'>jodd-proxetta</var> <var class='dep'>jodd-mail</var> <var class='dep'>jodd-log</var>

<var>jodd-jtx</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-proxetta</var>

<var>jodd-lagarto</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-log</var>

<var>jodd-lagarto-web</var> <var class='dep'>jodd-lagarto</var> <var class='dep'>jodd-servlet</var> <var class='dep'>jodd-log</var> <var class='lib'>javax.servlet-api</var>

<var>jodd-log</var>

<var>jodd-madvoc</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-props</var> <var class='dep'>jodd-upload</var> <var class='dep'>jodd-servlet</var> <var class='dep'>jodd-petite</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-proxetta</var> <var class='lib'>javax.servlet-api</var> <var class='lib'>jsp-api</var>

<var>jodd-mail</var> <var class='dep'>jodd-core</var> <var class='lib'>mail</var> <var class='lib'>activation</var>

<var>jodd-petite</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-props</var> <var class='dep'>jodd-log</var> <var class='dep-opt'>jodd-servlet</var> <var class='dep-opt'>jodd-proxetta</var>

<var>jodd-props</var> <var class='dep'>jodd-core</var>

<var>jodd-proxetta</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-log</var>

<var>jodd-servlet</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var> <var class='dep'>jodd-upload</var> <var class='lib'>javax.servlet-api</var> <var class='lib'>jsp-api</var>

<var>jodd-swingspy</var>

<var>jodd-upload</var> <var class='dep'>jodd-core</var>

<var>jodd-vtor</var> <var class='dep'>jodd-core</var> <var class='dep'>jodd-bean</var>

## Misc

Some various Jodd-related stuff.

* [**Jodd in 10 minutes**](/download/jodd-in-10-minutes.pdf) - presentation, covers version 3.2.7


[1]: https://oss.sonatype.org/content/repositories/snapshots/org/jodd/
