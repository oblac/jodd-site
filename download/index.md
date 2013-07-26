<style type="text/css">
table#maven td {
	font-size: 14px;
	border-left: 1px solid #ccc;
	padding: 5px;
}
span.mvn {
	font-weight: bold;
	font-size: 18px;
}
.dmenu a {
	background-color: #A3CEA7;
	color: #444;
	border:0;
}
</style>

# Download Jodd

*Jodd* may be used on any platform where there is a suitable **Java 5+**
runtime environment. *Jodd* may be used successfully on many platforms,
including Linux, UNIX, Windows, MacOSX.

*Jodd* is **FREE** software released under the terms of the [BSD
license](/license.html).

## Download options

<div>
	<div class="download dmenu" style="width:250px; float:left; margin-right:0;">
	<a href="#jodd-bundle" style="background-image: url(/gfx/jodd-jar.png); background-repeat:no-repeat; background-position: 4px 4px; padding-top: 20px;">BUNDLE</a>
	</div>

	<div class="download dmenu" style="width:250px; float:left; margin-right:0; margin-left:10px;">
	<a href="#maven" style="background-image: url(/gfx/jodd-maven.png); background-repeat:no-repeat; background-position: 4px 4px; padding-top: 20px;">MAVEN</a>
	</div>

	<div class="download dmenu" style="width:250px; float:left; margin-right:0; margin-left:10px;">
	<a href="#beta" style="background-image: url(/gfx/jodd-beta.png); background-repeat:no-repeat; background-position: 4px 6px; padding-top: 20px;">SNAPSHOT</a>
	</div>
</div>

<div style="clear:both;"></div>

![release notes](/gfx/history.png){: style="position:relative; top:3px;"
width="16" height="16"} [Release notes](/release.html)
![history](/gfx/history.png){: style="margin-left:20px;
position:relative; top:3px;" width="16" height="16"} [Release
history](/history.html) ![history](/gfx/history.png){:
style="margin-left:20px; position:relative; top:3px;" width="16"
height="16"} [What\'s comming](/beta.html)
{: style="padding-left:60px; margin-top:10px; text-align:center;"}

## Jodd Bundle

*Jodd* Bundle is one jar with most modules bundled together.
Distribution archive contains bundle jar and jars of remaining modules.

<div class="download"><a href="jodd-@@{VERSION}.zip"><span>jodd-@@{VERSION}.zip</span> (1.5 MB)</a></div>

### Mobile version

Single jar that contains selected utilities and tools from modules
<var>jodd-core</var>, <var>jodd-bean</var> and <var>jodd-props</var>;
small in size.

[![download](/gfx/dl.gif) jodd-mobile-@@{VERSION}.jar](jodd-mobile-@@{VERSION}.jar){: .dl} (303 KB)

## Maven

<div class="download"><a href="http://repo1.maven.org/maven2/org/jodd/" target="_blank">repo1.maven.org/maven2/org/jodd</a></div>

| groupId | <span class="mvn">org.jodd</span> |
| artifactId | <span class="mvn">jodd-\*</span> |
| version | <span class="mvn">@@{VERSION}</span> |
{: border="1" style="margin-left:340px;"}


## Module List and dependencies

<var>jodd-bean</var> <var class="dep">jodd-core</var>

<var>jodd-core</var>

<var>jodd-db</var> <var class="dep">jodd-core</var> <var
class="dep">jodd-bean</var> <var class="dep-opt">jodd-jtx</var> <var
class="dep-opt">jodd-proxetta</var><var class="lib">slf4j-api</var>

<var>jodd-http</var> <var class="dep">jodd-core</var> <var
class="dep">jodd-upload</var>

<var>jodd-joy</var> <var class="dep">jodd-core</var> <var
class="dep-opt">jodd-madvoc</var> <var class="dep-opt">jodd-vtor</var>
<var class="dep-opt">jodd-jtx</var> <var class="dep-opt">jodd-db</var>
<var class="dep-opt">jodd-proxetta</var> <var
class="dep-opt">jodd-mail</var> <var class="lib">slf4j-api</var>

<var>jodd-jtx</var> <var class="dep">jodd-core</var> <var
class="dep-opt">jodd-proxetta</var> <var class="lib">slf4j-api</var>

<var>jodd-lagarto</var> <var class="dep">jodd-core</var> <var
class="lib">slf4j-api</var>

<var>jodd-lagarto-web</var> <var class="dep">jodd-lagarto</var> <var
class="dep">jodd-servlet</var> <var class="lib">slf4j-api</var> <var
class="lib">servlet-api</var>

<var>jodd-madvoc</var> <var class="dep">jodd-core</var> <var
class="dep">jodd-bean</var> <var class="dep">jodd-props</var> <var
class="dep">jodd-upload</var> <var class="dep">jodd-servlet</var> <var
class="dep">jodd-petite</var> <var class="lib">servlet-api</var> <var
class="lib">slf4j-api</var>

<var>jodd-mail</var> <var class="dep">jodd-core</var> <var
class="lib">mail</var> <var class="lib">activation</var>

<var>jodd-petite</var> <var class="dep">jodd-core</var> <var
class="dep">jodd-bean</var> <var class="dep">jodd-props</var> <var
class="dep-opt">jodd-servlet</var> <var
class="dep-opt">jodd-proxetta</var> <var class="lib">slf4j-api</var>

<var>jodd-props</var> <var class="dep">jodd-core</var>

<var>jodd-proxetta</var> <var class="dep">jodd-core</var> <var
class="lib">slf4j-api</var>

<var>jodd-servlet</var> <var class="dep">jodd-core</var> <var
class="dep">jodd-bean</var> <var class="dep">jodd-upload</var> <var
class="lib">servlet-api</var> <var class="lib">jsp-api</var>

<var>jodd-upload</var> <var class="dep">jodd-core</var>

<var>jodd-vtor</var> <var class="dep">jodd-core</var> <var
class="dep">jodd-bean</var>


{::comment}beta{:/comment}

## Beta version (SNAPSHOT)

See [what's coming](/beta.html) in this beta.

### Snapshot Repo

[![download](/gfx/dl.gif) oss.sonatype.org/content/repositories/snapshots/org/jodd][1]{: .dl}

### Bundle

[![download](/gfx/dl.gif) jodd-@@{BETA}.zip](jodd-@@{BETA}.zip){: .dl}

{::comment}beta{:/comment}



## Misc

[**Jodd in 10 minutes**](/download/jodd-in-10-minutes.pdf) (*Presentation, covers version 3.2.7*)


[1]: https://oss.sonatype.org/content/repositories/snapshots/org/jodd/
