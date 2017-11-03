# Makefiles

## Description

My makefiles.

See README files under each folder for more details.

## Usage sample with Docker

Create a `.env` file:

```env
# General configuration
MACHINE_NAME=<Your machine name>

# Scaleway configuration
SCALEWAY_ORGANIZATION=<Your Scaleway organisation UUID>
SCALEWAY_TOKEN=<Your Scaleway token>
```

Create a `Makefile`:

```makefile
# Import custom configuration
include .env

# Docker compose configuration files
COMPOSE_FILES?=-f docker-compose.yml

# Include common Make tasks
root_dir:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
makefiles:=$(root_dir)/makefiles
include $(makefiles)/help.Makefile
include $(makefiles)/docker/machine.Makefile
include $(makefiles)/docker/compose.Makefile

## Setup the infrastructure
setup: machine-create machine-env
.PHONY : setup

## Teardown the infrastructure
teardown: compose-down machine-rm
.PHONY : teardown

## Deploy services
deploy: compose-up compose-logs
.PHONY : deploy

## Un-deploy services
undeploy: compose-down
.PHONY : undeploy

## Login with SSH
ssh: machine-ssh
.PHONY : ssh

```

Play:

```bash
$ # Create the Docker machine
$ make setup
$ # Switch Docker host
$ eval $(make machine-env)
$ # Get Docker Daemon infos
$ docker info
$ # Deploy services
$ make deploy
$ # Get Docker status
$ docker ps
$ # Teardown the Docker machine
$ make teardown
```

---
