# Makefile to create splunk cluster
# Splunk Enterprise + Splunk Universal Forwarder

export SPLUNK_ES_CLUSTER_VERSION ?= 6.4.2
export SPLUNK_UF_CLUSTER_VERSION ?= 6.3.1
export SPLUNK_CLUSTER_DOCKER_IMAGE_PATH ?= splunk
export ES_COMPOSE_FILE ?= es.docker-compose.yml
export UF_COMPOSE_FILE ?= uf.docker-compose.yml

clean:
	docker-compose -f ${ES_COMPOSE_FILE} kill
	docker-compose -f ${ES_COMPOSE_FILE} rm -v -f
	docker-compose -f ${UF_COMPOSE_FILE} kill
	docker-compose -f ${UF_COMPOSE_FILE} rm -v -f

cleanps:
	docker ps -a -q | xargs -n 1 -I {} sudo docker rm {}
	#docker rmi $( sudo docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)

cleanImages:
	#Very Dangerous. Only for unit testing phase
	docker images | grep splunkes_ |  awk -F' ' '{print $3}' | xargs docker rmi -f {}
	docker images | grep splunkuf_ |  awk -F' ' '{print $3}' | xargs docker rmi -f {}

build:
	#docker tag $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/splunk:latest $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/splunk:$(SPLUNK_ES_CLUSTER_VERSION)
	docker-compose -f ${ES_COMPOSE_FILE}  build --force-rm 
	docker-compose -f ${UF_COMPOSE_FILE}  build --force-rm

push: build
	docker push $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/splunk:$(SPLUNK_ES_CLUSTER_VERSION)
	docker push $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/splunk:latest
	docker push $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/universalforwarder:$(SPLUNK_UF_CLUSTER_VERSION)
	docker push $(SPLUNK_CLUSTER_DOCKER_IMAGE_PATH)/universalforwarder:latest

deploy:
	docker-compose -f ${ES_COMPOSE_FILE} up -d
	docker-compose -f ${UF_COMPOSE_FILE} up -d
	@echo "Use 'docker-compose -f ${ES_COMPOSE_FILE} -f docker-compose.license-master.yml logs -f cluster-master-01' to wait for Initialized cluster-master as Cluster Master"
