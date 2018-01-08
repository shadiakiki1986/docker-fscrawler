Basically a copy of alpine/Dockerffile and alpine/entry.sh but with ubuntu:16.04
Based on file published by  alcibiade here
https://github.com/dadoonet/fscrawler/issues/314#issuecomment-282823207

Main differences
- gosu instead of su-exec
- adaduser/addgroup options different than busybox (alpine)

Build
```
cd docker-fscrawler
docker build -t shadiakiki1986/fscrawler:ubuntu-2.5-SNAPSHOT ubuntu
```
