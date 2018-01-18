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
the 'nice' action path (i.e. nice url) to real one and to add
additional attributes. By default, there is no special parsing and/or
mapping mechanism behind `ActionPathRewriter` component: resolving of
nice url can be implemented in any desired way: using regular
expressions, *Jodd* wildcard utility, simply `StringTokenizer`...

For example, path like: `/doc/2007/04/27` can be rewritten as:
`/doc.html?year=2007&month=04&day=27`. `ActionPathRewriter` is aware of
http requests so it is easily to add additional attributes to the
request, since they will be injected in the same way as parameters.

## Auto HTTP method definition

If not specified differently by the annotation, HTTP method name
(POST, GET, DELETE...) is ignored. This means that forms, for example,
may be submitted also by invoking GET request.

With *Madvoc* it is easy to prevent such cases and still to avoid manual
setting of method name in every action. All what has to be done is to
override `ActionMethodParser#buildActionPath()`. This method is called
during action registration, once when all parts of action path are
read (from annotation or using corresponding names). Custom version of
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
that already doesn't explicitly specify it. So, if extension is `.do`
than action will be registered as a handler for POST requests; if
extension is default `.html` than action is GET request handler.
