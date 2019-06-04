# kafka-cli
Official Kafka CLI tools dockerized, running on Alpine.

Docker image can be found on [DockerHub](https://hub.docker.com/r/dfdsdk/kafka-cli).

# Version
Currently Kafka CLI tools version 2.12-2.2.0 is included in the image.

# How to use
As an example, to describe a topic.

Locally against Kafka on Docker:
```bash
docker run --rm \
  --network <DOCKER NETWORK WHERE KAFKA CAN BE REACHED> \
  dfdsdk/kafka-cli:0.1.1 \
  kafka-topics.sh --zookeeper <zookeeper name on docker network>:2181 \
  --describe --topic <TOPIC TO DESCRIBE>
```

Against Kafka on Confluent Cloud - **assuming configuration file is located in ~/.ccloud/config**:
```bash
docker run --rm \
  --volume ~/.ccloud/config:/data/config \
  dfdsdk/kafka-cli:0.1.1 \
  kafka-topics.sh \
  --bootstrap-server <CCLOUD BOOTSTRAP SERVER AND PORT> \
  --command-config /data/config \
  --describe --topic <TOPIC TO DESCRIBE>
```

## Wrapper scripts
To ease the use and not type in long docker commands each time, wrapper scripts is available under [scripts](https://github.com/dfds/kafka-cli/tree/master/scripts).

For alle scripts following environment variables can be set to override defaults:
```
KAFKA_CLI_IMAGE         - Default: dfdsdk/kafka-cli:<tag>
KAFKA_CONFIG            - Default: ~/.ccloud/config
KAFKA_BOOTSTRAP_SERVER  - Default: pkc-l9pve.eu-west-1.aws.confluent.cloud:9092
```

### *listKafkaTopics.sh*
Lists topics.

```bash
./scripts/listKafkaTopics.sh
```

### *createKafkaTopic.sh*
Create topic.

```bash
./scripts/createKafkaTopic.sh <topic> [-c <delete|compact>] [-p <partitions>] [-f <replication factor>] [-r <retention in ms>]

Options:
  -c  Clean-up policy: delete or compact. Default: delete
  -p  Topic partition count. Default: 12
  -f  Topic replication factor. Default: 3
  -r  Retention time in ms. Default: 43200000 ms (12 hours)
```

### *deleteKafkaTopic.sh*
Delete topic.

```bash
./scripts/deleteKafkaTopic.sh <topic>
```

### *listKafkaConsumers.sh*
Lists consumer groups.

```bash
./scripts/listKafkaConsumers.sh
```

### *describeKafkaConsumerGroup.sh*
Describe consumer group to see topics, partitions, offsets, consumer lag, etc.

```bash
./scripts/describeKafkaConsumerGroup.sh <consumer group>
```

### *deleteKafkaConsumer.sh*
Delete consumer group.

```bash
./scripts/deleteKafkaConsumer.sh <consumer group>
```
