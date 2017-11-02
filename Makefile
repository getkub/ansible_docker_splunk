# Makefile to create splunk cluster
# Splunk Enterprise + Splunk Universal Forwarder

export SPLUNK_CLUSTER_DOCKER_IMAGE_PATH ?= splunk
export PROJECT_NAME ?= docker_splunk
export BASE_PATH ?= /tmp/jinja
export COMPOSE_NAME ?= splunk.docker-compose.yml
COMPOSE_FILE := $(BASE_PATH)/$(PROJECT_NAME)/$(COMPOSE_NAME)

export COMPOSE_FILE  

clean:
	docker-compose -f ${COMPOSE_FILE} kill
	docker-compose -f ${COMPOSE_FILE} rm -v -f

cleanps:
	docker ps -a -q | xargs -n 1 -I {} sudo docker rm {}
	#docker rmi $( sudo docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)

cleanImages:
	#Very Dangerous. Only for unit testing phase
	docker images | grep splunk-es_ |  awk -F' ' '{print $$1}' | xargs -I {} docker rmi -f {}
	docker images | grep splunk-uf_ |  awk -F' ' '{print $$1}' | xargs -I {} docker rmi -f {}

build:
	#docker tag $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/splunk:latest $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/splunk:$(SPLUNK_ES_CLUSTER_VERSION)
	scripts/createApps.sh 
	scripts/composeGenerator.sh
	docker-compose -f ${COMPOSE_FILE}  build  

deploy:
	docker-compose -f ${COMPOSE_FILE} up -d
	@echo "Use 'docker-compose -f ${COMPOSE_FILE} -f docker-compose.license-master.yml logs -f cluster-master-01' to wait for Initialized cluster-master as Cluster Master"
