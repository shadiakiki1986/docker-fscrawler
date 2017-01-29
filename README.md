# docker-fscrawler [![Build Status](https://travis-ci.org/shadiakiki1986/docker-fscrawler.svg?branch=master)](https://travis-ci.org/shadiakiki1986/docker-fscrawler)
Dockerfile for [fscrawler](https://github.com/dadoonet/fscrawler)

Mostly inspired by elasticsearch's alpine [dockerfile](https://github.com/docker-library/elasticsearch/blob/f2e19796b765e2e448d0e8c651d51be992b56d08/5/alpine/Dockerfile)

Includes version `2.2-SNAPSHOT` (`20170124.163124`) of `fscrawler`

## Usage
The image is published on docker hub [here](https://hub.docker.com/r/shadiakiki1986/fscrawler/).

To run it,
```bash
docker run -it --rm --name my-fscrawler \
  -v <data folder>:/usr/share/fscrawler/data/:ro \
  -v <config folder>:/usr/share/fscrawler/config/:ro \
  shadiakiki1986/fscrawler \
  [CLI options]
```
where
* *data folder* is the path to the folder with the files to index
* *config folder* is the path to fscrawler's [config dir](https://github.com/dadoonet/fscrawler#cli-options)
* *CLI options* are documented [here](https://github.com/dadoonet/fscrawler#cli-options)

## Example 1.1
For example, to index the test files provided in this repo, with `loop=1` to run it only once

```bash
docker run -it --rm --name my-fscrawler \
  -v $PWD/test/data/:/usr/share/fscrawler/data/:ro \
  shadiakiki1986/fscrawler
```

## Example 2
Same example above, but with `loop=1` to run it only once

```bash
docker run -it --rm --name my-fscrawler \
  -v $PWD/test/data/:/usr/share/fscrawler/data/:ro \
  shadiakiki1986/fscrawler \
    --loop 1 --trace
```

## Example 3
To override the config dir

```bash
docker run -it --rm --name my-fscrawler \
  -v $PWD/test/data/:/usr/share/fscrawler/data/:ro \
  -v $PWD/config:/usr/share/fscrawler/config/:ro \
  shadiakiki1986/fscrawler
```

## Building locally
```
docker build -t fscrawler .
```
