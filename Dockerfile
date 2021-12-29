FROM ubuntu:latest AS builder

ENV GO_URL https://dl.google.com/go/go1.17.5.linux-amd64.tar.gz

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
RUN curl -L ${GO_URL} -o /tmp/golang.tar.gz && \
    tar -C /usr/local -xzf /tmp/golang.tar.gz


ENV PROTO_VERSION 3.19.1
ENV PROTO_URL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/protoc-${PROTO_VERSION}-linux-x86_64.zip

RUN curl -L ${PROTO_URL} -o /tmp/protoc.zip && \
    unzip /tmp/protoc.zip -d /usr/local/ -x readme.txt && \
    chmod +x /usr/local/bin/protoc

ENV BUF_VERSION 1.0.0-rc10
RUN curl -L \
    https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-Linux-$(uname -m) \
    -o "/usr/local/bin/buf" && \
  chmod +x "/usr/local/bin/buf"

## gopls
RUN go get -v golang.org/x/tools/gopls

## go bins 
RUN go get -v github.com/golang/protobuf/protoc-gen-go && \
	go get -v google.golang.org/grpc/cmd/protoc-gen-go-grpc && \
	go get -v github.com/grpc/grpc-web

## cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*
