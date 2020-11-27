FROM ubuntu:latest AS builder

ENV URL https://dl.google.com/go/go1.15.5.linux-amd64.tar.gz

ENV GOPATH /golang
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin/
RUN mkdir -p ${GOPATH}/bin && \
    mkdir -p ${GOPATH}/pkg && \
    mkdir -p ${GOPATH}/src
RUN apt-get update -y && \
    apt-get install -y \
    curl \
    git \
    unzip

## install go binary
RUN curl -L $URL -o /tmp/golang.tar.gz && \
    tar -C /usr/local -xzf /tmp/golang.tar.gz


ENV PROTO_VERSION 3.14.0
ENV URL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/protoc-${PROTO_VERSION}-linux-x86_64.zip

RUN curl -L ${URL} -o /tmp/protoc.zip && \
    unzip /tmp/protoc.zip -d /usr/local/ -x readme.txt && \
    chmod +x /usr/local/bin/protoc

## gopls
RUN go get -v golang.org/x/tools/gopls

## go bins 
RUN go get -u github.com/golang/protobuf/protoc-gen-go

## grpc web extension
ENV GRPC_WEB_VERSION 1.2.1
ENV GRPC_WEB https://github.com/grpc/grpc-web/releases/download/${GRPC_WEB_VERSION}/protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64
RUN curl ${GRPC_WEB} -o /usr/local/bin/protoc-gen-grpc-web && \
    chmod +x /usr/local/bin/protoc-gen-grpc-web

## cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*