#!/usr/bin/env bash

FILES=./*.md

mkdir -p output
for f in $FILES
do
  bf=$(basename -s .md $f)
  docker run -v $PWD:/source jagregory/pandoc ${bf}.md -o output/${bf}.pdf
done

docker run -v $PWD:/source jagregory/pandoc $FILES -o output/all_in_one.pdf

