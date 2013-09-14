
TOOLS=/Users/igor/prj/oblac/tools/
JODD_VER=3.4.6-SNAPSHOT
java -Dfile.encoding=UTF-8 -classpath "$TOOLS/out/production/tools:$TOOLS/lib/slf4j-api-1.7.1.jar:$TOOLS/lib/fastjson-1.1.36.jar:$TOOLS/lib/jodd-core-$JODD_VER.jar:$TOOLS/lib/jodd-http-$JODD_VER.jar:$TOOLS/lib/jodd-props-$JODD_VER.jar:$TOOLS/lib/jodd-lagarto-$JODD_VER.jar:" jodd.tools.sitegen.SiteGenerator /Users/igor/prj/oblac/jodd-site