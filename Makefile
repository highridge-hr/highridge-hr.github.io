THIS := $(realpath $(lastword $(MAKEFILE_LIST)))
HERE := $(shell dirname $(THIS))
NAME := $(if $(name),$(name),$(shell basename $(HERE)))
IMAGE := $(NAME):$(if $(tag),$(tag),latest)
REGISTRY := $(if $(registry),$(registry),)
SITE_ROOT := $(HERE)/docs

JEKYLL_VERSION := 3.8
PORT := 4000

.PHONY: serve
serve: container/build
	docker run --rm --name $(NAME) -it -v "$(SITE_ROOT):/srv/jekyll" -p 127.0.0.1:$(PORT):4000 $(IMAGE) -- \
		sh -c 'jekyll clean && jekyll serve'

.PHONY: build
build: container/build
	docker run --rm --name $(NAME) -it -v "$(SITE_ROOT):/srv/jekyll" $(IMAGE) -- \
		jekyll build

.PHONY: clean
clean: container/build
	docker run --rm --name $(NAME) -it -v "$(SITE_ROOT):/srv/jekyll" $(IMAGE) -- \
		jekyll clean

.PHONY: deps/install
deps/install: container/build
	docker run --rm --name $(NAME) -it -v "$(SITE_ROOT):/srv/jekyll" $(IMAGE) -- \
		/usr/local/bundle/bin/bundle install --gemfile /srv/jekyll/Gemfile --clean

.PHONY: deps/update
deps/update: container/build
	docker run --rm --name $(NAME) -it -v "$(SITE_ROOT):/srv/jekyll" $(IMAGE) -- \
		/usr/local/bundle/bin/bundle update --gemfile /srv/jekyll/Gemfile $(if $(TARGET),$(TARGET),--all)

.PHONY: shell
shell: container/build
	docker run --rm --name $(NAME) -it -v "$(SITE_ROOT):/srv/jekyll" -p 127.0.0.1:$(PORT):4000 $(IMAGE) -- \
		bash

.PHONY: container/build
container/build:
	docker build --tag $(IMAGE) $(HERE)

.PHONY: container/clean
container/clean:
	$(if $(shell docker images -q $(NAME)), docker images -q $(NAME) | xargs docker rmi -f || true)
