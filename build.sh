#!/bin/bash

set -e
SCRIPT_PATH=$(dirname $(realpath $0))

# Docker image repo
# Artifactory
# REPOSITORY=dockerhub.rnd.amadeus.net:5002/kafka/sacp/strimzi/kafka
# Local Docker registry
REPOSITORY=dfollereau/kafka

 
# Adjusting the versions to format the base image name
STRIMZI_VERSION=0.23.0
SCALA_VERSION=2.13
KAFKA_VERSION=2.7.1
export STRIMZI_BASE_IMAGE=quay.io/strimzi/kafka:${STRIMZI_VERSION}-kafka-2.7.0
echo "STRIMZI_BASE_IMAGE= $STRIMZI_BASE_IMAGE"
 
# Extracting the newly built Kafka image from gradle
cp ./core/build/distributions/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz ../kafka_${SCALA_VERSION}-${KAFKA_VERSION}-SNAPSHOT.tgz
tar -xzf ../kafka_${SCALA_VERSION}-${KAFKA_VERSION}-SNAPSHOT.tgz
mkdir kafka
# Copy Kafka image to local kafka folder
mv ./kafka_${SCALA_VERSION}-${KAFKA_VERSION} ./kafka/kafka

# Mechanism in text file to store and Increase build number
BUILD_VERSION_FILE=build-${SCALA_VERSION}-${KAFKA_VERSION}-version.txt
echo "BUILD_VERSION_FILE= $BUILD_VERSION_FILE"
expr $(cat ${BUILD_VERSION_FILE}) + 1 > ${BUILD_VERSION_FILE}
BUILD_VERSION=$(cat ${BUILD_VERSION_FILE})
# Just a test adding a file to the image
# cp ${BUILD_VERSION_FILE} ./kafka/kafka
 
docker build . -t ${REPOSITORY}:${STRIMZI_VERSION}-kafka-${KAFKA_VERSION}.debug.${BUILD_VERSION} \
    --build-arg STRIMZI_BASE_IMAGE    

# Once docker image is built and stored in registry, local kafka folder can be deleted
rm -rf ./kafka
