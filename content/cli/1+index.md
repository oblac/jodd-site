# CLI

*CLI* is simple command line arguments parser. It is designed to be super-lightweight; there are no fancy definitions, configuration or annotations, just pure Java code.

Using **CLI** is super simple:

~~~~ java
	Cli cli = new Cli();
	cli.accept(argv);
~~~~

This parser does nothing, as it has yet be configured.

Command line argument can be either _option_ or _parameter_. Options are prefixed with `-` and/or `--`, parameters are not prefixed. They are configured in similar, but slightly different way. Here is how.

## Options

A single option can be defined with _short_ and/or a _long_ name. Short name is prefixed with `-` and one character long. Long name is prefixed with `--` and usually contains human-readable words. An option
can have either or both names defined. All options are optional.

~~~~ bash
	cmd -a --helloWorld
~~~~

This command is defined in *CLI* like this:

~~~~ java
	Cli cli = new Cli();

	cli.option()
		.shortName("a")
		.with(this::add);

	cli.option()
		.longName("helloWorld")
		.with(this::helloWorld);

	cli.accept(argv);
~~~~

Now arguments are parsed.

## Handlers

When an option is detected while parsing, it's handler is called. Handler is a simple `Consumer` of the input argument (more about that later). In above example, each option has been assigned to a different handler. Option handlers consume `String` values. The content depends on the option. In this example, there is no content as the options are simple flags - they do not carry any value.

## Options with arguments

Option may have an argument. For example:

~~~ bash
	cmd --downloadFile myfile.txt --encoding=UTF8
~~~

In Java:

~~~~ java
	Cli cli = new Cli();

	cli.option()
		.longName("downloadFile")
		.hasArg()
		.with(this::downloadFile);

	cli.option()
		.longName("encoding")
		.hasArg("Encoding value")
		.with(this::setEncoding);

	cli.accept(argv);
~~~~

Handler will receive the argument; in the first case that is `myfile.txt` and in second is `UTF8`.

## Parameters

Parameters are defined similarly:

~~~~ java
	Cli cli = new Cli();

	cli.param()
		.label("HELLO")
		.required()
		.with(this::sayHello);

	cli.accept(argv);
~~~~

The major difference between parameter and option is the _cardinality_: parameter can take 1 or more passed arguments. Any number of them may be required, the rest is optional. In above example we specified parameter with just one argument, that is also required. Because of cardinality, parameters handler accepts array of strings.

### Cardinality

The number of required and optional parameters are controlled with `optional()` and `required()` methods.

~~~~ java
	Cli cli = new Cli();

	cli.param()
		.required(2)
		.optional(1)
		.with(this::sayHello);

	cli.accept(argv);
~~~~

This parameter takes 2 required arguments and one optional. For example:

~~~~ bash
	cmd one two        # array with 2 elements
	cmd one two three  # array with 3 elements
	cmd one            # exception
~~~~

## Double dash

Everything after the double dash (`--`) is consider as a parameter and not an option.

~~~~ bash
	cmd -a -- -b
~~~~

This command has one option (`a`) and one parameter (`-b`).