# Miscellaneous

Various *Madvoc* topics.

## Upload

Uploaded files are injected as input parameters:

~~~~~ java
    @MadvocAction
    public class UploadAction {

    	@In
    	FileUpload file;

    	@Action
    	public void execute() {
    	}
    }
~~~~~

Upload strategy for handling uploaded files is defined by used
implementation of `FileUploadFactory`, as defined in global *Madvoc*
configuration.

## Nice URLs

*Madvoc* component `ActionPathRewriter` offers URL rewrite
functionality. By overriding method `rewrite()` it is possible to change
the \'nice\' action path (i.e. nice url) to real one and to add
additional attributes. By default, there is no special parsing and/or
mapping mechanism behind `ActionPathRewriter` component: resolving of
nice url can be implemented in any desired way: using regular
expressions, *Jodd* wildcard utility, simply `StringTokenizer`...

For example, path like: `/doc/2007/04/27` can be rewritten as:
`/doc.html?year=2007&month=04&day=27`. `ActionPathRewriter` is aware of
http requests so it is easily to add additional attributes to the
request, since they will be injected in the same way as parameters.

## Auto HTTP method definition

If not specified differently by `@Action` annotation, HTTP method name
(POST, GET, DELETE...) is ignored. This means that forms, for example,
may be submitted also by invoking GET request.

With *Madvoc* it is easy to prevent such cases and still to avoid manual
setting of method name in every action. All what has to be done is to
override `ActionMethodParser#buildActionPath()`. This method is called
during action registration, once when all parts of action path are
readed (from annotation or using corresponding names). Custom version of
`ActionMethodParser` component may look like:

~~~~~ java
    public class MyActionMethodParser extends ActionMethodParser {

    	private static final String EXTENSION_DO = "do";
    	private static final String EXTENSION_HTML = "html";

    	@Override
    	protected String buildActionPath(
                String packageActionPath, String classActionPath,
                String methodActionPath, String extension, String method) {

    		if ((method == null) && (extension != null)) {
    			if (extension.equals(EXTENSION_DO)) {
    				method = METHOD_POST;
    			} else if (extension.equals(EXTENSION_HTML)) {
    				method = METHOD_GET;
    			}
    		}
    		return super.buildActionPath(
                packageActionPath, classActionPath,
                methodActionPath, extension, method);
    	}
    }
~~~~~

Once registered in `WebApplication`, this custom version of
`ActionMethodParser` component will set HTTP method name for all methods
that already doesn't explicitly specify it. So, if extension is \".do\"
than action will be registered as a handler for POST requests; if
extension is default \'.html\' than action is GET request handler.

## Madvoc internal information

*Madvoc* registers two actions for debugging purposes and inspection of
internal *Madvoc* state. These actions are mapped to:
`/madvoc-listAllActions.${ext}` and to `/madvoc-listAllActions.out`. All
what they do is to prepare a sorted list of available action
configurations (`ActionConfig`), results and interceptors. This
information then can be used on JSP page to show more info about all
registered actions, what is already initialized, what is registered and
so on.

Second action (`/madvoc-listAllActions.out`) does whatever the first do,
except it print outs all results to the system output.

## Configure Logger

Since LogBack logger can use system properties in its XML file, it is
possible to set some before `Madvoc` starts to log out. This can be done
in constructor of `WebApplication`, since logger is not yet initialized.

Alternatively, logger parameters may be set in command line.

## Validation

Although validation of user input is necessary part of every web
application, *Madvoc* doesn't offer a solution for it. The reason why
is that, in our opinion, validation is not part of just web layer, but
instead it is spread across service layer as well. Therefore, web
framework should not be tight so single validation framework.

Nevertheless, it is easy to integrate any existing validation solution
in *Madvoc*, such as [Oval][1].

[1]: http://oval.sourceforge.net/
