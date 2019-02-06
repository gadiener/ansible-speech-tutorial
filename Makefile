USER=gdiener
TAG=latest

.DEFAULT_GOAL := all

.PHONY: build
build:
	docker build -t ${USER}/ansible-speech-${IMAGE}:${TAG} -f ${IMAGE}/Dockerfile .

.PHONY: push
push:
	docker push ${USER}/ansible-speech-${IMAGE}:${TAG}

.PHONY: build_and_push
build_and_push: build push

.PHONY: build_all
build_all:
	IMAGE=host $(MAKE) build
	IMAGE=control $(MAKE) build

.PHONY: push_all
push_all:
	IMAGE=host $(MAKE) push
	IMAGE=control $(MAKE) push

.PHONY: all
all: build_all push_all