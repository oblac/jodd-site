# Wildcard

Matching strings to wildcards pattern is useful and often needed. Using
regular expression may help, but is not top performance solution.
`Wildcard` class matches strings to wildcard patterns using `*` and `?`
characters, and that does very fast and good!

## Mathing strings

Here are some examples:

~~~~~ java
    Wildcard.match("CfgOptions.class", "*C*g*cl*");     	// true   
    Wildcard.match("CfgOptions.class", "*g*c**s");      	// true!   
    Wildcard.match("CfgOptions.class", "??gOpti*c?ass");    // true   
    Wildcard.match("CfgOpti*class", "*gOpti\\*class");  	// true   
    Wildcard.match("CfgOptions.class", "C*ti*c?a?*");   	// true
~~~~~

## Matching file paths

`Wildcard` class supports path matching wildcards. It matches path
against pattern using `*`, `?` and `**` wildcards. Both path and the
pattern are tokenized on path separators (`\` and `/`). \'`**`\'
represents deep tree wildcard, as in Ant.

~~~~~ java
    Wildcard.matchPath("/foo/soo/doo/boo", "/**/bo*");          // true
    Wildcard.matchPath("/foo/one/two/three/boo", "**/t?o/**");  // true
~~~~~

## Wildcards in Jodd

Wildcard matching is used on many places in *Jodd*. As the general
rule-of-the-thumb, everywhere where file paths are involved in scanning
and matching, the `matchPath()` method is used, otherwise, the classic
`path()`.

