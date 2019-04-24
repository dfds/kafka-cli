# kafka-cli
Official Kafka CLI tools dockerized, running on Alpine.

# Version
Currently Kafka CLI tools version 2.12-2.2.0 is included in the image.

# How to use
As an example, to describe a topic.

Locally against Kafka on Docker:
```bash
docker run --rm \
  --network <DOCKER NETWORK WHERE KAFKA CAN BE REACHED> \
  dfdsdk/kafka-cli:0.1.0 \
  kafka-topics.sh --zookeeper zookeeper:2181 \
  --describe --topic <TOPIC TO DESCRIBE>
```

Against Kafka on Confluent Cloud - assuming configuration file is located in ~/.ccloud/config:
```bash
docker run --rm \
  --volume ~/.ccloud/config:/data/config \
  dfdsdk/kafka-cli:0.1.0 \
  kafka-topics.sh \
  --bootstrap-server <CCLOUD BOOTSTRAP SERVER AND PORT> \
  --command-config /data/config \
  --describe --topic <TOPIC TO DESCRIBE>
```

## Wrapper scripts
To ease the use and not type in the long docker command each time, wrapper scripts is available under [scripts]().

TODO: Add scripts and describe usage.