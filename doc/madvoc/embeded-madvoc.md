# Embedded Madvoc

<div class="doc1"><js>doc1('madvoc',20)</js></div>
*Madvoc* web applications can run in embedded servlet containers, too. Here are few examples.

## Embedded Tomcat

With Tomcat, running *Madvoc* application is really simple:

~~~~~ java
    Tomcat tomcat = new Tomcat();
    tomcat.setPort(8080);
    String workingDir = System.getProperty("java.io.tmpdir");
    tomcat.setBaseDir(workingDir);
    tomcat.addWebapp("/", webRoot.getAbsolutePath());
    tomcat.start();
~~~~~

The `webRoot` is a root of the web application. Simple as that!
