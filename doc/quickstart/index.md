# Quickstart Jodd

*Jodd* Quickstart projects are pre-configured *Jodd* bundles that are
small and ready to be run fast. In most cases, a quickstart project is
just an empty web application containing some of the *Jodd* frameworks
confugred and prepared for the use and further exploration.

Please keep in mind that Quickstart projects are just simple examples
built for users to get quickly into the *Jodd*, so many (advanced)
features are not presented. For real-life application, please check
[uphea](/uphea/index.html).
{: .attn}

Following quickstart projects are available:

### Madvoc

This is a quick start web application built using **Madvoc** web
framework. **Madvoc** is MVC framework that uses CoC and annotations
in a pragmatic way to simplify web application development. It is easy
to use, learning curve is small and it is easy to extend. There are no
external (xml) configuration, actions are simple POJOs, it is compatible
with any view technology, its pluggable and so on...

### WebApp 1

More advanced example of web application built with many Jodd
frameworks. MySql database required for this example (SQL script
provided). Application reads users from database (using **DbOom**) and
displays them on the page (using **Madvoc**), decorated by**Decora**.
Services and actions are wired with **Petite**. This example also uses
benefits of *Jodd Joy*!

Here is how to try quickstart projects.

## 1. Get the source

Clone **jodd-quickstart** project:

[https://github.com/oblac/jodd-quickstart](https://github.com/oblac/jodd-quickstart)
{: .download}

## 2. Create project in your IDE

Create a new project in your IDE and import existing sources to match
the following structure (the real content may vary):

![quickstart](quickstart-project.png){: .b}
{: style="text-align:center"}

Each quickstart example is put in its own module. Libraries are shared,
just for the sake of simplicity.

## 3. Steady, ready... Code!

And you are ready to experience *Jodd*:)

### Add service

Services are located in **service** package. Each service class is
*Petite* bean; just a POJO class annotated with `@PetiteBean`. Then read
more about [*Petite*](../petite/index.html).

### Add web action

Web actions are located in **actions** package, as *Madvoc* actions. To
inject a *Petite* bean service in the action, just annotate the field in
*Madvoc* action. Then learn something about
[*Madvoc*](../madvoc/index.html).

### Add JSP page

Add JSP pages to render outjected *Madvoc* values.

### Configure

Configure *Jodd* frameworks through **props** files. Or write
configuration in Java, in `AppMadvocConfig` and `AppCore`.

### Continue exploring...

Quickstart projects are just simple examples. Attach *Jodd* sources and
keep exploring.
