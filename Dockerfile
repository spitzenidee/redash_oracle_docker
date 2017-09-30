FROM redash/redash:latest
MAINTAINER Michael Spitzer <professa@gmx.net>

USER root

# Oracle instantclient installation (ZIP archives need to be in the same directory as this Dockerfile)
ENV ORACLE_HOME=/usr/local/instantclient
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME

COPY instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/
COPY instantclient-jdbc-linux.x64-12.2.0.1.0.zip /tmp/
COPY instantclient-odbc-linux.x64-12.2.0.1.0.zip /tmp/
COPY instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/
COPY instantclient-sqlplus-linux.x64-12.2.0.1.0.zip /tmp/

RUN apt-get update  -y && \
    apt-get install -y unzip libaio-dev && \
    # install Oracle drivers / instantclient:
    unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    unzip /tmp/instantclient-jdbc-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    unzip /tmp/instantclient-odbc-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    unzip /tmp/instantclient-sqlplus-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
    ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so && \
    ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
    # clean up:
    apt-get clean -y && \
    rm /tmp/instantclient-* && \
    pip install cx_Oracle==5.2 && \
    # increase timeout of gunicorn query runners from 30s to 120s (in the "server" section of /app/bin/docker-entrypoint):
    sed -r 's/5000 --name/5000 --timeout 120 --name/' </app/bin/docker-entrypoint >/app/bin/docker-entrypoint_timeout && \
    mv /app/bin/docker-entrypoint_timeout /app/bin/docker-entrypoint

#Add REDASH ENV to add Oracle Query Runner
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle,redash.query_runner.python

USER redash
