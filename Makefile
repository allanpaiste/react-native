# Copyright © Allan Paiste. All rights reserved.
# See LICENSE.txt for license details.
.DEFAULT_GOAL := help
.PHONY: help src sync enter sudo purge bootstrap start develop down

_seed_env := $(shell test ! -f .env && cat .env.dist|sed 's/{{UID}}/'$$(pwd|md5|cut -d ' ' -f1)'/g' > .env)
_seed_mutagen := $(shell test ! -f mutagen.tmpl.yml && cp mutagen.dist.yml mutagen.tmpl.yml)

define generate_mutagen_config
	export $$(echo $$(cat .env|grep -v '^#')) && \
		perl -p -e \
		's/\$$\{([^}]+)\}/defined $$ENV{$$1} ? $$ENV{$$1} : $$&/eg' \
		< mutagen.tmpl.yml > mutagen.yml
endef

help: ## Show this help (default)
	@echo "Usage: make [command] [args=\"\"] \n"
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-15s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

bootstrap: ## Generate project configuration files
	$(call generate_mutagen_config)

start: ## Build and Start the service
	make down
	docker-compose build
	docker-compose up -d

down: ## Shut down the running services
	make bootstrap
	command -v mutagen &>/dev/null && mutagen project terminate || exit 0
	docker-compose down

src: export TARGET = base
src: ## Build and Start base environment
	docker-compose build
	docker-compose up -d
	make sync

sync: ## Start synchronizing files between contaienr and HOST
	$(call generate_mutagen_config)
	command -v mutagen &>/dev/null && mutagen project terminate || exit 0
	command -v mutagen &>/dev/null && mutagen project start || exit 0

enter: export EUSER=node
enter: ## Enter the running app container as app user
	docker-compose exec -u ${EUSER} app which bash && docker-compose exec -u ${EUSER} app bash || docker-compose exec app sh
	
sudo: ## Enter the running app container as root user
	$(MAKE) enter EUSER=root

purge: # Remove all related volumes and networks
	make down
	docker-compose rm -vs app || exit 0
	source .env && docker volume ls --filter "name=$${COMPOSE_PROJECT_NAME}" -q|xargs docker volume rm || exit 0
	source .env && docker network ls --filter "name=$${COMPOSE_PROJECT_NAME}" -q|xargs docker network rm || exit 0

develop: export TARGET = base
develop: ## Prepare the environment for development
	docker-compose exec app yarn
	make sync
