.SILENT :

# Define machine name
MACHINE_NAME?=void

# Define machine driver
MACHINE_DRIVER?=generic

# ########################################
# GENERIC CONFIGURATION
# ########################################

# Port to use for Docker Daemon
GENERIC_ENGINE_PORT?=2376

# IP Address of host
GENERIC_IP_ADDRESS?=$(TF_IP)

# SSH username used to connect
GENERIC_SSH_USER?=root

# Port to use for SSH
GENERIC_SSH_PORT?=22

# Define generic driver options
define machine_options_for_generic
--generic-engine-port=$(GENERIC_ENGINE_PORT) \
--generic-ip-address=$(GENERIC_IP_ADDRESS) \
--generic-ssh-user=$(GENERIC_SSH_USER) \
--generic-ssh-port=$(GENERIC_SSH_PORT)
endef

# ########################################
# SCALEWAY CONFIGURATION
# ########################################

# Define default Scaleway machine offer
SCALEWAY_COMMERCIAL_TYPE?=VC1S

# Define Scaleway driver options
define machine_options_for_scaleway
--scaleway-commercial-type="$(SCALEWAY_COMMERCIAL_TYPE)" \
--scaleway-organization="$(SCALEWAY_ORGANIZATION)" \
--scaleway-token="$(SCALEWAY_TOKEN)" \
--scaleway-name="$(MACHINE_NAME)"
endef

# Create docker machine
machine-create:
	echo "Building Docker machine $(MACHINE_NAME) with $(MACHINE_DRIVER) driver..."
	docker-machine create -d $(MACHINE_DRIVER) \
		$(machine_options_for_$(MACHINE_DRIVER)) \
		$(machine_extra_options_for_$(MACHINE_DRIVER)) \
		$(MACHINE_NAME)
.PHONY : machine-create

# Remove docker machine
machine-rm:
	echo "Removing Docker machine $(MACHINE_NAME)..."
	docker-machine rm -f $(MACHINE_NAME)
.PHONY : machine-rm

# Show Docker machine configuration
machine-env:
	docker-machine env --no-proxy $(MACHINE_NAME)
.PHONY : machine-env

# Log into the Docker machine
machine-ssh:
	docker-machine ssh $(MACHINE_NAME)
.PHONY : machine-ssh

