APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ghcr.io/andrii-p-kovalchuk
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #arm64

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=${TARGETARCH}

macos:
	$(MAKE) build TARGETOS=darwin TARGETARCH=${TARGETARCH} 

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=${TARGETARCH}

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/Andrii-P-Kovalchuk/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}


