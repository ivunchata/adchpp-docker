.PHONY: build publish run

IMAGE=adchpp
VERSION?=3.0.0
USER=ivunchata

build:
	docker build . --build-arg VERSION=$(VERSION) -t $(USER)/$(IMAGE):$(VERSION)

publish:
	docker push $(USER)/$(IMAGE):$(VERSION)

run:
	docker-compose up -d

run-build:
	docker-compose -f docker-compose.build.yml up --build
