# docker-fscrawler
Dockerfile for [fscrawler](https://github.com/dadoonet/fscrawler)

## Usage
The image is published on docker hub.

To run it,
```bash
docker run -it --rm --name my-fscrawler \
  -v < data folder   >:/data/fscrawler/files/:ro \
  -v < config folder >:/data/fscrawler/home/:ro \
  fscrawler
```
where
* *data folder* is the path to the folder with files to index
* *config folder* is the path to the folder that will be mounted to `.fscrawler`

For example, to run the test files provided in this repo, run

```bash
docker run -it --rm --name my-fscrawler \
  -v $PWD/test/data/:/data/fscrawler/files/:ro \
  -v $PWD/test/config:/data/fscrawler/home/:ro \
  fscrawler
```

## Building locally
  ```
  docker build -t fscrawler .
  ```
