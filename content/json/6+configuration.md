# Json Configuration

Like for many classes in *Jodd*, *Json* serialization and parsing can be configured globally using the static fields.

The global configuration for `JsonSerializer` is defined in `JsonSerializer.Defaults` class. There you can enable some flags and set some values that will be used by default by any new instance of the `JsonSerializer`.

The same thing applies to the `JsonParser`. It's default configuration is in `JsonParser.Defaults`.