# Finding files and folders

Finding files - i.e. walking directories and files (recursively, too!)
is a common everyday task in life of Java developer. *Jodd* offers
several solution for directory walking.

For finding classes, see [Class Finder](class-finder.html).
{: .attn}

## FileFilterEx

*Jodd* integrates two JDK file filtering interfaces `FileFilter` and
`FilenameFilter` into one: `FileFilterEx`. There is also default base
(abstract) implementation for new interface, `FileFilterBase` that works
as adapter to both JDK filters.

Furthermore, *Jodd* offers two most common `FileFilterEx`
implementations: `RegExpFileFilter` and `WildcardFileFilter`. They
provides filtering using regular expression (slower) and
[wildcards](/doc/wildcard.html) (faster), respectively.

`FileFilterEx` implementations may be used in `File.list()` and
`File.listFiles()`.

## FindFile

`FindFile` offers more powerful way to search paths for files and
folders. `FindFile` works incrementally, providing one file per call, so
files can be examined during the search without storing them in some
additional temporary storage.

`FindFile` simply iterates all founded files and folders on provided
paths.

### WildcardFindFile

Subclasses of `FindFile` provide various file matching mechanisms. The
fastest and, probably, the most used one is `WildcardFindFile` - it uses
wildcard patterns (`*`, `?` and `**`) for matching files. Other
available implementations are: `RegExpFindFile` (uses regular expression
instead of wildcards) and `FilterFindFile`.

There are 3 matching modes for matching wildcard (and regular
expression) patterns:

* `FULL_PATH` - the full, absolute path is matched,
* `RELATIVE_PATH` - only relative path from provided search root is
  matched,
* `NAME` - only file name is matched.

### Example

`FindFile` (and subclasses) works iteratively, without a callback class.
There are two usage scenarios: using `FindFile` class itself or using an
iterator.

Here is one simple example that finds all files on some path:

~~~~~ java
    FindFile ff = new FindFile()
    	.setRecursive(true)
    	.setIncludeDirs(true)
    	.searchPath("/some/path");
    
    File f;
    while ((f = ff.nextFile()) != null) {
    	if (f.isDirectory() == true) {
    		System.out.println(". >" + f.getName());
    	} else {
    		System.out.println(". " + f.getName());
    	}
    }
~~~~~

The same example using iterator:

~~~~~ java    
    FindFile ff = new FindFile()
    	.setRecursive(true)
    	.setIncludeDirs(true)
    	.searchPath("/some/path");
    
    Iterator<File> iterator = ff.iterator();
    
    while (iterator.hasNext()) {
    	File f = iterator.next();
    	if (f.isDirectory() == true) {
    		System.out.println(". >" + f.getName());
    	} else {
    		System.out.println(". " + f.getName());
    	}
    }
~~~~~

Why both ways? Why not;)

Once when search is done, you can call the `reset()` method to go back
to the beginning and then start the very same search again.

## FindFile callbacks

While scanning files, method `acceptFile()` is called for each founded
file and folder. You can override this method and control which files
will be excluded from the searching.

Your `acceptFile()` can also collect files in some resulting collection!
Then you can just call `scan()` method on `FindFile` and the whole
file-searching loop will be iterated for you.

## FindFile configuration

`FindFile` may be fine tuned with following properties:

* `recursive` - when set to `true`, folders inner content will be
  scanned
* `includeDirs` - if folders should be included. Note that when set to
  `false`, recursive mode still works; just folders are skipped.
* `includeFiles` - should files be included in the search.
* `matchType` - for subclasses of `FindFile`.
* `walking` - this flag describes how the files will be iterated (in
  recursion). When set to `true` (default), subfolders content will be
  iterated immediately after the subfolder is found. This gives a
  natural way of walking files; but consumes more memory. When set to
  `false`, all files are processed at once; all subfolder files are
  iterated after. This approach gives the optimal memory consumption.

## FindFile sorting

`FindFile` is able to sort folders and files in various ways. When
sorting is active, `FindFile` uses somewhat more memory.

Anyhow, you can simply turn on sorting by calling one or more
`sortByXxx() `methods. This will defined the sort chain. It will be
executed in given direction, so be careful how you order the sort
methods.

Example:

~~~~~ java    
    FindFile ff = new FindFile()
    	.setRecursive(false)
    	.setIncludeDirs(true)
    	.setIncludeFiles(true)
    	.sortFoldersFirst()
    	.sortByName()
    	.searchPath("/some/path");
~~~~~

Above example defines search where folders goes before files and all are
sorted by file name. When sorting by names, `FindFile` will use natural
order.

Note for recursive mode: walked folders are sorted one after the other,
not all at once!
{: .attn}

Since sorting chain is accumulated, calling `sortNone()` will reset and
remove any sorting.
