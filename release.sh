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
find . -name "*.html" -exec sed -i '' "s/.resources/_resources/g" {} \;
mv .resources _resources
cd ..


git add --all
git commit -m "Jodd reports updated"
git push
