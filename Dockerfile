FROM ubuntu:14.04
MAINTAINER Michal Raczka me@michaloo.net

# install curl and fluentd deps
RUN apt-get update \
    && apt-get install -y curl libcurl4-openssl-dev ruby ruby-dev make

# install fluentd with plugins
RUN gem install fluentd fluent-plugin-elasticsearch --no-ri --no-rdoc \
    && mkdir /etc/fluentd/

# install docker-gen
RUN cd /usr/local/bin \
    && curl -L https://github.com/jwilder/docker-gen/releases/download/0.4.0/docker-gen-linux-amd64-0.4.0.tar.gz \
    | tar -xzv

# add startup scripts and config files
ADD ./bin    /app/bin
ADD ./config /app/config

WORKDIR /app

ENV ES_HOST localhost
ENV ES_PORT 9200
ENV LOG_ENV production
ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/app/bin/start" ]
