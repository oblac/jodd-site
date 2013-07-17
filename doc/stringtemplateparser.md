# StringTemplateParser

`StringTemplateParser` is parser for string templates, where macros are
defined with JSP-alike markers. During parsing, macros are replaced by
their values. Values are resolved by custom `MacroResolver`.

Usage is quite simple:

~~~~~ java
    // prepare template
    String template = "Hello ${foo}. Today is ${dayName}.";
    ...
    
    // prepare data
    Map<String, String> map = new HashMap<String, String>();
    map.put("foo", "Jodd");
    map.put("dayName", "Sunday");
    ...
    
    // parse
    StringTemplateParser stp = new StringTemplateParser();
    String result = stp.parse(template, new MacroResolver() {
    	public String resolve(String macroName) {
    		return map.get(macroName);
    	}
    });
    // result == "Hello Jodd. Today is Sunday."
~~~~~

`StringTemplateParser` is very configurable. User can set the escape
character, or starting and ending strings (by default: `\${` and `}`).
There is an option if missing keys should be resolved, and the
replacement value for missing keys. Good practice is to create and
configure one `StringTemplateparser` instance that will be used in your
code.

`StringTemplateParser` by default detects inner macros in passed string.
However, you can turn on parsing values as well.

