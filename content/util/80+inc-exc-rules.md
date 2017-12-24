# Include-Exclude Rules

Several *Jodd* tools and frameworks use set of include and exclude rules to
_filter_ some resources. For example, you can filter files with `FindFile`
or filter properties for `JsonSerializer`. For all this, *Jodd* uses
the very same include-exclude rule engine. The very same logic is applied
everywhere. And the best part is that you can re-use it for your own need.

This small rule engine is implemented in `InExRules` class. This rule engine
may work in one of the two following modes:

+ _blacklist_ mode (default) - any input is included, and you specify
 what to exclude;
+ _whitelist_ mode - any input is excluded, and you specify
 what to include.

The order of execution of explicit include/exclude rules depends on the mode.

The rules 'opposite' to the rule engine mode are always executed first!
Corresponding rules of the same group (include or exclude) are executed
as they are defined.
{: .attn}

For example, if rule engine is in blacklist mode, engine first executes
exclude rules and then include rules. When executing one of these groups,
all corresponding rules are executed as defined. This way you can
filter out any combination you need.

I am sure you are totally puzzled with above definitions:) Let's
see rules in action, everything will be much clearer!

## Rules

When created, rules engine can be fill up with the various include/exclude
rules. For example, we can have something like this:

~~~~~ java
	InExRules inExRules = ... // we get the engine instance

	inExRules.include("shelf.book.*");
	inExRules.exclude("shelf.book.page.1");
~~~~~

What we set here are two rules: one for defining what will be included
and one for what is going to be excluded. In this example, rules are
simple strings, but this does not have to be the case, as we gonna see
later.

After setting the rule, our engine is set and we can start matching
input resources. In our trivial example, resources are again strings,
so we can write something like:

~~~~~ java
	inExRules.match("shelf.book.page.1");
	inExRules.match("shelf.book");
	inExRules.match("shelf.book.page.34");
~~~~~

But how input resources are matched to the rules?

## Matcher

Say hi to the `InExRuleMatcher`. This interface connects rules and input
values (i.e. resources) and defines how single rule is matched against
the input value. By default, *Jodd* provides two matchers:
`WILDCARD_RULE_MATCHER` and `WILDCARD_PATH_RULE_MATCHER`, that uses
our great [wildcard matcher](wildcard.html) to compare string inputs
against wildcard rules.

Rule engine from our example could be created like this:

~~~~~ java
	InExRules<String, String> inExRules =
			new InExRules<String, String>(
				InExRuleMatcher.WILDCARD_RULE_MATCHER);
~~~~~

To recap, such rule engine takes string inputs that are matched against
(wildcard) string rules. As you could expect, you can write a matcher for any
types of inputs and rules, complex as much as you need! For
example, you may have your own matching logic where you split
rule on dots and then perform matching of each chunk and so on.

## Order of execution

Now back to the order of execution. Above two rules are bit vague.
In one rule, we said we want to include all pages, and then we
are excluding one page. Which rule is applied first?

Look again what we said on the very beginning. The order of execution
depends on current mode. So here is the logic behinds the rule engine
in this case:

+ By default, engine is created in _blacklist_ mode
+ Therefore, everything is _included_.
+ First check the _opposite_ rules, the _excluded_ group.
+ We have just one _excludes_ rule (`shelf.book.page.1`).

If we stop now, then the rule engine would be set to include all book pages
except the page 1. But we have more rules:

+ After checking the _opposite_ group, go with the _included_ group.
+ We have one _includes_ rule (`shelf.book.*`).

We just overwrite the exclude rule! Meaning, we didn't excluded anything!

## Changing the mode

Obviously, this is not what we wanted. We have to change the initial
mode of the rule engine. If we write this:

~~~~~ java
	inExRules.whitelist();
	inExRules.include("shelf.book.*");
	inExRules.exclude("shelf.book.page.1");
~~~~~

then the rule engine logic goes like this

+ Engine is started in _whitelist_ mode
+ Therefore, everything is _excluded_.
+ First check the _opposite_ rules, the _included_ group.
+ We have one _includes_ rule (`shelf.book.*`).
+ After checking the _opposite_ group, go with the _excluded_ group.
+ We have just one _excludes_ rule (`shelf.book.page.1`).

This time, rules are set like we wanted: the whole book is included
except the page 1.

## In Jodd

This logic is used everywhere in the *Jodd* where some inputs are filtered.

Be aware of the starting rule-engine mode!
{: .attn}

It is very important to be aware how tools are using the engine. Very often
tools uses blacklist mode as default, but if you specify _only_ the includes
rules, it will switch to the whitelist mode.

Again - be aware of how the engine mode.