FROM ubuntu:latest AS go_base

ENV URL https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz

ENV GOPATH /golang
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin/
RUN mkdir -p ${GOPATH}/bin && \
    mkdir -p ${GOPATH}/pkg && \
    mkdir -p ${GOPATH}/src
RUN apt-get update -y && \
apt-get install -y \
curl \
git

## install go binary
RUN curl -L $URL -o /tmp/golang.tar.gz && \
    tar -C /usr/local -xzf /tmp/golang.tar.gz

## cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*

FROM go_base AS protoc

ENV PROTO_VERSION 3.11.4
ENV URL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/protobuf-all-${PROTO_VERSION}.tar.gz

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    libtool \
    make \
    g++ \
    unzip

RUN curl -L ${URL} -o /tmp/protoc.tar.gz && \
    tar -C /tmp/ -zxvf /tmp/protoc.tar.gz && \
    cd /tmp/protobuf-${PROTO_VERSION} && \
    ./configure && \
    make && \
    make check && \
    make install && \
    ldconfig

## go bins 
RUN go get -u github.com/golang/protobuf/protoc-gen-go

## cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*