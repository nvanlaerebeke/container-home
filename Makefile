.PHONY: build container push

SOURCEDIR:=$(shell pwd)
REGISTRY:=registry.crazyzone.be
TAG:=latest
NAME:=home

ifeq ($(NAME),)
	echo "NAME not set"
	exit 1
endif

ifeq ($(TAG),)
	echo "TAG not set"
	exit 1
endif

ifeq ($(REGISTRY),)
FULLNAME:=$(NAME):$(TAG)
else
FULLNAME:=$(REGISTRY)/$(NAME):$(TAG)
endif

container:
	docker build . -t "$(FULLNAME)"
run: container
	docker run --rm -p 80:80 --name home  "$(FULLNAME)" 

push: container
	docker push "$(FULLNAME)"
