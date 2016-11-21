#!/bin/sh

reports=( coverage javadoc tests )

for var in "${reports[@]}"
do
  echo "${var}"
  rm -rf $var
  mkdir $var
	cp -r ../jodd/build/reports/$var/ ./$var
done

cd coverage
find . -name "*.html" -exec sed -i '' "s/.resources/resources/g" {} \;
mv .resources resources
cd ..


git add --all
git commit -m "Jodd reports updated"
git push
