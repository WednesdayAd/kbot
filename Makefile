APP=$(shell basename $(shell git remote get-url origin))
REGISTRY := bentejna
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TERGETARCH=arm64
TARGETOS=linux

format:
		
		gofmt -s -w ./

lint:

		golint

test:
	
		go test -v
get:
	
		go get

build: format get
		CGO_EENABLED=0 GOOS=${TARGETOS} GOARCH=${TERGETARCH} go build -v -o kbot -ldflags "-X="github.com/WednesdayAd/kbot/cmd.appVersion=${VERSION}

image:
		docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TERGETARCH} --build-arg TARGETARCH=${TARGETARCH}

push:

		docker push ${REGISTRY}/${APP}:${VERSION}-${TERGETARCH}

clean:
	
		rm -rf kbot
		docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}