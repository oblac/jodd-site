# VTor

*VTor* is a pragmatic validation framework for any kind of Java objects.
*VTor* is fast, small and focused on validation. Constraints can be
declared with annotations or used manually. Constraints may be grouped
in profiles. *VTor* is extensible - users can easily use custom
constraints. By default constraints are written in Java, but it is easy
to extend it and use XML or any scripting language to define validation
expressions.

## Validation in action

*VTor* validation process consist of:

* definition of validation checks (i.e. applied constraints);
* executing these rules on target object (usually, a java bean);
* examining validation results.

An example:

~~~~~ java
    ValidationContext vctx = new ValidationContext();
    vctx.add(new Check("boo", new MinLengthConstraint(2)));
~~~~~

Above code snippet defines single check in *VTOR* validation context.
The check defines the minimal length of `boo` property.

Now, lets validate some bean:

~~~~~ java
    Vtor vtor = new Vtor();
    vtor.validate(vctx, fooBeanInstance);
~~~~~

Validation has been performed. The only thing left is to check
validation results.

~~~~~ java
    List<Violation> vlist = vtor.getViolations();
~~~~~

This list is `null` when validation is successful, otherwise it contains
list of violations - validation checks that failed. Easy, right?

## Default constraints

*VTor* comes with many common general-purpose constraints. For example:

* `MaxConstraint`, `MaxConstraint`, `RangeConstraint` - defines min and
  max numeric value.
* `LengthConstraint`, `HasSubstringConstraint`, `LengthConstraint`,
  `WildcardMatchConstraint`... - for checking string values.
* `EqualToFieldConstraint` - checks if two fields are equal.
* ...

For complete list of constraints check *VTor* javadoc.

## VTor annotations

*VTor* usage can be simplified using annotations, when validation is
done in couple of lines. Above example is rewritten using annotations:

~~~~~ java
    public class Foo {

    	@MinLength(2)
    	String boo;		// getters/setters are optional
    }
~~~~~

Validation is now done with few lines:

~~~~~ java
	Vtor vtor = new Vtor();
	vtor.validate(fooInstance);
	System.out.println(vtor.hasViolations());
~~~~~

Now, this is easy:)

## Profiles

Problem when using annotations is that one bean can't be validated
using different set of checks, i.e. rules sets. For example, an user
model object is validated differently when user is created and updated:
in the first case we need to check if the username is unique. This is
where *VTor* profiles comes in.

Profile is the name of checks group that constraint belongs to. *VTor*
annotation may specify which profile groups its check belongs to.

~~~~~ java
	@MinLength(value = 2, profiles = {"p1,p2"})
	String boo;
~~~~~

To instruct *VTor* to use certain profiles:

~~~~~ java
	Vtor vtor = new Vtor();
	vtor.useProfiles("p1", "p2");
	vtor.validate(fooInstance);
~~~~~

There are special profile names:

* `*` (wildcard joker) - used in annotation means that some constraint
  belongs to all profiles. So instead of writing all profiles names, it
  is possible to use this wildcard instead.
* `default` - used to validate checks from default group, i.e. defined
  by annotations that do not have profile name explicitly defined.

### Excluding profiles

Sometimes it is required to exclude a check (defined by annotation
constraint) from one or more profiles. Instead to write down all
profiles names except the excluded one, it is possible to exclude a
profile using minus sign as a prefix (e.g. `-p2`).

Excluded profile names have higher priority!
{: .attn}

So, even if some check may belongs to a several profile, if there is a
excluded profile, the check will not be executed!

### Must-have profiles

Check is executed if there is at least one matched profile. Sometimes we
want to execute a check only if all profiles are requested. To achieve
this, just put `+` (plus) sign in front of the profile name.

### Severity

Severity is a simple checks-weight value; all checks with severity less
then specified will not run.

### Profiles summary

~~~~~ java
    // match profiles 'p1' OR 'p2'
    @FooCheck(profiles = {"p1", "p2"})

    // match profiles 'default' OR 'p2'
    @FooCheck(profiles = {"default", "p2"})

    // match 'p1' OR 'p3' ONLY IF 'p2' does NOT match
    @FooCheck(profiles = {"p1", "-p2", "p3"})

    // match profiles 'p1' AND 'p2'
    @FooCheck(profiles = {"+p1", "+p2"})
~~~~~~

## Misc

### Adding custom violations

*VTor* allows user to add custom violations, not only those that comes
from constraints. For example:

~~~~~ java
    vtor.addViolation(new Violation("number", foo, null));
~~~~~

This way even the validation itself can be performed outside of *VTor*
and pass results to the framework.

### Use constraints directly

Most *VTor* constraints may be executed directly, using static method
`validate()` of the constraint class. For example:

~~~~~ java
    boolean valid = MinLengthConstraint.validate("value", 3);
~~~~~

Yeah!