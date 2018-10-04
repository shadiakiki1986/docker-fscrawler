# docker-fscrawler [![Build Status](https://travis-ci.org/shadiakiki1986/docker-fscrawler.svg?branch=master)](https://travis-ci.org/shadiakiki1986/docker-fscrawler)
Dockerfile for [fscrawler](https://github.com/dadoonet/fscrawler)

Mostly inspired by elasticsearch's alpine [dockerfile](https://github.com/docker-library/elasticsearch/blob/f2e19796b765e2e448d0e8c651d51be992b56d08/5/alpine/Dockerfile)

Supported tags
- `2.2` with fscrawler version 2.2 and alpine 3.5
- `2.4` with fscrawler 2.4 and alpine 3.5
- `2.5-SNAPSHOT-ubuntu` with fscrawler `2.5-SNAPSHOT` and ubuntu 16.04 (built from dockerfile in `ubuntu` folder)

Dockerfile includes [tesseract](https://github.com/tesseract-ocr/tesseract/wiki) (via [alpine 3.5](https://pkgs.alpinelinux.org/packages?name=tesseract-ocr&branch=&repo=&arch=&maintainer=))

PS: The Ubuntu image was added because the alpine image was giving an error upon `mvn clean install`
It said that `initial heap size larger than max heap size` and I couldn't figure it out.
The alpine image was 308 MB, whereas the ubuntu image is 1.2 GB (but also includes tesseract-fra).
Probably a good idea to get the alpine image to work.

## Usage Instructions
The image is published on docker hub [here](https://hub.docker.com/r/shadiakiki1986/fscrawler/).

### stand-alone docker
To run it against an elasticsearch instance served locally at port 9200,
```bash
docker run -it --rm --name my-fscrawler \
  -v <data folder>:/usr/share/fscrawler/data/:ro \
  -v <config folder>:/usr/share/fscrawler/config-mount/<project-name>:ro \
  shadiakiki1986/fscrawler \
  [CLI options]
```
where
* *data folder* is the path to the folder with the files to index
* *config folder* is the path to the host fscrawler [config dir](https://github.com/dadoonet/fscrawler#cli-options)
  * make sure to use the proper URL reference in the config file to point to `localhost:9200` if elasticsearch is running locally
* if the config folder is not mounted from the host, the docker container will have an empty `config` folder, thus prompting the user for confirmation `Y/N` of creating the first project file
* *CLI options* are documented [here](https://github.com/dadoonet/fscrawler#cli-options)


### with docker-compose

Docker-fscrawler can be used in coordination with an elasticsearch docker container or an elasticsearch instance running natively on the host machine. To make coordination between the ES and
fscrawler containers easy, it is recommended to use docker-compose, as described here.
 
Make sure you have set up `vm.max_map_count=262144` by either putting it in `/etc/sysctl.conf` and 
running `sudo sysctl -p`, or whatever other means is convenient to you. This is necessary for elasticsearch. (see 
[Ref](https://github.com/docker-library/elasticsearch/issues/111))


#### Download

Download the following files from this git repository. Cloning the whole repository it _not_ necessary.

`docker-compose-deployment.yml`   
`build/elasticsearch/docker-healthcheck`
 
Make a new empty folder and put these two files in it. This directory will be the home of your configurations, and the 
location from which you can control your containers and make changes.
 
 Change the name of `docker-compose-deployment.yml` to `docker-compose.yml`.


###### Optional: Configure Containers

* Make a file here called `.env`. Here you can configure the docker containers.
* Add the line `TARGET_DIR=/path/to/directory/you/want/to/index`. If you don't add this line, it will default to `./data/`
* Add the line `JOB_NAME=name_to_give_your_index`. This will be the name of the fscrawler job and the ES index. 
If you don't add this line, it will default to fscrawler_job.

#### Configure fscrawler

Now run

```bash
docker-compose run fscrawler
```

Respond with `Y` to the question of whether to create a new config.

Edit the newly created `config/fscrawler_job/_settings.json` file (you may need to use sudo, the folder name may be 
different if you are using `.env`). Change elasticsearch.nodes from `127.0.0.1` to
`elasticsearch1`, so that it reads follows. 

```json
...
  "elasticsearch" : {
    "nodes" : [ {
      "host" : "elasticsearch1",
      "port" : 9200,
      "scheme" : "HTTP"
    } ],
    "bulk_size" : 100,
    "flush_interval" : "5s"
  },
...
```

For the rest of the settings in this file, can choose your own based on 
[the options documented here](https://fscrawler.readthedocs.io/en/latest/admin/fs/local-fs.html#). Do not change fs.url 
unless you also change the corresponding line in `docker-compose.yml`, or else fscrawler won't be able to find your 
files.


#### Test

Populate `data/` or the directory you specified in `.env` with some files you would like to index.

Run the following.

```bash
docker-compose up -d elasticsearch1 elasticsearch2
docker-compose up -d fscrawler
```

fscrawler should then upload the test files you put in `data/`. To check that all is well, 
query the elasticsearch over http (substitute fscrawler_job if you gave it your own name in `.env`)

```bash
curl http://localhost:9200/fscrawler_job/_search | jq
```

If you see all your documents here, you should be good to go!

#### Troubleshooting

If you don't see all your documents, use the following command to get more detailed logs. 

```bash
docker-compose run fscrawler --config_dir /usr/share/fscrawler/config fscrawler_job --restart --debug
```

Hopefully these logs will make it clear what went wrong. Failing that you can use 
`--trace` instead of `--debug` for even more detailed logs. You can also use `--restart` whenever you want to re-index 
everything (otherwise files are only reindexed when they are touched).

Additional options for `docker-compose run fscrawler` can be found 
[here](https://github.com/dadoonet/fscrawler#cli-options).


## Additional Usage Examples

### Example 1
Using `docker-compose`, startup elasticsearch and run fscrawler on files in `test/data` every 15 minutes:

```bash
docker-compose up elasticsearch1 fscrawler
```

For the remaining examples, the default config depends on having a running elasticsearch instance on the localhost at port 9200.
Start one with:

```bash
# [Ref](https://github.com/docker-library/elasticsearch/issues/111)
sudo sysctl -w vm.max_map_count=262144

docker-compose run -p 9200:9200 -d elasticsearch1
```

For the versions of the `docker-compose` file, `docker-compose`, and `docker`, check the [travis builds](https://travis-ci.org/shadiakiki1986/docker-fscrawler/)

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
  -v $PWD/config/myjob:/usr/share/fscrawler/config-mount/myjob:ro \
  shadiakiki1986/fscrawler \
    --config_dir /usr/share/fscrawler/config \
    --loop 1 \
    --trace \
    myjob
```


## Building locally

To build the docker image
```
git clone https://github.com/shadiakiki1986/docker-fscrawler
docker build -t shadiakiki1986/fscrawler:local .
```

To test against elasticsearch locally, follow steps in `.travis.yml`


## Updating

To update `fscrawler` in this docker container:
- update the version number used in `Dockerfile`
  - also update the URL to the maven zip file to download
- try to build, e.g. `docker build -t shadiakiki1986/fscrawler:2.4 .`
- try to run
- commit, tag, push

To update the automated build on hub.docker.com
- the "latest" tag will get re-built automatically with the `push` above
- to add a new version tag, need to `build settings` and add it manually, then click `save` and `trigger`

To update `elasticsearch` in the `docker-compose` for the purpose of testing (e.g. `.travis.yml`)
- edit `build/elasticsearch/Dockerfile` by changing `FROM` image
- follow steps in `.travis.yml`


## Changelog

Version 2.4.2 (2018-10-04)
- change the main base image to be ubuntu instead of alpine linux
  - move the alpine linux image into a "alpine" folder
  - move teh ubuntu linux image out of the "ubuntu" folder


Version 2.4 (2017-12-27)
- update fscrawler from 2.2 to 2.4
- use `config-mount` for mounting config folder into fscrawler docker container
- update elasticsearch service from 5.1.2 to 6.1.1
  - elasticsearch 5.1.2 was not working with fscrawler 2.4 anyway because of https://github.com/dadoonet/fscrawler/issues/472
- replace git submodule of my fork of elasticsearch-docker with just `build/elasticsearch/Dockerfile`
  - the purpose of the fork was to push healthchecks into upstream, but my PR was rejected
  - fork was at https://github.com/shadiakiki1986/elasticsearch-docker
  - PR was at https://github.com/elastic/elasticsearch-docker/pull/27
  - argumentation at https://github.com/elastic/elasticsearch-docker/issues/60
  - proposed solution of just using docker-compose healthcheck would be too long in order to wait for "green" status

Version 2.2 (2017-02-22)
-  use fscrawler 2.2
