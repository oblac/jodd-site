# Jodd.org Website

This is source for [Jodd](http://jodd.org) web site built with [nanoc](http://nanoc.ws).

All submissions are welcome. To submit a change, fork this repo,
commit your changes, and send us a
[pull request](http://help.github.com/send-pull-requests/).

## Build the site

You have **two** options. The first is to build and use it locally, so you
should be prepared to do some environment configuration. The second option is
to build it using Docker, so you don't have to install anything.

### Local

Ruby 2.x is required to build the site.

Get the `nanoc` gem, plus [kramdown](http://kramdown.gettalong.org/)
for [Markdown](http://daringfireball.net/projects/markdown/) parsing:

```sh
$ bundle install
```

You can see the available commands with nanoc:

```sh
$ bundle exec nanoc -h
```

Nanoc has [some nice documentation](http://nanoc.ws/docs/tutorial/) to get you
started. Though if you're mainly concerned with editing or adding content, you
won't need to know much about nanoc.

Nanoc compiles the site into static files living in `./output`.  It's
smart enough not to try to compile unchanged files:

```sh
$ bundle exec nanoc compile
```

You can setup whatever you want to view the files. You can run the local server
to see the site:

```sh
$ bundle exec nanoc view
$ open http://localhost:3000
```

Compilation times got you down? Use guard (recommended) in separate terminal:

```sh
$ bundle exec guard
```
...or autocompile:

```sh
$ bundle exec nanoc autocompile
```

This starts a web server too, so there's no need to run `nanoc view`.

### Docker

Use `docker-run.sh` to run the build using the Docker. First you need to build
an image:

```sh
$ docker-run.sh build
```

After the image is created, compilation is simple:

```sh
$ docker-run.sh compile
```

or if you want, you can run the guard instead:

```sh
$ docker-run.sh guard
```

You can run the web server, too:

```sh
$ docker-run.sh server
```

Enjoy!