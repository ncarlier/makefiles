.SILENT :

# Define network name
NETWORK_NAME?=void

# Create Docker network
network-create:
	echo "Creating Docker network: ${NETWORK_NAME}..."
	-docker network create ${NETWORK_NAME}
.PHONY: network-create

# Remove Docker network
network-rm:
	echo "Removing Docker network: ${NETWORK_NAME}..."
	-docker network rm ${NETWORK_NAME}
.PHONY: network-rm

