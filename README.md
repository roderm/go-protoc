# go-protoc
Dockerimage with golang compiler and protoc to build binaries form gocode and proto-buf files.

## Usage
Example Dockerfile in $GOPATH:
```
FROM roderm/go-protoc:latest as builder
WORKDIR $GOPATH/src/github.com/roderm/go-app
COPY ./* ./*
## get packages
RUN go get 
## generate protocs
RUN find ./ -type f -name *.proto -exec \
     protoc \
     --proto_path=${GOPATH}/src:. \
     --go_out=${GOPATH}/src \
     {} \;

## build it
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /out/go-app -ldflags '-w -s' main.go

## Build a new Image from scratch
FROM scratch as final
COPY --from=builder /out/go-app /app/run
ENTRYPOINT [/app/run]
```