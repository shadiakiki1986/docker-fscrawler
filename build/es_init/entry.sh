#!/bin/sh

set -e

if [ -z "$ES_URL" ]; then
  echo "Missing env var ES_URL"
  exit 1
fi

# set up ingest pipeline for preprocessing a document contents
curl --silent -XPUT -H "Content-Type: application/json" \
  -d @example_pipeline.json \
  $ES_URL/_ingest/pipeline/example_pipeline?pretty

