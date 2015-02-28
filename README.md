# Jodd WebSite

This is [Jodd](http://jodd.org) web site built with [nanoc](http://nanoc.ws).

All submissions are welcome. To submit a change, fork this repo,
commit your changes, and send us a
[pull request](http://help.github.com/send-pull-requests/).

## Setup

Ruby 1.9 is required to build the site.

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

## Development

Nanoc compiles the site into static files living in `./output`.  It's
smart enough not to try to compile unchanged files:

```sh
$ bundle exec nanoc compile
```
You can setup whatever you want to view the files. If using the adsf
gem (as listed in the `Gemfile`), you can start Webrick:

```sh
$ bundle exec nanoc view
$ open http://localhost:3000
```

Compilation times got you down? Use guard (recommended) in
separate terminal:

```sh
$ bundle exec guard
```
...or autocompile:

```sh
$ bundle exec nanoc autocompile
```

This starts a web server too, so there's no need to run `nanoc view`.

### Search

We have custom javascript search engine and you need to execute:

```sh
$ bundle exec nanoc sd
```

to generate JSON search data file.