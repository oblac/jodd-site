# FastBuffers

*Jodd* provides **fast** buffers classes for primitives. It is an
appendable collection that allows only to add content. At the end,
content can be converted to an array.

One of most interesting fast buffers is `FastCharBuffer`. If we compare
it to the `StringBuilder`, when we iterate some string and append single
chars, the tests show that `FastCharBuffer` is really faster:

![buffer](buffer-benchmark.png)

