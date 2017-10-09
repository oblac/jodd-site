
# HttpTunnel

*HTTP* is so flexible that you can easily build a HTTP tunnel with it -
small proxy between you and destination. We even give you a base class:
`HttpTunnel` class, that provides easy HTTP tunneling. It opens server
socket on one port and tunnels the whole HTTP traffic to some target
address.

[TinyTunnel][1] is one implementation that simply prints
out the whole communication to the console.


[1]: https://github.com/oblac/tools/blob/master/src/main/java/jodd/tools/http/TinyTunnel.java
