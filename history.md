-----
release:on
-----
# History

Recent history, release notes and previous releases.

@@import(release)


## [2013-04-17] Release v3.4.3

After some time, we bring you one awesome release packed with many small, but powerful and exciting new features! Most important improvements are in *Petite* container and *HTTP* tool. Enjoy!

NEW
: *Petite* introduces `@PetiteProvier`!

CHANGED
: *Petite* manual registration is now more fluent!

CHANGED
: *Petite* init methods now can be invoked in 3 lifecycle points!

NEW
: *DbOom* now supports cache and a-to-many relationships!

CHANGED
: `ZipUtil` refactored to fluent and more convenient interface.

CHANGED
: `AnnotationDataReader` enhanced to support annotated annotations.

NEW
: *Madvoc* configurator is now one of its components (in internal container).

NEW
: *Lagarto* introduced new `Node` method `appendTextContent` for reducing the garbage while building nodes text content.

CHANGED
: Added better support for *Madvoc* action path macros.

NEW
: Added better support in *HTTP* for encodings and charsets.
{: .release}


## [2013-02-23] Release v3.4.2

In this sweet, little release, the biggest change is totally new HTTP client. Other then that, we have the usual amount of improvements and bug fixes; some classes have been cleaned. *Jodd* has finally moved to Gradle!

NEW
: ASM 4.1 source is now bundled with *Jodd*.

NEW
: `BeanCopy` tool added.

CHANGED
: *HTTP* client rewritten!
		See more...

CHANGED
: Removed `compiler` package as obsolete.

FIXED
: Issue with decoding paths with Chinese letters and `AutomagicPetiteConfigurator`.

NEW
: *Madvoc* `ActionInterceptorStack` is now configurable.

CHANGED
: Migrated from Maven to Gradle.

NEW
: Added `Period` class for `JDateTime`.

CHANGED
: *Madvoc* action path macros now uses wildcard match by default

NEW
: *Madvoc* now offers custom path macros.

FIXED
: Fixed issue with *Madvoc* action path macros for REST urls.

NEW
: Enhanced *DbOom*  column chunk.
{: .release}


## [2013-01-07] Release v3.4.1

Release 3.4.1. is polished version of our big previous release. Some things have been fixed, some upgraded and there are few new features!

NEW
: Added `filter` method to *Jerry*.

NEW
: More ways how to define hints in `$C` Template-SQL macro.

FIXED
: Fixed issue with Google App Engine and `ReflectUtil`.

CHANGED
: `DbSessionProvider` now requires `DbSession` to be created and controlled outside of the class.

CHANGED
: Migrated to ASM 4.1

CHANGED
: Attaching *Mail* attachments is different (better) now.

FIXED
: Embedded attachments now works with ThunderBird and GMail.

NEW
: More array type-conversions added.

NEW
: Added OSGI information in all jars.

NEW
: *Madvoc* `@Action` annotation now has `result` property.

NEW
: *Jerry* is now iterrable (Groovy! :).

FIXED
: *CSSelly* now supports escaped characters.
{: .release}


## [2012-10-25] Release v3.4.0

Release 3.4.0. is very special in many ways. Not only that some new and exciting features have been added (as always:), but the whole project has been re-organized! We migrated to Maven multi-module structure, making everything easier for you. We have also moved to the GitHub, so fork the repo :)

CHANGED
: `JDateTime` now do the `equals` of timestamp up to millisecond.

NEW
: *Petite* supports Scoped Proxy for mixing scopes.

CHANGED
: Added better handling for return values in *Proxetta*.

FIXED
: `JDateTime `now can parse patterns w/o separators

NEW
: Added `StringUtil.decapitalize()` and `ReflectUtil.getCallerClass()` to remove dependency on `java.beans` and `sun` packages.

CHANGED
: *Lagarto* now treats invalid tags as text.

FIXED
: `ZipUtil.zip` now adds folder entries for non-empty folders, too.

CHANGED
: *Jodd* log wrapper removed.

NEW
: `PropsUtil.convert()` added.

CHANGED
: Some packages were moved!!!

CHANGED
: Resolving path from manifest files improved.

FIXED
: Fixed `includeFiles` issue `FindFile`.

FIXED
: Fixed NPE in `FindFile`.
{: .release}


## [2012-09-05] Release v3.3.8

Enjoy release 3.3.8!

NEW
: Added `LoggablePreparedStatementFactory`.

NEW
: Added wrapper-type of *Proxetta*.

CHANGED
: Removed JDK-dependent `LoggablePreparedStatement`.

NEW
: Triple-quoted multiline values for *Props* added.

FIXED
: Fixed *Props* values with profile chars; comments are not allowed in values any more.

NEW
: Implicit self-reference for *BeanUtil*.

CHANGED
: `JspResolved` simplified. Jsp functions cleaned.

CHANGED
: *Paramo* now offers signature for non-generic types, too.

CHANGED
: *Props* extract methods works with target map now.

CHANGED
: `FileUtil` methods for reading file content now detects BOM characters for Unicode encodings.

CHANGED
: `UnicodeInputStream` now may work in two modes: detect mode and read mode``.

CHANGED
: Added `FastSort` (with new sorting implementation) in favor of `FastMergeSort`.

NEW
: Added natural-order sorting `Comparator`.

NEW
: Added rules for implicit end tags in *Lagarto DOM*.

CHANGED
: *Lagarto DOM* now fixes unclosed tags more pragmatic. Major speed improvement.

FIXED
: Fixed slow processing of unclosed tags in *Lagarto DOM*. (#jodd-23)

FIXED
: *HtmlStapler* files were not deleted on `reset()`.

NEW
: `FindFile` enhanced: better walking, various sorting added.

CHANGED
: `FindFile` internal logic optimized. `FileScanner` removed.

CHANGED
: `ClassFinder` system jars property is now static.

NEW
: Caches now uses `ReentrantReadWriteLock` for synchronization.
{: .release}


## [2012-07-27] Release v3.3.7

Enjoy release 3.3.7!

NEW
: Added *DbOom* reference option to render just a column name.

CHANGED
: `DbDefaults` moved to `DbManager` bean.

NEW
: Added *DbOom* naming strategies for tables and columns.

CHANGED
: Path-style wildcard matching added where path is searched.

CHANGED
: Mime types uses now only most recent Apache configuration.

FIXED
: Fixed bug with entities update and Postgres databases.

NEW
: More properties for *Lagarto* added.

NEW
: `LagartoParserEngine` added.

FIXED
: *Lagarto* handles IE conditional comments in a better way.

NEW
: `LagartoDOMBuilder` allows usage of custom tag visitor.

NEW
: *Lagarto* allows usage of custom DOM builder.

FIXED
: Null upload issue fixed. (#jodd-22)

FIXED
: Email issue fixed with reply-to fields. (#jodd-20)

NEW
: *HtmlStapler* filter added. Read more... (#jodd-19).

CHANGED
: *HtmlStapler* servlet removed!

NEW
: `SwingSpy` is back to *Jodd*.

FIXED
: Fixed some exceptions in *Jerry* when used on empty sets.

CHANGED
: All bean loaders now uses the same abstract class.
{: .release}


## [2012-06-12] Release v3.3.4

Another maintenance release. Mostly bug fixes. Only few changes, but might be important ones.

NEW
: Added `RemoveSessionFromUrlFilter` added.

NEW
: `JDateTime.isInDayLightTime()` added.

NEW
: `MimeTypes` upgraded.

FIXED
: *HtmlStapler* servlet now returns content-type for bundles [#jodd-16].

FIXED
: Fixed FCQN names for logger wrapper.

NEW
: *Madvoc* interceptors now can be enabled/disabled in properties file.

FIXED
: Fixed issue in *Petite* with setting params for long bean names.

NEW
: Added injection of *Madvoc* params in injectors and results.

FIXED
: Fixed issue in *Decora* with empty buffers.

CHANGED
: *Madvoc* aliases are now defined by `< >`.

CHANGED
: *Madvoc* configuration for attributes simplified.
{: .release}


## [2012-05-07] Release v3.3.3

Killing the bugs, is what we do in this release. We would like to thank Bandino Jurumai for helping us with this release! And hey, it's only two days after Jodds birthday :)

CHANGED
: Improved `GzipFilter`.

NEW
: Added gziped *HtmlStapler* bundles [#jodd-15]

FIXED
: Fixed *Jerry* issue with different modes [#jodd-14]

FIXED
: Fixed *HtmlStapler* context issue [#jodd-13]

NEW
: Added `StringTemplateParser`.

FIXED
: Fixed an issue with empty properties in `PropertyUtil`

FIXED
: Fixed `FileNameUtil.getPathNoEndSeparator()` issue [#jodd-12]

FIXED
: Fixed *HtmlStapler* issue with relative paths to JS and CSS files [#jodd-11]

FIXED
: Fixed *HtmlStapler* CSS Problem [#jodd-10]

FIXED
: Fixed *Madvoc* and *Lagarto* issue under Jetty [#jodd-9]

NEW
: Added generic `ServletResponse` wrapper.
{: .release}


## [2012-02-21] Release v3.3.2

This release contains mainly bug fixes and minor enhancements. Still, upgrade as it is an important release.

CHANGED
: *Lagarto* is now more relaxed on invalid tags

NEW
: Added raw *Http* tools.

NEW
: Added `BeanUtil.populate()` methods

CHANGED
: Type converters and `Convert` refactored and improved!

NEW
: Refactor *BeanUtil* loaders and allow setting custom `TypeConverterManagerBean` [#jodd-8]

NEW
: Added `ConvertBean`.

NEW
: Added `BeanUtilBean`.

NEW
: Added `TypeConverterManagerBean`.

NEW
: *Jerry* can provide it's builder for optional configuration.

CHANGED
: `LagartoDOMBuilder` enhanced with many configuration properties. Read more...

FIXED
: fixed *Lagarto DOM* issue when end of document is reached and tags are not closed.

CHANGED
: SLF4J library upgraded to version 1.6.4.

NEW
: Added `MadvocContextListener` that also can run web app.

NEW
: Added class `FastBuffer` for buffering objects.

CHANGED
: `Fast*Buffer` classes moved to `jodd.util.buffer` package.

NEW
: Added `ZipUtil.gzip()` and `ZipUtil.zlib()` methods.

CHANGED
: `ZipUtil.addToZip()` replaces previous methods.

NEW
: Added `url` result for *Madvoc*.

NEW
: *Props* now can load environment variables.
{: .release}


## [2011-12-27] Release v3.3.1

Some important bugfixes and minor changes.

NEW
: Optimized `Fast*Buffer` added for all primitives.

CHANGED
: *Lagarto* `Text` DOM node now decodes HTML.

CHANGED
: *CSSelly* now parses pseudo fn expression on creation.

FIXED
: *CSSelly* accepts classes with uppercase chars

NEW
: *Jerry* enhanced with `is()` method and `:contains` selector [.

NEW
: Added `LoggablePreparedStatement6` for JDK6.

CHANGED
: Swing utils removed as not being maintained for months.
{: .release}


## [2011-12-17] Release v3.3

So many great enhancements and news... do not know where to start;) Too many to list here. Enjoy!

CHANGED
: `ClassLoaderUtil` now loads array classes, too.

NEW
: Hello *Jerry*! See more...

NEW
: Hello *CSSelly*! See more...

NEW
: New `TypeConverter` converters for time/date classes.

CHANGED
: *JDateTime* converters are removed in favor of `TypeConverter`.

NEW
: `Base32` encodings added.

NEW
: `FileLFUcache` added.

CHANGED
: *Paramo* now returns `MethodParameter` array instead of `String` array.

NEW
: Hello *HtmlStapler*! See more...

NEW
: Hello *Lagarto*! See more...

NEW
: Hello *Decora*! See more...

NEW
: *Petite* is now able to  inject bean sets. See more...

NEW
: `Madvoc` raw results are optimized and more convenient.

FIXED
: Fixed `BeanUtil` properties naming to match JavaBeans spec (special cases).

NEW
: `ProxettaAwarePetiteContainer` added.

CHANGED
: `FileUtil.readBytes` optimized.

NEW
: `FileUtil.readChars` added.

CHANGED
: `BeanTemplate` renamed to `BeanTemplateParser` and changed from static utility to a bean.

NEW
: `ConsoleLog` added.

NEW
: `NetUtil#downloadFile` added.
{: .release}


## [2011-08-29] Release v3.2.7

After unusually long time, we released another significant update! As *Jodd* is used in few live web projects there were some issues and we wanted to wait as much as possible to clean the most of them:) Moreover, we added some significant updates and bug fixes, so please update your projects. The most important change is the new name of the *DbOom* framework. Sorry for all inconveniences - and enjoy the release!

NEW
: `DbOom` now supports mapping non-table columns to beans.

FIXED
: Fixed text attachment bug with *Email*.

CHANGED
: *Email* attachments are now received as EmailAttachment list.

NEW
: `FindFile#iterator()` added.

FIXED
: *Email* sending byte areas and input stream fixed``.

NEW
: Added `ignoreInvalidUploadFiles` parameter for ignoring bad file uploads in *Madvoc*.

NEW
: `java.util.Date` type converter added.

FIXED
: `JDateTimeSqlType` fixed for null checking.

CHANGED
: `FileEx` removed as `FileUtil` is enough.

CHANGED
: Package and classes renamed: *DbOrm* to *DbOom*! Way better:)

CHANGED
: Template SQL macro `$T` now does NOT define default alias name when one is not specified.

FIXED
: *Email* sending to CC and BCC addresses fixed.

NEW
: `Log` package added, a wrapper over external logging utility

CHANGED
: `ClasspathScanner` now scans using `File`

NEW
: `ClasspathScanner` now examines jars linked in Manifest file

FIXED
: Fixed #jodd-4: `ConcurrentModificationException` in `LFUCache.prune()`

NEW
: `BeanTool.copy` now supports maps

NEW
: Added variants for JSP functions that do not require page context

FIXED
: Fixed dispatching to URL without context path

NEW
: `KeyValue` class added

NEW
: Added java compiler

NEW
: Added + profiles for *VTor*

FIXED
: Fixed `setRollback()` in autocommit mode, for *JTX*
{: .release}


## [2011-04-05] Release v3.2.6

Besides bug fixing and minor updates, this release brings major enhancement in *Petite* IOC container. We put a lot of heart into this release!
		

NEW
: *VTor* `EqualToDeclaredField` constraint added.

NEW
: *Petite*: added support for multiple default references when no explicit reference specified.

NEW
: *Petite*: bean names now can be full class names.

FIXED
: Fixed potential MPE issue in `MultipartRequest`.

NEW
: Some new `StringUtil` and `ServletUtil`.

FIXED
: *Paramo* bug fixed so some arrays of certain type were not resolved.

NEW
: Converters enhanced and become more user friendly by trimming strings.

CHANGED
: *Madvoc* move attribute name changed.

NEW
: *Madvoc*: `strictExtensionStripForResultPath` added

NEW
: `FileNameUtils` enhanced

FIXED
: Fixed #jodd-3: findfile classes are now OS independent

CHANGED
: *Madvoc* `Action.IGNORE` renamed to `Action.NONE`

NEW
: *Props* plugin for IntelliJ IDEA.

FIXED
: Fixed *Madvoc* expanding of default interceptors classes and stacks
{: .release}


## [2011-02-20] Release v3.2.5

This release is all about new *Madvoc* features! It was very bright and sunny day, perfect for releasing!;)

NEW
: Duplicate *Props* now can be appended.

NEW
: Custom annotations for *JTX*.

FIXED
: Fixed JTX issue with SUPPORTS propagation.

NEW
: *Madvoc* support for REST urls.

NEW
: *Madvoc* custom annotations.

NEW
: *Madvoc* default aliases.

CHANGED
: *Madvoc* `@Action` notInPath removed.

CHANGED
: *Madvoc* `@Action#IGNORE` added instead of NO_EXTENSION.

NEW
: `ArraysUtil.inser` added for single element.

NEW
: `SortedArrayList` added.

NEW
: `BinarySearch` wrapper added.

NEW
: `StringUtil.findCommonPrefix` added.
{: .release}


## [2011-01-10] Release v3.2

A new year and a new release, with some great new features!		

NEW
: *Props* - super Properties replacement tool added.

NEW
: `Convert` tool added for one-liner type conversion.

NEW
: `Wildcard#matchPath` - Ant alike path matching added.

NEW
: `Invocation Replacement Proxy` added to *Proxetta*.

FIXED
: Some minor bug are fixed.

CHANGED
: Some enhancements.
{: .release}


## [2010-10-03] Release v3.1.1

First autumn release brings some nice refinements making *Jodd* more beautiful. Some important bugs were fixed too. Enjoy!

NEW
: `StringBand` added.

FIXED
: Some minor and less frequent, but important type conversions bugs are fixed.

CHANGED
: Method moved: `BeanTool#parseTemplate` to `BeanTemplate#parse`.

CHANGED
: Method renamed, `StringUtil#toSafeString` from `#toNonNullString`.

NEW
: `StringUtil` methods for (un)escaping strings in Java manner added.

NEW
: `ServletUtil.isGetParameter` method added.

NEW
: `CollectionUtil` methods added for filling a set or a list from iterator.

NEW
: `Cache#iterator()` method added for all caches.

FIXED
: `SendMailSession` bug fixed (jodd-2).

FIXED
: `MapBeanLoader` bug fixed (jodd-1).

CHANGED
: `StreamUtil` now flushes outputs on close.

NEW
: `TextResult` added for *Madvoc*.

CHANGED
: `ZipUtil` works better now for creating zips.

NEW
: `BeanUtil` now handles boolean properties with both isXxx() and getXxx() methods.
{: .release}


## [2010-06-18] Release v3.1.0

Some new tools, utils and Maven support (finally:) Also, since *Jodd* is currently being used in couple of live projects, we decided it is a time for new major release.

NEW
: Maven support - finally, *Jodd* is (or will be soon) available via Sonatype.

NEW
: New download bundle available: distribution, sources and javadoc jars.

CHANGED
: `CoreConnectionPool` is now able to validate connections when appropriate.

NEW
: `ClipboardUtil` added.

NEW
: More `StringUtil` utilities added.

NEW
: `BeanTool#copyProperties()` added.
{: .release}


## [2010-05-10] Release v3.0.9

Mainly bugfixes. Few days after *Jodd*s 3.x first birthday... a new release! Can't imagine a better present;) Moreover, *Jodd* has been used in couple of projects meanwhile, and it is fast, stable and good-looking:) And soon, we will give YOU a present for our birthday... just stay tuned;) 

NEW
: `replyTo` property added for `Email`.

CHANGED
: `CONTEXT` scope is now only for *Madvoc*, new `SERVLET` scope added and injectors changed.

NEW
: New `jfn:prepareCsrfToken().`

NEW
: `CsrfShield#maxTokensPerSession` added.

CHANGED
: Generated DB table and column names may now be uppercase or lowercase.

NEW
: iterator tag enhanced with `count` attribute

FIXED
: `CharacterSqlType`: bug fixed with string to char conversion

NEW
: JDateTime `isAfter()`, `isBefore()` added

NEW
: `StringUtil#insert()` added
{: .release}


## [2010-03-12] Release v3.0.8

This is one of the most important releases, since all *Jodd* frameworks have been used in production together.
As a result, we have several bug fixed, some important changes and more power inside the framework.
Voila! Starting from this release, we will post some photos and stories related to the release;) So... today, we have a lot of snow, although it is March. Cold, white Friday is perfect for releasing a new version, with hot cup of green tea.
        

CHANGED
: `HtmlEncoder` now uses `<br/>` instead of `<br>`.

FIXED
: `CsvUtil` CRLF bug fixed.

NEW
: `NullAware` sql types added. Primitives support added.

CHANGED
: `ReflectUtil.castType()` now handles enums better - allows to have typeconverter for enums too!

NEW
: `ArrayUtils` toString() and contains() added.

CHANGED
: `ListAllMadvocActions` does not register actions anymore.

NEW
: `ReflectUtil#readAnnotationValue()` added.

NEW
: `jfn:printf` added.

NEW
: Added limited methods for lists set in `DbOrmQuery`.

FIXED
: delete bug fixed - no table aliases allowed

FIXED
: Little bug fixed for findRelated() in *DbOom* fwk.

CHANGED
: SMTP email support enhanced.

NEW
: POP email support added.

CHANGED
: `SimpleSmtpAuthenticator` renamed to `SimpleAutheniticator`.

NEW
: `IdRequestInjectorInterceptor` added - an efficient joint of Prepare and IdRequestInjector.

NEW
: `DbQuery.setObjects(String[] names, Object[] values)` added.

FIXED
: `AnnotationTxAdvice` now works for overloaded methods too.

NEW
: JSP function `fmtDate` added.

NEW
: Database schema name added as DB settings.

FIXED
: *Proxetta* had some minor bugs with class loading.

NEW
: Database schema name added as DB settings.

CHANGED
: `SqlType` receives native sql type information when reading and saving data.

FIXED
: `ColumnValue` sql chunk added in response to fix db mapping bug with values.

NEW
: `Methref` - strongly typed method names references - added.
{: .release}


## [2009-11-19] Release v3.0.7

Since previous version was released before scheduled time, this one contains many small and some important news. First, there is a new tool 'Paramo' for reading methods parameter names from debug bytecode info. Next, Madvoc has been enhanced in an good way;) All-in-all, we are going towards the next big release.

NEW
: *Paramo* added - little tool to read methods parameters names using debug bytecode info.

NEW
: *Madvoc* recognizes super action classes.

NEW
: *Madvoc* may optionally decode GET parameters.

CHANGED
: `ClassDescriptor` now is public and can examine supported or accessible methods/fields.

CHANGED
: *Petite* `InitMethodResolver` now checks all supported init methods.

CHANGED
: `FileUpload` has been enhanced with max file size property. Internal stream processing has been refactored.

FIXED
: Caches `prune()` implementations now returns correct number of deleted items.

FIXED
: `PrettyStringBuilder` visualization bug fixed (and enhanced).

FIXED
: `DbQuery#setObjects()` index bug fixed.

CHANGED
: Method `ActionResult#execute()` renamed to `render()`. It really sounds better;)

NEW
: Added `MadvocConfig` flag for caching prevention.

CHANGED
: All `FileUploadFactory` implementations are now aware of `maxFileSize`.

CHANGED
: `FileUpload` now contains `maxFileSize` as attribute.

CHANGED
: `MultipartRequest` now handle uploaded files better. Internal modification.
{: .release}


## [2009-09-23] Release v3.0.6

Another small update, made mainly to fix distribution archive.

FIXED
: Distribution archives fixed.

NEW
: `ServletUtil.preventCaching()` added.

NEW
: *Madvoc* `ResultMapper` now can use full action path (with the extension) for building result path. Read more here.

NEW
: SystemUtil `isAtLeastJdk15()` and `isAtLeastJdk16()` added.

CHANGED
: `StringUtil.cutLastWord()` removed.
{: .release}


## [2009-09-10] Release v3.0.5

Small update, but we have fixed something that bothered us from long time: SQL mappings. Now everything seems to be on the right track;). Besides, some more utilities have been added.

CHANGED
: Database mappings. Read more here.

NEW
: More utilities in `ZipUtil` added.

NEW
: `Bits` added.

FIXED
: `ArrayEnumeration` fixed.

NEW
: `RandomStringUtil` added.

CHANGED
: `CsrfShield` has been enhanced.

NEW
: `ValueHolder` added.
{: .release}


## [2009-08-06] Release v3.0.4

This update fixes one important issue with *Proxetta* and enhance it in a way so it is now possible to apply proxy on JDK classes. Moreover, several little utilities have been added. It is recommended to upgrade to this version.

CHANGED
: *Petite* parameters now uses '${}' for reference.

CHANGED
: *Proxetta* now ignores final methods - for the sake of simplicity.

NEW
: *Proxetta* is now able to create proxy with different package and class name from target.

FIXED
: *Proxetta* had a serious bug with proxyfing overridden methods declared in some super class.

FIXED
: `UncheckedException` may produce bug when printing the stack trace.

CHANGED
: Double escaping added for `StringUtil.indexOfRegion()`.

NEW
: `PropertiesUtil.resolveProperty()` and `PropertiesUtil.resolveAllVariables()` added.

NEW
: `ZipUtil.createSingleEntryOutputStream()` added.

NEW
: `ZipUtil.createFirstEntryInputStream()` added.

NEW
: Simple `JmxClient` added.

NEW
: `StringUtil.isNotBlank()` added.

CHANGED
: Minor visual changes in SwingSpy.

NEW
: `PetiteManager.registreScope()` added.

CHANGED
: *Madvoc* changed internally to allow logging configuration before web application starts.

NEW
: `WebApplicationStarter` added to encapsulate code from `MadvocServletFilter`.

CHANGED
: `WebApplication.initWebApplication()` replaced `createInternalContainer()`.

CHANGED
: `XmlUtil` removed as not valuable.

FIXED
: `WebApplication.resolveBaseComponentName()` now finds last component class: middle abstract classes in hiearachy are ignored.

FIXED
: Some tests made independent.

CHANGED
: `db.jtx.*` moved to `jtx.db.*` to remove dependencies from Db.

NEW
: `FileUtil.readLines` added.

NEW
: `FilepathScanner` added.

NEW
: `ClassLoaderUtil.getResourceFile()` added.
{: .release}


## [2009-06-29] Release v3.0.3

This is important upgrade. Some bugs regarding reading annotations in *Proxetta* have been fixed, while *Proxetta* was refactored. Next, this is the first version that starts to use external logger. *Petite* container now can be configured with parameters (from properties files, for example). Documentation has been extended by an example of building web applications using *Jodd*.

NEW
: `TextUtil` added.

NEW
: Logging added. Read more here.

NEW
: More tests added and code coverage increased.

CHANGED
: *Proxetta* `MethodInfo` instead `MethodSingature`.

NEW
: *Proxetta* now has `ClassInfo` data for target classes.

FIXED
: *Proxetta* failed to read and copy all annotations.

FIXED
: *Proxetta* failed to define proxy when target class has static block.

NEW
: `ClassArrayConverter` (for converting something into Class[]) added.

NEW
: *Madvoc* can be configured using properties files.

NEW
: `@PetiteInitMethods` may be fired first off, before parameters injection.

CHANGED
: *Madvoc* `InjectorsManager` instead of just `ContextInjector`.

NEW
: table prefix and suffix are always stored uppercased.

NEW
: Transaction context added.

NEW
: `ThreadDbSessionProvider` may optionally create missing db sessions and assign them to thread.

CHANGED
: `CoreConnectionPool` now returns stat class for connections count.

NEW
: `Provider<T>` interface added.

NEW
: `ClasspathScanner` added. Read more here.

CHANGED
: `FindClass` refactored for good.

CHANGED
: Petite methods `add()` performs all wiring and initialization.

NEW
: Petite container parameters. Read more here.
{: .release}


## [2009-06-06] Release v3.0.1

Minor upgrades and additions. Documentation fixed and more added.

FIXED
: `DbSquery.setMap()` bug fixed.

NEW
: *Madvoc* components can be registered as instances and, optionally, with explicit name.

CHANGED
: `PetiteMadvocComponent` removed (internall stuff).

CHANGED
: `WebApplication.createInternalContainer()` renamed from  `createMadvocPetiteContainer()`.

FIXED
: `switch` and `case` tags now uses string comparison.

NEW
: `ServletConfigInterceptor.trimParams` option added.

NEW
: `PetiteContainer.getBean(Class)` added.

FIXED
: Some `StreamUtil.copy()` methods were not using provided encoding.

CHANGED
: `JoddDefault` added and implemented.

NEW
: `SystemUtil` methods for setting http proxy.

NEW
: `FileUtil` methods for appending string and bytes to existing file.

NEW
: `ClassConverter` and `URLConverter` added.

CHANGED
: Invalid and non-existing test values for `IfElseTag` and `IfTag` behave as `false`.
{: .release}


## [2009-05-05] Release v3.0

*Jodd* started new life on new web address: http://jodd.org
{: .release}
