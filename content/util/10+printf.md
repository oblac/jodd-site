# Printf

Remember C and sprintf? It was a long time ago:) That was very useful
function, so here is Java version (enhanced a bit). It is easy to use
and fast. Formatting is specified in a string, as in C. And yes, Java
from version 5 has its own implementation, but *Jodd* version may be
still interesting.

`Printf` formats a number in a printf format, like C. The format string
has a prefix, a format code and a suffix. The prefix and suffix become
part of the formatted output. The format code directs the formatting of
the (single) parameter to be formatted. The code has the following
structure:

* a **%** (required)
* a modifier (optional)
  * **+** forces display of + for positive numbers
  * **~** do not count leading + or - in length
  * **0** show leading zeroes
  * **-** align left in the field
  * **space** prepends a space in front of positive numbers
  * **#** use \"alternate\" format. Add 0 or 0x for octal or hexadecimal
    numbers. Don't suppress trailing zeros in general floating point
    format.
  * **,** groups decimal values by thousands (for \'diuxXb\' formats)
* an integer denoting field width (optional)
* a period (**.**) followed by an integer denoting precision (optional)
* a format descriptor (required)
  * **f** floating point number in fixed format,
  * **e, E** floating point number in exponential notation (scientific
    format). The E format results in an uppercase E for the exponent
    (1.14130E+003), the e format in a lowercase e,
  * **g, G** floating point number in general format (fixed format for
    small numbers, exponential format for large numbers). Trailing
    zeroes are suppressed. The G format results in an uppercase E for
    the exponent (if any), the g format in a lowercase e,.
  * **d, i** signed long and integer in decimal,
  * **u** unsigned long or integer in decimal,
  * **x** unsigned long or integer in hexadecimal,
  * **o** unsigned long or integer in octal,
  * **b** unsigned long or integer in binary,
  * **s** string (actually, `toString()` value of an object),
  * **c** character,
  * **l, L** boolean in lower or upper case (for booleans and int/longs),
  * **p** identity hash code of an object (pointer ;).

Examples:

~~~~~ java
    Printf.str("%+i", 173);     // +173
    Printf.str("%04d", 1);      // 0001
    Printf.str("%f", 1.7);      // 1.700000
    Printf.str("%1.1f", 1.7);   // 1.7
    Printf.str("%.4e", 100.1e10);   // 1.0010e+012
    Printf.str("%G", 1.1e13);   // 1.1E+013
    Printf.str("%l", true);     // true
    Printf.str("%L", 123);      // TRUE
    Printf.str("%b", 13);       // 1101
    Printf.str("%,b", -13);     // 11111111 11111111 11111111 11110011
    Printf.str("%#X", 173);     // 0XAD
    Printf.str("%,x", -1);      // ffff ffff
    Printf.str("%s %s", new String[]{"one", "two"});    // one two
~~~~~


Note that float-point values are not precise, so the printed value may
differ from argument.
{: .attn}