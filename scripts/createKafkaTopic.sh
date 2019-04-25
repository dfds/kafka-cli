#!/bin/bash

set -o errexit
set -o pipefail

while getopts ":c:p:f:r" opt; do
    case "${opt}" in
        c)
            c=${OPTARG}
            ((c == "delete" || c == "compact")) || usage
            KAFKA_CLEANUP_POLICY=c
            ;;
        p)
            p=${OPTARG}
            KAFKA_PARTITIONS=p
            ;;
        f)
            f=${OPTARG}
            KAFKA_REPLICATION_FACTOR=f
            ;;
        r)
            r=${OPTARG}
            KAFKA_RETENTION_MS=r
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Set defaults, if not defined.
KAFKA_CLI_IMAGE=${KAFKA_CLI_IMAGE:-dfdsdk/kafka-cli:0.1.1}
KAFKA_CONFIG=${KAFKA_CONFIG:-~/.ccloud/config}
KAFKA_BOOTSTRAP_SERVER=${KAFKA_BOOTSTRAP_SERVER:-pkc-l9pve.eu-west-1.aws.confluent.cloud:9092}
KAFKA_CLEANUP_POLICY=${KAFKA_CLEANUP_POLICY:-delete}
KAFKA_PARTITIONS=${KAFKA_PARTITIONS:-12}
KAFKA_REPLICATION_FACTOR=${KAFKA_REPLICATION_FACTOR:-3}
KAFKA_RETENTION_MS=${KAFKA_RETENTION_MS:-43200000} # 12 hours

function usage() {
    echo ""
    echo "Usage:" $(basename -- "$0") "<topic> [-c <delete|compact>] [-p <partitions>] [-f <replication factor>] [-r <retention in ms>]"
    echo ""
    echo "Options:"
    echo "  -c  Clean-up policy: delete or compact. Default: delete"
    echo "  -p  Topic partition count. Default: 12"
    echo "  -f  Topic replication factor. Default: 3"
    echo "  -r  Retention time. Default: 43200000 ms (12 hours)"
}

# As a minimum topic needs to be given as argument.
if [[ $# -eq 0 ]] ; then
    usage
    exit 1
fi

# Setting MSYS_NO_PATHCONV is for running bash on Windows, as it should not convert paths.

# Create topic.
MSYS_NO_PATHCONV=1 \
docker run --rm \
  --volume ${KAFKA_CONFIG}:/data/config \
  ${KAFKA_CLI_IMAGE} \
  kafka-topics.sh \
  --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} \
  --command-config /data/config \
  --create \
  --topic "$1" \
  --partitions ${KAFKA_PARTITIONS} \
  --replication-factor ${KAFKA_REPLICATION_FACTOR} \
  --config "cleanup.policy=${KAFKA_CLEANUP_POLICY}" \
  --config "retention.ms=${KAFKA_RETENTION_MS}"

# Describe topic just created.
MSYS_NO_PATHCONV=1 \
docker run --rm \
  --volume ${KAFKA_CONFIG}:/data/config \
  ${KAFKA_CLI_IMAGE} \
  kafka-topics.sh \
  --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} \
  --command-config /data/config \
  --describe \
  --topic "$1"