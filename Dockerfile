ARG STRIMZI_BASE_IMAGE

 

FROM ${STRIMZI_BASE_IMAGE}

 

USER root

 
# Backup original /opt/kafka folder to /opt/kafka-strimzi
RUN mv /opt/kafka /opt/kafka-strimzi

# Transfer modified Java files from relative local kafka folder to /opt folder !WARN! overwrite original kafka folder
COPY kafka/ /opt/

# Copy original strimzi files at kafka root folder to new kafka root folder 
RUN cp /opt/kafka-strimzi/*.* /opt/kafka/.
