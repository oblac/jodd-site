# Jodd JSP tag library

*Jodd* comes with powerful JSP tag and big JSP functions library. Here
is the overview of most important tags.

To use *Jodd* JSP library, you need to define taglib directive at the
top of your JSP page (use any prefix you like):

~~~~~ html
    <%@ taglib prefix="j" uri="/jodd" %>
~~~~~

## Set & Unset

Sets or unsets variable value in some scope. Attributes are:

* `name` - variable name
* `value` - variable value
* `scope` - one of:
  * `page` (default)
  * `request`
  * `session`
  * `application`

Example:

~~~~~ html
      <j:set name="foo" value="173" scope="request"/>
~~~~~

Display `foo` value with: `${foo}`

~~~~~ html
      <j:unset name="foo" scope="request"/>
~~~~~

## Debug

Outputs parameter values and attribute values from all scopes. Useful
for quick debugging. Tip: wrap debug tag with the `pre` tag in HTML,
to have more readable output:

Example:

~~~~~ html
    <j:debug/>
~~~~~

## Url

This tag creates full URLs that are context independent and with
parameters encoded. `Url` tag uses dynamic attributes that represents
url parameters, so the base path is set by tag parameter \'`_`\'.
Additionally, it is possible to set page variable value, instead to
render url to the page. Example:

~~~~~ html
    <j:url _="index.html" foo="something" id="173" />
~~~~~

may render as: `/app/index.html?foo=something&id=173`. And:

~~~~~ html
    <j:url _="hello.html" _var="u" boo="3" />
~~~~~

Now `${u}` may render as: `/hello.html?boo=3`


## If

Renders the tag body if test condition is true. Example:

~~~~~ html

    <j:if test="${foo > 10}">
       greater then 10!
    </j:if>
~~~~~

## IfElse, Then & Else

Similar as `If` tag, except this one offers complete `then` and `else`
blocks, that will be rendered if condition is true or false,
respectively. Example:

~~~~~ html
    <j:ifelse test="${foo == 'hello'}">
    	<j:then>
          Hello to you, too!
       </j:then>
    	<j:else>
    		Please say hello:)
    	</j:else>
    </j:ifelse>
~~~~~

## Switch, Case & Default

Offers `switch`/`case`/`default` functionality. Example:

~~~~~ html

    <j:switch vale="${foo}">

    	<j:case value="One">
          You are the first!
       </j:case>

    	<j:case value="Two">
    		Second place for you!
    	</j:case>

    	<j:case value="Three">
    		And you are third,
    	</j:case>

    	<j:default>
    		Sorry, try again.
    	</j:default>
    </j:switch>
~~~~~

## For

Generic loop, like in Java, iterates tag body multiple times. Supports
looping in both directions. The attributes are:

* `start` - first value
* `end` - last value
* `step` - looping step, default 1
* `status` - optional name of status object
* `modulus` - modulus value of current iteration count, default 2. May
  be used to e.g. detect odd/even rows (modulus = 2), or detect every
  1st, 2nd and 3rd row (modulus = 3).

Like all *Jodd* looping tags, `For` tag has optional `status`
attribute that defines status variable name. If specified, status
object is available inside looping tag body and provide various
information about the current iteration:

* `start` and `end` - first and last value of the iteration;
* `step` - looping step, default 1;
* `count` - total count;
* `even`, `odd` - flags for even and odd iterations;
* `modulus` - the value of modulus;
* `index` and `value` - 0-based and 1-based item of current iteration;
* `first` and `last` - flag for first and/or last iteration;

Status object has custom `toString()` that gives complete status for
iteration, what is useful for development. It prints the following:

`value : count : 'F' for first : 'L' for last : modulus`

`For` tag supports steps during looping. Moreover, setting `step` to
`0` will notify `For` tag to choose the correct direction, based on
`start` and `end` values.

Example:

~~~~~ html
    <j:for start="1" end="5" status="s" modulus="3">
    	${s} |
    </j:for>
    1:1:F:_:1 | 2:2:_:_:2 | 3:3:_:_:0 | 4:4:_:_:1 | 5:5:_:L:2 |

    <j:for start="1" end="5" step="2" status="s">
    	${s} |
    </j:for>
    1:1:F:_:1 | 3:2:_:_:0 | 5:3:_:L:1 |

    <j:for start="3" end="1" step="-1" status="s">
    	${s} |
    </j:for>
    3:1:F:_:1 | 2:2:_:_:0 | 1:3:_:L:1 |

    <j:for start="1" end="3" step="0" status="s">
    	${s} |
    </j:for>
    1:1:F:_:1 | 2:2:_:_:0 | 3:3:_:L:1 |

    <j:for start="3" end="1" step="0" status="s">
    	${s} |
    </j:for>
    3:1:F:_:1 | 2:2:_:_:0 | 1:3:_:L:1 |
~~~~~

## Loop

`Loop` tag offers more enhanced looping then `For` tag. For example,
it contains both `end` and `to` variables to define loop end value,
inclusive and not-inclusive. Moreover, instead of setting the end
value (using `end` or `to`), it is possible to specify just the
`count`. Example:

~~~~~ html
    <j:loop start="1" end="5" status="s">
    	${s} |
    </j:loop>
    1:1:F:_:1 | 2:2:_:_:0 | 3:3:_:_:1 | 4:4:_:_:0 | 5:5:_:L:1 |

    <j:loop start="1" to="5" status="s">
    	${s} |
    </j:loop>
    1:1:F:_:1 | 2:2:_:_:0 | 3:3:_:_:1 | 4:4:_:L:0 |

    <j:loop start="1" to="-1" step="-1" status="s">
    	${s} |
    </j:loop>
    1:1:F:_:1 | 0:2:_:L:0 |

    <j:loop start="1" count="3" status="s">
    	${s} |
    </j:loop>
    1:1:F:_:1 | 2:2:_:_:0 | 3:3:_:L:1 |

    <j:loop start="1" end="5" autoDirection="true" step="3" status="s">
    	${s} |
    </j:loop>
    1:1:F:_:1 | 4:2:_:L:0 |

    <j:loop start="5" end="1" autoDirection="true" step="3" status="s">
    	${s} |
    </j:loop>
    5:1:F:_:1 | 2:2:_:L:0 |
~~~~~

## Iterator

`Iterator` iterates some collection or an array. `Iterator` also can
iterate a string that represents comma-separated array.

There are two optional attributes: `from` and `count` that determine
starting index and total number of items to iterate. Example:

~~~~~ html
    <j:iter items="1,2,3" var="i" status="s">
    	${i} ${s} |
    </j:iter>
    1 1:F:_:1 | 2 2:_:_:0 | 3 3:_:L:1 |

    <j:iter items="1,2,3" var="i" from="2" status="s">
    	${i} ${s} |
    </j:iter>
    3 1:F:L:1 |
~~~~~

## Form

`Form` tag populates HTML form automatically. Read more [here](formtag.html).
