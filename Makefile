USER=gdiener
TAG=latest

.DEFAULT_GOAL := all

build:
	docker build -t $(USER)/ansible-speech-${IMAGE}:${TAG} -f ${IMAGE}/Dockerfile .

push:
	docker push $(USER)/ansible-speech-${IMAGE}:${TAG}

build_and_push: build push

build_all:
	IMAGE=host $(MAKE) build
	IMAGE=control $(MAKE) build

push_all:
	IMAGE=host $(MAKE) push
	IMAGE=control $(MAKE) push

all: build_all push_all