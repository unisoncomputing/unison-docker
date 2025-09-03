version := 0.5.47
docker_username := unisonlang
docker_image := unisonlang/unison
arch:=$(shell uname -m | sed 's/aarch64/arm64/;s/x86_64/amd64/')
docker_tag := $(docker_image):$(version)-$(arch)
docker_latest := $(docker_image):latest-$(arch)

.PHONY: all build push

build: Dockerfile Makefile
	docker build -t $(docker_tag) --build-arg UCM_VERSION=$(version) .
	docker tag $(docker_tag) $(docker_latest)

push: build
	docker login -u $(docker_username) -p ${docker_password}
	docker push $(docker_tag)
	docker push $(docker_latest)

stitch: AMD_TAG=${docker_image}:${version}-amd64
stitch: ARM_TAG=${docker_image}:${version}-arm64
stitch: STITCH_TAG=${docker_image}:${version}
stitch: arm_digest=$(shell docker buildx imagetools inspect ${ARM_TAG} --format '{{json .Manifest}}' | jq -r .digest)
stitch: amd_digest=$(shell docker buildx imagetools inspect ${AMD_TAG} --format '{{json .Manifest}}' | jq -r .digest)
stitch:
	docker buildx imagetools create -t ${STITCH_TAG} ${AMD_TAG}@${amd_digest} ${ARM_TAG}@${arm_digest}

all: build push
