FROM ubuntu:14.04
MAINTAINER Nelson Hernandez nelson@meetearnest.com

#install apt tools for adding repositories
RUN apt-get update
RUN apt-get install -y --force-yes curl software-properties-common python-software-properties

#install apt repository for easily installing native ruby's
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update

#fluent plugsins below depened on ruby2.0 and ruby2.0-dev specifically.
RUN apt-get -y install ruby2.0 ruby2.0-dev ruby-switch make g++
RUN ruby-switch --set ruby2.0

# install fluentd with plugins
RUN gem install fluentd fluent-plugin-cloudwatch-logs fluent-plugin-kubernetes_metadata_filter --no-ri --no-rdoc \
    && mkdir /etc/fluentd/

# add startup scripts and config files
ADD ./bin    /app/bin
ADD ./config /app/config

WORKDIR /app


RUN cd /usr/local/bin \
   && curl -L https://github.com/jwilder/docker-gen/releases/download/0.4.0/docker-gen-linux-amd64-0.4.0.tar.gz \
    | tar -xzv

ENV ES_HOST localhost
ENV ES_PORT 9200
ENV LOG_ENV production
ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/app/bin/start" ]
