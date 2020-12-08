# Build dockerfile on top of official elasticsearch image
# to add healthcheck

# Links below copied from
# https://github.com/elastic/elasticsearch-docker/blob/master/Makefile
# alternative alpine image available at 110 MB (vs 164 MB for 5.1.2)
# Browse alternatives at https://www.docker.elastic.co/
# Note that the alpine image isn't published there
# Also note that there seem to be "flavors" to 6.1.1 for example with/without xpack
# More details at https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html
# Update 2020-12-07 Upgrade to 6.5.2 due to _docs (https://github.com/danielberkompas/elasticsearch-elixir/issues/52)
# FROM docker.elastic.co/elasticsearch/elasticsearch:5.1.2
# FROM docker.elastic.co/elasticsearch/elasticsearch-alpine-base:latest
#FROM docker.elastic.co/elasticsearch/elasticsearch:6.1.1
FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.2



# Healthcheck. Copied from
# https://github.com/docker-library/healthcheck/blob/master/elasticsearch/Dockerfile
# Set to yellow for the case of running 1 node, like note in 
# tests/test_basic_index_crud.py # test_cluster_health_after_crud
# Reference: https://docs.docker.com/engine/reference/builder/#/healthcheck 
#
# TODO How to detect that 2 nodes are running and wait for "green"?
# Update 2020-12-07 after upgrade to 6.5.2, this is giving green again instead of yellow, so updating script for either one of green or yellow
COPY docker-healthcheck /usr/local/bin/
HEALTHCHECK CMD ["/bin/bash","docker-healthcheck"]
