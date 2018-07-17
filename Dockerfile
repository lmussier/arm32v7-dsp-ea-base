FROM arm32v7/debian:buster-slim

#This Dockerfile is largely inspired by the resin base image https://raw.githubusercontent.com/resin-io-library/base-images/master/debian/armv7hf/buster/Dockerfile

ENV LC_ALL C.UTF-8

#https://docs.docker.com/engine/faq/#why-is-debian_frontendnoninteractive-discouraged-in-dockerfiles
#ENV DEBIAN_FRONTEND noninteractive

COPY qemu-arm-static /usr/bin/

# Resin-xbuild, o tool
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start &&\
	ln -s resin-xbuild /usr/bin/cross-build-end

RUN apt-get update &&\
	apt-get install -y --no-install-recommends\
	ca-certificates curl &&\
	rm -rf /var/lib/apt/lists/*
	
# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /tini
RUN chmod +x /tini && mv tini /sbin/tini

ENTRYPOINT ["/sbin/tini", "--"]