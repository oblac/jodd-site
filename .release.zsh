# stop script if anything fails!

set -e

# prepare artifacts

echo artifacts

cp .release/jodd-*.zip _out/download
cp .release/jodd-*.jar _out/download

# prepare api documentation

echo api doc

if [ ! -f .release/api.zip ]; then
	echo build api archive
	mkdir api || true
	cd api
	cp -pR ~/prj/oblac/jodd/build/reports/javadoc/* .
	zip -9 -r -m -q api.zip * .[^.]*
	cd ..
	mv api/api.zip .release
fi

cp .release/api.zip _out/

# prepare test documentation

echo test doc

if [ ! -f .release/test.zip ]; then
	echo build test archive
	mkdir test || true
	cd test
	cp -pR ~/prj/oblac/jodd/build/reports/tests/* .
	mkdir coverage-report
	cp -pR ~/prj/oblac/jodd/build/reports/coverage/* ./coverage-report/
	cp -pR ~/prj/oblac/jodd/build/reports/coverage/.??* ./coverage-report/
	zip -9 -r -m -q test.zip * .[^.]*
	cd ..
	mv test/test.zip .release
fi

cp .release/test.zip _out/

echo done.