CONTAINER_DB=PenBox
IMAGE_DB=penbox
USER=lovebug
HOSTNAME=penbox
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
EXIST=`docker images -q penbox 2> /dev/null`

help: ## Display commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[34m%-30s\033[0m %s\n", $$1, $$2}'

# Create the authority file and make it used by xauth
xauth:
	@touch $(XAUTH)
	@xauth nlist $(DISPLAY) | sed -e "s/^..../ffff/" | xauth -f $(XAUTH) nmerge -

# Build the image if not exist
build:
	@if [ -z "$(EXIST)" ]; then \
		docker build -t $(IMAGE_DB) .; \
	else \
		echo 'The PenBox image: `$(IMAGE_DB)` is already build'; \
	fi

# Create the container
create: xauth
	@docker create --name=$(CONTAINER_DB) -h $(HOSTNAME) -it --network="host" --volume=$(XSOCK):$(XSOCK):rw --volume=$(XAUTH):$(XAUTH):rw --env="XAUTHORITY=${XAUTH}" --env="DISPLAY" --user="${USER}" $(IMAGE_DB) bash

# Start the container
start:
	@docker start $(CONTAINER_DB)

# Stop the container
stop:
	@docker stop $(CONTAINER_DB)

# Remove the container
rm:
	@docker rm -f $(CONTAINER_DB)

# Remove the image
rmi:
	@docker rmi -f $(IMAGE_DB)

remove: rm rmi ## Remove the PenBox container and his image
	@echo -e '\e[33;1mThe docker container $(CONTAINER_DB) and image $(IMAGE_DB) has been removed\e[0m'

launch: build create start ## Build and create your PenBox container from scratch
	@echo -e '\e[33;1mThe docker container $(CONTAINER_DB) is started\e[0m'

reset: rm create start ## Reset your PenBox container
	@echo -e '\e[33;1mThe PenBox container $(CONTAINER_DB) has been reset\e[0m'

attach: xauth ## Get the CLI of PenBox
	@docker exec -it $(CONTAINER_DB) bash
