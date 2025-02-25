.SILENT:
.PHONY: help

# Based on https://gist.github.com/prwhite/8168133#comment-1313022

## This help screen
help:
	printf "Available commands\n\n"
	awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "\033[33m%-40s\033[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

PHP_EXECUTABLE = php
PHP_OPTIONS = -ddisplay_errors=0 -derror_reporting=22519
PHP_EXEC = $(PHP_EXECUTABLE) $(PHP_OPTIONS)
PAGE_GENERATOR_EXEC = $(PHP_EXEC) ./vendor/bin/spg.phar
LOCAL_SERVER = 127.0.0.1:8087
DOC_ROOT = ./docs

## Generate all static files
generate: generate-pages generate-sitemap generate-search-index
.PHONY: generate

## Generate static pages
generate-pages:
	$(PAGE_GENERATOR_EXEC) generate:pages
.PHONY: generate-pages

## Generate static sitemap
generate-sitemap:
	$(PAGE_GENERATOR_EXEC) generate:sitemap
.PHONY: generate-sitemap

## Generate static search-index
generate-search-index:
	$(PAGE_GENERATOR_EXEC) generate:search-index
.PHONY: generate-search-index

## Check links in generated pages locally
check-links-locally:
	$(PAGE_GENERATOR_EXEC) check:links -g -b http://127.0.0.1:8087 ./Project.json
.PHONY: check-links-locally

## Serve local website
serve:
	$(PHP_EXECUTABLE) -S $(LOCAL_SERVER) -t $(DOC_ROOT)
.PHONY: serve