# Jodd Servlets tools ![servlet](../gfx/servlet.png "JoddServlets")

*Jodd* provides many Servlet and JSP-related tools.

## Utils

`ServletUtil` class collects different Servlets utilities. You can
detect multipart requests, read authorization headers, prepare
downloads, work with cookies, read request body, read values from
various scopes, detects absolute URLs, detects Servlets version 2.5,
prevent caching etc.

`DispatcherUtil` provides some methods for including, forwarding and
redirecting. It also returns many different path-related information,
like context path, query strings etc.

## Map wrappers

*Jodd* provides `Map` wrapper for request, response and session. They
are `Map` adapters to servlets class, and from the outside user does not
work with them directly. They are useful for separating code from the
servlets implementation.

## File upload

There is a whole set of classes for dealing with the multipart request
and file uploads. Uploaded files can be downloaded in the memory, on the
file system, or adaptive - depending on the size.

## Listeners and broadcasters

`HttpSessionListenerBroadcaster` simple sends events to all registered
session listeners when session is created or destroyed.

`RequestContextListener` stores request in the current thread.

## JSP Tag library

*Jodd* comes with small, but sufficient tag library. It offers some
common functionality: various looping tags, conditional and branching
tags, setting and reading variables etc.

Read more about *Jodd* [JSP tag library](taglibrary.html).

## CSRF shield 

*Jodd* provides simple and efficient CSRF ([Cross-site request forgery][1] protection.

## Filters

*Jodd* offers only few servlet filters: `GZipFilter` ([read more](/doc/htmlstapler/enabling-gzip.html#GZIP-filter)),
`CharacterEncodingFilter` (not useful much as it can be replaced by
`web.xml` configuration) and `RemoveSessionFromUrlFilter`.

However, there are many filter-related classes, like fast byte- array
and char array wrappers, including the advanced `BufferResponseWrapper`.


[1]: http://en.wikipedia.org/wiki/Cross-site_request_forgery