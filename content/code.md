# Jodds Source Code

*Jodd* is hosted on **GitHub**:

<div class="button button-long"><a href="https://github.com/oblac/jodd">https://github.com/oblac/jodd</a></div>

The Jodd's source code is released under the [BSD license](/license.html).

## Get the Code

You can get the code by clonning *Jodd* Git repository:

	git clone https://github.com/oblac/jodd.git jodd

## Build Instructions

*Jodd* is built with [Gradle](http://gradle.org) targeting **Java 1.8**.
You don't have to install anything, the only prerequisites are
[Git](http://help.github.com/set-up-git-redirect) and Java JDK.

After cloning *Jodd* repo, you can build the project with:

	gradlew build

This will build all jars and run all unit tests. To skip the tests (for faster build), execute:

	gradlew build -x test

To generate full release, including running integration tests and generating various reports:

	gradlew release

And that's all!

### Running Integration Tests

Integration tests are executed only when building `release` task or `testAll` task.

For integration tests you will need also to set up databases named: '`jodd-test`' on local **MySql** (access: _root_/_root!_) and **PostgreSQL** (_postgres_/_root!_).
The easiest way to run the test infrastructure is by using Docker.

## Using Java IDE

Since *Jodd* is a Gradle project, you can easily open it by selecting main `build.gradle` in
every modern Java IDE (**IntelliJ IDEA**, **Eclipse**, **Netbeans**).

### IntellJ IDEA

IntelliJ IDEA can open *Jodd* project very nicely. Just follow the simple steps:

**1) Install Gradle**

You must first install the Gradle: simply download the distribution archive
and unpack it somewhere. Then enable IntelliJ IDEA **Gradle plugin** and set
the path to the Gradle installation.

**2) Open project**

![open project](gfx/source-1-open-project.png)

**3) Wait until Gradle project is build**

![build source](gfx/source-2-building.png)

**4) Import Gradle project**

![import project](gfx/source-3-import-project.png)

*Jodd* uses **JDK8**. Thats all!


### Eclipse

Eclipse users also should change the "_Deprecated and restricted API_" setting, to log "_Forbidden references_" as **Warnings** (and not Errors). We have some test cases that uses restricted API - don't worry, it's _only_ used in the tests!

This Eclipse option is located here: Windows > Preferences > Java > Compiler > Errors/Warnings or (Project) Properties > Java Compiler > Error/Warnings.


## Contribute!

Feel free to contribute! We accept patches, diffs and pure sources :)

The best way to contribute would be via **GitHub**, using the following workflow:

+ fork *Jodd* repo (<code>upstream</code>) to your **GitHub** account (`origin`)
+ clone `origin` to `local` repo
+ make branch for your work, commit often
+ push `local` branch to `origin`
+ when the work is done, send us pull request (PR)

Welcome!