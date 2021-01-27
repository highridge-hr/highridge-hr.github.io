THIS := $(realpath $(lastword $(MAKEFILE_LIST)))
HERE := $(shell dirname $(THIS))
NAME := $(if $(name),$(name),$(shell basename $(HERE)))
IMAGE := $(NAME):$(if $(tag),$(tag),latest)
REGISTRY := $(if $(registry),$(registry),)

JEKYLL_VERSION := 3.8
PORT := 4000

.PHONY: serve
serve: container/build
	docker run --rm --name $(NAME) -it -v "$(HERE):/srv/jekyll" -p 127.0.0.1:$(PORT):4000 $(IMAGE) -- \
		jekyll serve

.PHONY: build
build: container/build
	docker run --rm --name $(NAME) -it -v "$(HERE):/srv/jekyll" -p 127.0.0.1:$(PORT):4000 $(IMAGE) -- \
		jekyll build

.PHONY: clean
clean: container/build
	docker run --rm --name $(NAME) -it -v "$(HERE):/srv/jekyll" -p 127.0.0.1:$(PORT):4000 $(IMAGE) -- \
		jekyll clean

.PHONY: shell
shell: container/build
	docker run --rm --name $(NAME) -it -v "$(HERE):/srv/jekyll" -p 127.0.0.1:$(PORT):4000 $(IMAGE) -- \
		bash

.PHONY: container/build
container/build:
	docker build --tag $(IMAGE) $(HERE)

.PHONY: container/clean
container/clean:
	$(if $(shell docker images -q $(NAME)), docker images -q $(NAME) | xargs docker rmi -f || true)
