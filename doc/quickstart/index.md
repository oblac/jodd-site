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

Here is how to try quickstart projects.

## 1. Get the source

Clone **jodd-quickstart** project:

<div class="button button-long"><a href="https://github.com/oblac/jodd-quickstart">https://github.com/oblac/jodd-quickstart</a>
</div>

## 2. Follow instructions in README

All *Jodd* QuickStart projects are **gradle** project. You can easily build them.
Each QuickStart project is also configured to be easily run from command line.

Please follow step-by-step instructions on the GitHub for each project.

Please note that some projects require database access, so you will need
MySql and to change configuration parameters prior starting.


## 3. Steady, ready... Code!

Simply open QuickStart project in your IDE. As a gradle project, everything
will be set up for you, so you can start exploring it right away.

You are now ready to experience *Jodd*:)

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
