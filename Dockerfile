FROM java:8-jre-alpine

ENV KAFKA_VERSION=2.3.0
ENV KAFKA_URL=http://www-eu.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.12-${KAFKA_VERSION}.tgz
ENV KAFKA_TMP_DEST=/opt/kafka.tgz
ENV KAFKA_WORKDIR=/opt/kafka

RUN apk add --update --no-cache bash tar

ADD run.sh /opt/run.sh

RUN chmod +x /opt/run.sh && \
    wget $KAFKA_URL -O ${KAFKA_TMP_DEST} && \
    mkdir -p ${KAFKA_WORKDIR} && \
    tar -xvzpf ${KAFKA_TMP_DEST}  --strip-components=1 -C ${KAFKA_WORKDIR} && \
    rm -rf ${KAFKA_TMP_DEST} && \
    rm -rf /var/cache/apk/*

WORKDIR [ "/opt" ]
ENTRYPOINT [ "/opt/run.sh" ]