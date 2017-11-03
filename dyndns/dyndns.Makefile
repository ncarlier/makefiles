.SILENT :

# Define DynDNS service URL (OVH)
DYNDNS_URL=https://www.ovh.com/nic/update?system=dyndns&hostname=$(FQDN)

## Update DynDNS entry
dyndns:
	echo "Update DynDNS entry..."
	curl --user "$(DYNDNS_USER):$(DYNDNS_PASSWORD)" \
		"$(DYNDNS_URL)&myip=$(shell docker-machine ip ${MACHINE_NAME})"
.PHONY : dyndns

