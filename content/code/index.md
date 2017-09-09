# Jodds Source Code

*Jodd* is hosted on **GitHub**:

<div class="button button-long"><a href="https://github.com/oblac/jodd">https://github.com/oblac/jodd</a></div>

The Jodd's source code is released under the [BSD license](/license.html).

## Get the Code

Clone the *Jodd* GitHub repository:

	git clone https://github.com/oblac/jodd.git jodd

## Build the Jodd

*Jodd* is built with [Gradle](http://gradle.org) targeting **Java 1.8**.
You don't have to install anything, the only prerequisites are
[Git](http://help.github.com/set-up-git-redirect) and Java JDK.

After cloning *Jodd* repo, build the project with:

	./gradlew build

This will build all the jars and run all the unit tests. To skip the tests (for faster build), use:

	./gradlew build -x test

And that's all!

## Test the Jodd

Building the *Jodd* will run all the unit tests.

However, to run the integration tests we need some docker containers to be up:

	docker-compose -f docker/docker-compose-test.yml up -d


After that run all the tests with:

	./gradlew build testAll


## Contribute!

Feel free to contribute! We accept patches, diffs and pure sources :)

The best way to contribute would be via **GitHub**, using the following workflow:

+ fork *Jodd* repo (<code>upstream</code>) to your **GitHub** account (`origin`)
+ clone `origin` to `local` repo
+ make branch for your work, commit often
+ push `local` branch to `origin`
+ when the work is done, send us pull request (PR)

Welcome!