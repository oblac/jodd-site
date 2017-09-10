#!/bin/sh

reports=( javadoc tests )

for var in "${reports[@]}"
do
  echo "${var}"
  rm -rf $var
  mkdir $var
	cp -r ../jodd/build/reports/$var/ ./$var
done

git add --all
git commit -m "Jodd reports updated"
git push
