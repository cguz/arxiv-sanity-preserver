SHELL := /bin/bash

cnfenv ?= .env
include $(cnfenv)
export $(shell sed 's/=.*//' $(cnfenv))

IMAGE_NAME=arxiv-sanity-preserver

build: ## build the Docker image
	docker build -t ${IMAGE_NAME}:latest .

run: ## run the image
	docker run -p 8081:8080 -p 27017:27017 -d --name ${IMAGE_NAME} ${IMAGE_NAME}

stop: ## stop the container
	docker stop ${IMAGE_NAME}

rm: ## remove the container
	docker rm ${IMAGE_NAME}

shell: ## open interactive shell
	docker exec -it ${IMAGE_NAME} /bin/bash

logs: ## container logs
	docker logs --follow ${IMAGE_NAME}

push: ## tag and push images to offops Azure container registry
	docker tag ${IMAGE_NAME}:latest ${AZURE_OFFOPS_CR}/${IMAGE_NAME}:latest
	docker push ${AZURE_OFFOPS_CR}/${IMAGE_NAME}:latest