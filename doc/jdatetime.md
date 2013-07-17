# JDateTime ![jdatetime](/gfx/jdatetime.png "JDateTime")

`JDateTime` is an elegant, developer-friendly and yet very precise way
to track dates and time. It uses well-defined and proven astronomical
algorithms for time manipulation. Everyone who has ever experienced
frustration working with JDK `Calendar` will find this class a big
relief.

## Julian day

The [Julian day](http://en.wikipedia.org/wiki/Julian_date) or Julian day number (JDN) is the
integer number of days that have elapsed since noon Greenwich Mean Time
Monday, January 1, 4713 BC. The Julian Date (JD) is the number of days
(with decimal fraction of the day) that have elapsed since the same
epoch. JDs are the recommended way how to specify time in astronomy.

The Julian day number can be considered a very simple calendar, where
its calendar date is just an integer, and time is its fraction. This is
useful for reference, computations, and conversions. The beauty of JD
lays in the fact that it is easy to calculate time ranges and to roll
dates, since just basic math operations addition and subtraction are
used. JD allows the time between any two dates in history to be computed
by simple subtraction.

The Julian day system was introduced by astronomers to provide a single
system of dates that could be used when working with different calendars
and to unify different historical chronologies.

Apart from the choice of the zero point and name, this Julian day and
Julian date are not directly related to the Julian calendar, although it
is possible to convert any date from one calendar to the other.
{: .attn}

## Precision

`JDateTime` uses JD internally to track current date and time. It uses
proven and well tested astronomical algorithms to do all calculations.
`JDateTime` offers precision up to **1 millisecond** in all
calculations.

## Date and time setting

`JDateTime` can be created in various ways: by specifying desired date
and/or time, or by passing a reference of some other date/time related
JDK class, by specifying number of system milliseconds, and so on.

`JDateTime` can be created using specific date/time data. Once created,
date and time may be changed in various ways. It is possible to change
the complete date/time information (equally to creating new
`JDateInstance`) or just to change it partially (just days, or
minutes...).

Using constructor:

~~~~~ java
    JDateTime jdt = new JDateTime();            // current date and time
    jdt = new JDateTime(2012, 12, 21):          // 21st December 2012, midnight
    jdt = new JDateTime(System.currentTimeMillis());    // current date and time
    jdt = new JDateTime(2012, 12, 21, 11, 54, 22, 124); // 21st Dec. 2012,11:54:22.124
    jdt = new JDateTime("2012-12-21 11:54:22.124");     // -//-
    jdt = new JDateTime("12/21/2012", "MM/DD/YYYY");    // 21st Dec. 2012, midnight
~~~~~

Using method:

~~~~~ java
    JDateTime jdt = new JDateTime();         // current date and time
    jdt.set(2012, 12, 21, 11, 54, 22, 124);  // 21st December 2012, 11:54:22.124
    jdt.set(2012, 12, 21);                   // 21st December 2012, midnight
    jdt.setDate(2012, 12, 21);               // change just date to 21st Dec. 2012
    jdt.setCurrentTime();                    // set current date and time
    jdt.setYear(1973);                       // change the year
    jdt.setHour(22);                         // change the hour
    jdt.setTime(18, 00 12, 853);             // change just time
~~~~~

## Reading date and time

Obviously, it is possible to read date/time information from
`JDateTime`. There are getter methods for reading each part: years,
months, hours and so on. Days and months are 1-base integers, therefore,
`JDateTime.JANUARY` is 1.

Besides methods for reading single part of date/time information, there
are some more convenient methods that return date time information.

`getDateTimeStamp()` returns `DateTimeStamp` instance used internally by
`JDateTime`. This class just holds all date/time information in one
place.

`getJulianDate()` returns `JulianDateStamp` instance used internally by
`JDateTime`. `JulianDateStamp` holds information about current JD. Due
to accuracy problem of floating points, JD information is stored in two
separate fields: `integer` and `fraction` (JD = integer + fraction). It
is possible to get the JD as double value, but this is not accurate
(regarding the time), due to fact that integer is very big which leads
that fraction looses precision.

## Time traveling

`JDateTime` provides methods for adding or subtracting specific amount
of time from current date/time. It is possible to change just single
part of date/information or to change more at once.

~~~~~ java
    jdt.add(1, 2, 3, 4, 5, 6, 7);  // add 1 year, 2 months, 3 days, 4 hours...
    jdt.add(4, 2, 0);              // add 4 years and 2 months
    jdt.addMonth(-120);            // go back 120 months
    jdt.subYear(1);                // go back one year
    jdt.addHour(1234);             // add 1234 hours
~~~~~

It is better to replace sequential time adding/subtraction with single
method call, due to performance issues. For example, if some amount of
months, minutes and seconds has to be added to current time, it would be
faster to add them at once by invoking: `add(0, months, 0, 0, minutes,
seconds, 0);` instead of calling three add methods for month, minutes
and seconds respectively.
{: .example}

Adding months is dubious because of variable month length. There are two
ways how months may be considered during adding, what will be shown in
following example: what is one month from `2003-01-31`?

`JDateTime` has a `monthFix` flag that defines the month adding
behavior. When this flag is off, months are approximated to 31 days. So
the result is: `2003-01-31 + 0-1-0 = 2003-03-03`.

When `monthFix` is on (default), month length is ignored. In
that case, adding one month will always give the very next month:
`2003-01-31 + 0-1-0 = 2003-02-28`.

Since adding months is dubious because of variable month length it is a
good practice to add days instead.

## Periods

With `JDateTime` its easy to calculate period duration in days: just by
subtracting two julian numbers. However, to calculate period duration
including hours, minutes, seconds, and milliseconds; its somewhat easier
and faster to use class `Period`.

## Conversion

`JDateTime` may be easily converted to/from any other time-related
classes: `GregorianCalendar`, `java.util.Date`, `java.sql.Date`,
`Timestamp`, `DateTimeStamp`. Moreover, it is possible to set the
date/time of existing instance, instead of creating new one.

~~~~~ java
    Calendar c = jdt.convertToCalendar();
    jdt.convertToGregorianCalendar();
    jdt.convertTo(GregorianCalendar.class);  // generic way of conversion
    jdt = new JDateTime(gregCalInstance);    // create from GregorianCalendar
    jdt.loadFrom(gregCalInstance);           // loads time data from GregorianCalendar
    jdt.storeTo(gregCalInstance);            // store time data to GregorianCalendar
~~~~~

Moreover, it is easy to add custom converters for any class needed.

## String conversion

Special attention is put into date/time conversion to and parsing from
strings. There are two general ways how to perform conversion:
internally, by `JDateTime` instance, or externally, by passing
`JDateTime` instance to some formatting class.

For all internal conversion and parsing, `JDateTime` uses so-called
*formatters*, i.e. implementations of `JdtFormatter`. Formatters follow
simple contract (interface) with just two methods that defines how to
convert to a string and how to parse from a string using provided
format. Format is usually a string template that consist of some
patterns. Therefore, one formatter instance may be used in whole
application. `JDateTime` holds formatter and default format that are
used for conversion and parsing. Default format is used when no format
is provided in conversion/parsing methods.

If the application has to switch often between formatters, it is
possible to use `JdtFormat `for more convenient conversion and parsing -
that is a immutable class that holds formatter-format pair.

Finally, since `JDateTime` may be converted to `Date` easily, it is
possible to use JDKs `DateFormatter` for converting date/time
information to string.

`DefaultFormatter` is the default formatter used by `JDateTime`. It uses
enhanced patterns specified by [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601) specification,
both for conversion and parsing - except parsing recognize less
patterns.

| pattern  | parsing? | Value                        |
|:--------:|:--------:|:-----------------------------|
| YYYY     | yes      | year                         |
| MM       | yes      | month                        |
| DD       | yes      | day of month                 |
| D        |          | day of week                  |
| MML      |          | month name long              |
| MMS      |          | month name short             |
| DL       |          | day of week name long        |
| DS       |          | day of week name short       |
| hh       | yes      | hour                         |
| mm       | yes      | minute                       |
| ss       | yes      | seconds                      |
| mss      | yes      | milliseconds                 |
| DDD      |          | day of year                  |
| WW       |          | week of year                 |
| WWW      |          | week of year with 'W' prefix |
| W        |          | week of month                |
| E        |          | era (AD or BC)               |
| TZL      |          | time zone name long          |
| TZS      |          | time zone name short         |

Template strings for conversion may contains other text besides above
patterns, even complete sentence. It is possible to escape some part of
template to prevent conversion of some text. Escaping text is done by
single quote. Any double single-quote characters inside quoted region is
replaces with the single character. Moreover, if some parsing pattern is
not recognized it will be ignored.

Usage examples:

~~~~~ java
    JDateTime jdt = new JDateTime(1975, 1, 1);
    jdt.toString();                     // "1975-01-01 00:00:00.000"
    jdt.toString("YYYY.MM.DD");         // "1975.01.01"
    jdt.toString("MM: MML (MMS)");      // "01: January (Jan)"
    jdt.toString("DD is D: DL (DS)");   // "01 is 3: Wednesday (Wed)"
    JDateTime jdt = new JDateTime(1968, 9, 30);
    jdt.toString("'''' is a sign, W is a week number and 'W' is a letter");
    // "' is a sign, 5 is a week number and W is a letter"

    jdt.parse("2003-11-24 23:18:38.173");
    jdt.parse("2003-11-23");                // 2003-11-23 00:00:00.000
    jdt.parse("01.01.1975", "DD.MM.YYYY");  // 1975-01-01
    jdt.parse("2001-01-31", "YYYY-MM-***"); // 2001-01-01, since day is not parsed

    JDateTime jdt = new JDateTime();
    JdtFormatter fmt = new DefaultFormatter();
    fmt.convert(jdt, "YYYY-MM.DD");         // external conversion

    JdtFormat format = new JdtFormat(new DefaultFormatter(), "YYYY+DD+MM");
    jdt.toString(format);
    format.convert(jdt);

    DateFormat df = new SimpleDateFormat();
    df.format(jdt.convertToDate());         // date formatter
~~~~~

## Localization

By setting locale in `JDateTime`, it is possible to localize names in
resulting conversion string, such as month and date short and long
names. When no specific locale is set, `JDateTime` will use system
default locale.

## Week definition

`JDateTime` provides two ways how to define the week, i.e. to define the
first day of the week and the what is the first week of the year (for
week counting).

`setWeekDefinition(start, must)` defines what is the start day of the
week and what day of the week must be in a year in order to week belongs
to that year.

`setWeekDefinitionAlt(start, min) `is an alternative definition that
defines the start day of week and the minimum number of days that week
must have in order to belong to a year.

## JD Alternatives

Because the starting point is so long ago, numbers in the Julian day
(JD) can be quite large and cumbersome. A more recent starting point is
sometimes used, for instance by dropping the leading digits, in order to
fit into limited computer memory with an adequate amount of precision.

`JDateTime` is able to convert JD to and from:

* Reduced Julian Day (RJD),
* Modified Julian Day (MJD), and
* Truncated Julian Day (TJD), definition as introduced by NASA.

## TimeZones and DST

Julian Date, by definition, is not aware of timezones and daylight
saving times (DST). However, `JDateTime` supports timezones and when
timezone is changed (and there is a time zone difference) time will be
modified by specific offset. When `JDateTime` is created, the system
default timezone is used. By setting the new time zone, current time is
changed according to time zone difference. The following example shows
the current time in Japan:

~~~~~ java
    JDateTime jdt = new JDateTime();
    jdt.setTimeZone(TimeZone.getTimeZone("Japan"));
    System.out.println(jdt);
~~~~~

Furthermore, it is possible just to set the timezone, without changing
the time.

DST is supported only partially, for now. By default, DST tracking is
off (flag: `trackDST`). When DST tracking is on, JDateTime will track
DST only during adding/subtracting the time. What remains is that it is
still possible to set invalid time (that, for example, doesn't exist).

## Performance

According to some light micro-tests, JDateTime is about 40% faster then
JDK5 Calendar.

![jdatetime performace test](jdate-benchmark.png)
