.SILENT :

# Docker compose configuration files
COMPOSE_FILES?=-f docker-compose.yml

# Stack name
STACK?=default

# Wait until a service ($$service) is up and running (needs health run flag)
stack-service-wait:
	service=$(STACK)_$(service); \
	sid=`docker service ps $${service} -q | head -1`; \
	cid=`docker inspect --format "{{.Status.ContainerStatus.ContainerID }}" $${sid}`;\
	n=30;\
	while [ $${n} -gt 0 ] ; do\
		status=`docker inspect --format "{{json .State.Health.Status }}" $${cid}`;\
		if [ -z $${status} ]; then echo "No status informations."; exit 1; fi;\
		echo "Waiting for $(service) up and ready ($${status})...";\
		if [ "\"healthy\"" = $${status} ]; then exit 0; fi;\
		sleep 2;\
		n=`expr $$n - 1`;\
	done;\
	echo "Timeout" && exit 1
.PHONY: stack-service-wait

# Deploy Docker stack
stack-deploy:
	echo "Deploying Docker stack ($(STACK))..."
	-cat .env
	docker stack deploy --compose-file=<(docker-compose $(COMPOSE_FILES) config) $(STACK)
.PHONY: stack-deploy

# Un-deploy Docker stack
stack-rm:
	echo "Un-deploying Docker stack ($(STACK))..."
	@while [ -z "$$CONTINUE" ]; do \
		read -r -p "Are you sure? [y/N]: " CONTINUE; \
	done ; \
	[ $$CONTINUE = "y" ] || [ $$CONTINUE = "Y" ] || (echo "Exiting."; exit 1;)
	docker stack rm $(STACK)
	echo "Docker stack \"$(STACK)\" un-deployed."
.PHONY: stack-rm

# Un-deploy Docker stack (without user confirmation)
stack-rm-force:
	echo "Un-deploying Docker stack ($(STACK))..."
	docker stack rm $(STACK)
	echo "Docker stack \"$(STACK)\" un-deployed."
.PHONY: stack-rm-force

# View stack logs
stack-logs:
	echo "Viewing stack logs ..."
	docker service logs -f $(STACK)
.PHONY: stack-logs

# View stack status
stack-ps:
	echo "Viewing stack status ..."
	docker stack ps $(STACK)
.PHONY: stack-ps

# View stack services
stack-services:
	echo "Viewing stack services ..."
	docker stack services $(STACK)
.PHONY: stack-services

