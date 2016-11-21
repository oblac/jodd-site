#!/bin/sh

reports=( coverage javadoc tests )

for var in "${reports[@]}"
do
  echo "${var}"
  rm -rf $var
  mkdir $var
	cp -r ../jodd/build/reports/$var/ ./$var
done
