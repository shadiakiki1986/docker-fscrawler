# docker-fscrawler [![Build Status](https://travis-ci.org/shadiakiki1986/docker-fscrawler.svg?branch=master)](https://travis-ci.org/shadiakiki1986/docker-fscrawler)
Dockerfile for [fscrawler](https://github.com/dadoonet/fscrawler)

Mostly inspired by elasticsearch's alpine [dockerfile](https://github.com/docker-library/elasticsearch/blob/f2e19796b765e2e448d0e8c651d51be992b56d08/5/alpine/Dockerfile)

Includes version `2.2` of `fscrawler`

and [tesseract](https://github.com/tesseract-ocr/tesseract/wiki) (via [alpine 3.5](https://pkgs.alpinelinux.org/packages?name=tesseract-ocr&branch=&repo=&arch=&maintainer=))

## Usage
The image is published on docker hub [here](https://hub.docker.com/r/shadiakiki1986/fscrawler/).

To run it against an elasticsearch instance served locally at port 9200,
```bash
docker run -it --rm --name my-fscrawler \
  -v <data folder>:/usr/share/fscrawler/data/:ro \
  -v <config folder>:/usr/share/fscrawler/config/ \
  shadiakiki1986/fscrawler \
  [CLI options]
```
where
* *data folder* is the path to the folder with the files to index
* *config folder* is the path to fscrawler's [config dir](https://github.com/dadoonet/fscrawler#cli-options)
  * if this folder is not mounted from the host, the default config is the one in `config` in the github repository
  * this folder cannot be mounted with `:ro`
    * because the user permissions on it need to be changed in the dockerfile as it is user-mutable by fscrawler
    * For a more detailed explanation of this docker volume permissions methodology, check http://stackoverflow.com/a/29799703/4126114
* *CLI options* are documented [here](https://github.com/dadoonet/fscrawler#cli-options)

## Examples

### Example 1
Using `docker-compose`, startup elasticsearch and run fscrawler on files in `test/data` every 15 minutes:

```bash
./docker-compose-wrap.sh up elasticsearch1 fscrawler
```

For the remaining examples, the default config depends on having a running elasticsearch instance on the localhost at port 9200.
Start one with:

```bash
# [Ref](https://github.com/docker-library/elasticsearch/issues/111)
sudo sysctl -w vm.max_map_count=262144

./docker-compose-wrap.sh run -p 9200:9200 -d elasticsearch1
```

The `docker-compose` file version is `2.1`, tested with `docker-compose 1.11.1` and `docker 1.13.1`

Notice that the docker-compose `fscrawler` service is wired to wait for a healthcheck in `elasticsearch`.
In the case of a manual launch of elasticsearch:
- wait for around 15 seconds,
- or watch the logs,
- or check `http://$host:9200/_cat/health?h=status`
where you need to wait for `yellow` or `green`, depending on your application

### Example 2
To index the test files provided in this repo

```bash
docker run -it --rm \
  --net="host" \
  --name my-fscrawler \
  -v $PWD/test/data/:/usr/share/fscrawler/data/:ro \
  shadiakiki1986/fscrawler
```

### Example 3
Same example above, but with `loop=1` to run it only once

```bash
docker run -it --rm \
  --net="host" \
  --name my-fscrawler \
  -v $PWD/test/data/:/usr/share/fscrawler/data/:ro \
  shadiakiki1986/fscrawler \
    --config_dir /usr/share/fscrawler/config \
    --loop 1 \
    --trace \
    myjob
```

### Example 4
To override the config dir

```bash
docker run -it --rm \
  --net="host" \
  --name my-fscrawler \
  -v $PWD/test/data/:/usr/share/fscrawler/data/:ro \
  -v $PWD/config:/usr/share/fscrawler/config/ \
  shadiakiki1986/fscrawler
```

## Building locally
```
docker build -t shadiakiki1986/fscrawler:local .
```
