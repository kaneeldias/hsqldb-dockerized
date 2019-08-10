FROM openjdk:11-slim

# Image Environment Variables
ENV HSQLDB_VERSION=2.5.0 \
    JAVA_VM_PARAMETERS= \
    HSQLDB_TRACE= \
    HSQLDB_SILENT= \
    HSQLDB_REMOTE= \
    HSQLDB_DATABASE_NAME= \
    HSQLDB_DATABASE_ALIAS= \
    HSQLDB_DATABASE_HOST= \
    HSQLDB_USER= \
    HSQLDB_PASSWORD= 

# Install Tooling
RUN apk add --update \
      ca-certificates \
      wget
      
# Install HSQLDB
RUN mkdir -p /opt/database && \
    mkdir -p /opt/hsqldb && \
    mkdir -p /scripts && \
    wget -O /opt/hsqldb/hsqldb.jar http://central.maven.org/maven2/org/hsqldb/hsqldb/${HSQLDB_VERSION}/hsqldb-${HSQLDB_VERSION}.jar && \
    wget -O /opt/hsqldb/sqltool.jar http://central.maven.org/maven2/org/hsqldb/sqltool/${HSQLDB_VERSION}/sqltool-${HSQLDB_VERSION}.jar

# Remove obsolete packages
RUN apk del \
      ca-certificates \
      wget

# Clean caches and tmps
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*

VOLUME ["/opt/database","/scripts"]
EXPOSE 9001

WORKDIR /scripts
COPY imagescripts/docker-entrypoint.sh /opt/hsqldb/docker-entrypoint.sh
ENTRYPOINT ["/opt/hsqldb/docker-entrypoint.sh"]
CMD ["hsqldb"]
