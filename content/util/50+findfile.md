# Find files

Finding files - i.e. walking directories and files (recursively, too!)
is a common everyday task in life of Java developer. *Jodd* offers
several solution for directory walking.

## FindFile

`FindFile` offers more powerful way to search paths for files and
folders. `FindFile` works incrementally, by supplying one file per call, so
files can be examined during the search without storing them in some
additional temporary storage.

`FindFile` simply iterates all founded files and folders on provided
paths.

Here is one simple example that finds all the files on some path:

~~~~~ java
    FindFile ff = new FindFile()
        .recursive(true)
        .includeDirs(true)
        .searchPath("/some/path");

    File f;
    while ((f = ff.nextFile()) != null) {
        // process file
    }
~~~~~

The same example using iterator:

~~~~~ java
    FindFile ff = new FindFile()
        .recursive(true)
        .includeDirs(true)
        .searchPath("/some/path");

    Iterator<File> iterator = ff.iterator();

    while (iterator.hasNext()) {
        File f = iterator.next();
        // process file
    }
~~~~~

The same example using lambda:

~~~~~ java
    FindFile ff = new FindFile()
        .recursive(true)
        .includeDirs(true)
        .searchPath("/some/path");

    ff.forEach(file -> {
        // process file
    });
~~~~~

Once when scanning is complete, you can call the `reset()` method to go back
to the beginning and then start the very same search again.


## WildcardFindFile

Subclasses of `FindFile` provide various file matching mechanisms. The
fastest and, probably, the most used one is `WildcardFindFile` - it uses
wildcard patterns (`*`, `?` and `**`) for matching files.

There are 3 matching modes for matching wildcards patterns:

+ `FULL_PATH` - the full, absolute path is matched,
+ `RELATIVE_PATH` - only relative path from provided search root is
  matched,
+ `NAME` - only file name is matched, path is ignored.

## RegExpFindFile

Similar to `WildcardFindFile`, `RegExpFindFile` variant simply match the files using the regular expression.
Everything else is the same.

## Include/exclude rules

`FindFile` uses `InExRules` engine for managing included/excluded files and paths.
It is very powerful engine that provides various ways how to include/exclude one or more items.

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

## Results sorting

`FindFile` is able to sort folders and files in various ways. When
sorting is active, `FindFile` uses somewhat more memory.

Anyhow, you can simply turn on sorting by calling one or more
`sortByXxx() `methods. This will defined the sort chain. It will be
executed in given direction, so be careful how you order the sort
methods.

Example:

~~~~~ java
    FindFile ff = FindFile.get()
    	.recursive(false)
    	.includeDirs(true)
    	.includeFiles(true)
    	.sortFoldersFirst()
    	.sortByName()
    	.searchPath("/some/path");
~~~~~

Here we define search where folders are listed before files and everything is
sorted by file name. When sorting by names, `FindFile` will use natural
order.

Calling `sortNone()` will reset and remove any previously applied sorting.

