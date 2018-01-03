#!/bin/sh

set -e

if [ -z "$ES_URL" ]; then
  echo "Missing env var ES_URL"
  exit 1
fi

PIPELINE=example_pipeline

# if pipeline was not uploaded, then this curl call would fail with http 404 (not found)
if health="$(curl -fsSL $ES_URL/_ingest/pipeline/$PIPELINE?pretty)"; then
  exit 0
fi
exit 1
