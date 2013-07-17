
TOOLS=/Users/igor/prj/oblac/tools/

java -Dfile.encoding=UTF-8 -classpath "$TOOLS/out/production/tools:$TOOLS/lib/slf4j-api-1.7.1.jar:$TOOLS/lib/jodd-core-3.4.5-SNAPSHOT.jar:$TOOLS/lib/jodd-http-3.4.5-SNAPSHOT.jar:$TOOLS/lib/jodd-props-3.4.5-SNAPSHOT.jar:$TOOLS/lib/jodd-lagarto-3.4.5-SNAPSHOT.jar:" jodd.tools.sitegen.SiteGenerator /Users/igor/prj/oblac/jodd-site