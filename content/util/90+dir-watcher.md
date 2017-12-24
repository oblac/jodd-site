# DirWatcher

`DirWatcher` is pure-java solution for watching files changes in some directory.
While the similar solution exist in JDK7+, it depends on native
code and it does not work so reliable in practice. Moreover, `DirWatcher`
has some more features, that would be very helpful for developers.

## Watching for changes

Starting the watcher on some directory requires just three steps.
First you need to create and configure an instance of `DirWatcher`.
Then register a `DirWatcherListener` that is going to accept the events on
changes. And finally, start the watcher.

~~~~~ java
	DirWatcher dirWatcher = new DirWatcher(root, "*.md");

	dirWatcher.register(new DirWatcherListener() {
		public void onChange(File file, DirWatcher.Event event) {
			System.out.println(file.getName() + ":" + event.name());
		}
	});

	dirWatcher.start(1000);
~~~~~

As you can see from the example, `DirWatcher` can be created with a list of
wildcard templates for file names. Here we are watching only markdown files.
By default dot files are ignored, but this can be enabled. `DirWatcher` is
started by providing polling interval in milliseconds.

From this moment, all matched files are watched for changes and following
events are fired:

+ CREATED - when new file appears in the watched folder,
+ DELETED - when a file was deleted from the watched folder,
+ MODIFIED - when files last access timestamp was modified.

## Stopping the watcher

Watcher can be stopped any time:

~~~~~ java
	dirWatcher.stop();
~~~~~

## Watch file

File copy operation for larger files takes some time. It may happens that
your OS has not copied the whole file yet, but the `DirWatcher` fires the event.
In this case it is not possible to use file from the listener.

Fortunately, `DirWatcher` has an option to watch only the so-called
_watch file_. Instead of watching all files on regular time intervals, in this
mode `DirWatcher` monitors only the watch file. Only when watch file is changed
(i.e. touched), `DirWatcher` scans for changes of _all_ files.

This helps in described situation, when copying big files. In that case,
start `DirWatcher` with watch file and touch it when you need to scan for the
changes (i.e. after the copy operation finishes).

Example:

~~~~~ java
	DirWatcher dirWatcher = new DirWatcher(dataRoot)
			.monitor("*.txt")
			.useWatchFile("watch.txt");
~~~~~

This `DirWatcher` will trigger folder changes scan only when the watch file is
touched.

## Blank start

When starting `DirWatcher`, it will by default scan the watched folder to
collect information about existing files. After that, real monitoring starts.

Sometimes you need to fire events on startup for all existing files. In that
case, run `DirWatcher` in _blank_ mode:

~~~~~ java
	DirWatcher dirWatcher = new DirWatcher(dataRoot)
			.monitor("*.txt")
			.startBlank(true);
~~~~~

Now all existing files will be considered as newly created.

Awesome!