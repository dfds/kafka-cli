#!/bin/bash

set -o errexit
set -o pipefail

KAFKA_CLI_IMAGE=${KAFKA_CLI_IMAGE:-dfdsdk/kafka-cli:0.1.2}
KAFKA_CONFIG=${KAFKA_CONFIG:-~/.ccloud/config}
KAFKA_BOOTSTRAP_SERVER=${KAFKA_BOOTSTRAP_SERVER:-pkc-l9pve.eu-west-1.aws.confluent.cloud:9092}

# Setting MSYS_NO_PATHCONV is for running bash on Windows, as it should not convert paths.
MSYS_NO_PATHCONV=1 \
docker run --rm \
  --volume ${KAFKA_CONFIG}:/data/config \
  ${KAFKA_CLI_IMAGE} \
  kafka-consumer-groups.sh \
  --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} \
  --command-config /data/config \
  --list | sort