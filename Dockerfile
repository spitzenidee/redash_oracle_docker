FROM redash/redash:latest
MAINTAINER Michael Spitzer <professa@gmx.net>

#######################################################################
# DockerHub / GitHub:
# https://github.com/spitzenidee/redash_oracle_docker
# ...
#######################################################################

# Define proxy ENVs (if needed)
#ENV FTP_PROXY=http://http.proxy.net:8765
#ENV HTTPS_PROXY=$FTP_PROXY
#ENV HTTP_PROXY=$FTP_PROXY
#ENV ftp_proxy=$FTP_PROXY
#ENV http_proxy=$FTP_PROXY
#ENV https_proxy=$FTP_PROXY

# Install the Oracle client
WORKDIR /oracle_client
COPY instantclient.tgz .
RUN tar xzvf instantclient.tgz

ENV ORACLE_HOME=/oracle_client/instantclient
WORKDIR $ORACLE_HOME
RUN ln -s libclntsh.so.12.1 libclntsh.so
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME

#######################################################################
# Install the requirements for Oracle Instantclient / cx_oracle::
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        libffi-dev \
        libffi6\
        libsasl2-2 \
        libsasl2-dev
RUN pip install \
        cx_oracle
