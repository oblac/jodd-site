
# prepare artifacts

echo artifacts

cp .release/jodd-*.zip .out/download
cp .release/jodd-*.jar .out/download

# prepare api documentation

echo api doc

if [ ! -f .release/api.zip ]; then
	echo build api archive
	cd api
	cp -pR ~/prj/oblac/jodd/build/reports/javadoc/* .
	zip -9 -r -m -q api.zip * .[^.]*
	cd ..
	mv api/api.zip .release
fi

cp .release/api.zip .out/

# prepare test documentation

echo test doc

if [ ! -f .release/test.zip ]; then
	echo build test archive
	cd test
	cp -pR ~/prj/oblac/jodd/build/reports/tests/* .
	mkdir coverage-report
	cp -pR ~/prj/oblac/jodd/build/reports/coverage/* ./coverage-report/
	cp -pR ~/prj/oblac/jodd/build/reports/coverage/.??* ./coverage-report/
	zip -9 -r -m -q test.zip * .[^.]*
	cd ..
	mv test/test.zip .release
fi

cp .release/test.zip .out/

echo done.