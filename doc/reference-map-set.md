# Reference Map and Set

Probably you are already familiar with the existence of `WeakHashMap`\:
a hashmap implementation with weak keys. Sadly, that is the only
reference based collection available in the JDK. Fortunately, *Jodd*
gives you more power with two reference-aware collections:
`ReferenceMap` and `ReferenceSet`, where user can choose the
'strength' of the used keys and/or values.

## ReferenceMap

`ReferenceMap` usage is quite simple: constructor takes two arguments
that defines the reference strength of the keys and values:

~~~~~ java
    ReferenceMap<String, String> rm = new ReferenceMap<String, String>(WEAK, STRONG);
    String key = new String("key");      // enforce instance creation
    rm.put(key, "value");
    System.out.println(rm.isEmpty());    // false
~~~~~

Lets assume that `key` becomes `null` and that garbage collector has
destroyed the instance. We may simulate this with the following code
(although there are no guarantees that it will work):

~~~~~ java
    key = null;
    System.gc();
    System.gc();
    ThreadUtil.sleep(5000);
~~~~~

Now `rm.isEmpty()` returns `true`.

### Reference Types

Following reference types can be used, defined in the `ReferenceTypes`
enumeration:

* `STRONG` - Prevents referent from being reclaimed by the garbage
  collector,
* `SOFT` - Referent reclaimed in an LRU fashion when the VM runs low on
  memory and no strong references exist,
* `WEAK` - Referent reclaimed when no strong or soft references exist,
* `PHANTOM` - Similar to weak references except the garbage collector
  doesn't actually reclaim the referent. More flexible alternative to
  finalization.

## ReferenceSet

`ReferenceSet` is reference-aware set, where user can define the
weakness of the used elements. Example:

~~~~~ java
    ReferenceSet rs = new ReferenceSet<String>(WEAK);
    String value = new String("value");
    rs.add(value);
    System.out.println(rs.isEmpty());		// false
~~~~~

After value is nulled and garbage collected, `rs.isEmpty()` returns `true`.
