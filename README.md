# docker-fscrawler [![Build Status](https://travis-ci.org/shadiakiki1986/docker-fscrawler.svg?branch=master)](https://travis-ci.org/shadiakiki1986/docker-fscrawler)
Dockerfile for [fscrawler](https://github.com/dadoonet/fscrawler)

## Usage
The image is published on docker hub [here](https://hub.docker.com/r/shadiakiki1986/fscrawler/).

To run it,
```bash
docker run -it --rm --name my-fscrawler \
  -v < data folder   >:/data/fscrawler/files/:ro \
  -v < config folder >:/data/fscrawler/home/:ro \
  shadiakiki1986/fscrawler
```
where
* *data folder* is the path to the folder with files to index
* *config folder* is the path to the folder that will be mounted to `.fscrawler`

For example, to run the test files provided in this repo, run

```bash
docker run -it --rm --name my-fscrawler \
  -v $PWD/test/data/:/data/fscrawler/files/:ro \
  -v $PWD/test/config:/data/fscrawler/home/:ro \
  shadiakiki1986/fscrawler
```

Note that the publishd dockerfile uses fscawler 2.1 by default ATM.
To install 2.2, build your own image as below

## Building locally
  ```
  docker build -t fscrawler .
  ```

use `docker build ... --build-args FSCRAWLER_VER=2.2 ...` to build the image using fscrawler 2.2
