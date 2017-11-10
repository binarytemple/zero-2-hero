#!/bin/bash
docker rm -f slides
docker run --name slides -d  -p 8000:1948 -v $PWD:/usr/src/app containersol/reveal-md
