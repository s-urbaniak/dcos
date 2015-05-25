MASTER_IP=$(shell boot2docker ip)
VERSION=0.21.0-1.0.ubuntu1404

all: help

help:
	@echo 'Options available:'
	@echo '  make images VERSION=0.20.1-1.0.ubuntu1404'
	@echo '  make push   VERSION=0.20.1-1.0.ubuntu1404'
	@echo ''
	@echo 'VERSION should be set to the full Ubuntu 14.04 Mesos package version'

check-version:
ifndef VERSION
	@echo "Error: VERSION is undefined."
	@make --no-print-directory help
	@exit 1
endif

images: check-version mesos mesos-master mesos-slave

push: check-version
	docker push mesosphere/mesos:$(VERSION)
	docker push s-urbaniak/mesos-master:$(VERSION)
	docker push s-urbaniak/mesos-slave:$(VERSION)

mesos: check-version
	sed "s/VERSION/$(VERSION)/g" dockerfiles/$@ > Dockerfile
	docker build -t mesosphere/$@:$(VERSION) .
	rm -f Dockerfile

mesos-master: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfiles/$@ > Dockerfile
	docker build -t s-urbaniak/$@:$(VERSION) .
	rm -f Dockerfile

mesos-slave: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfiles/$@ > Dockerfile
	docker build -t s-urbaniak/$@:$(VERSION) .
	rm -f Dockerfile

start-master:
	docker run \
	--net="host" \
	--rm \
	--name=mesos-master \
	-e MESOS_MASTER_IP=$(MASTER_IP) \
	s-urbaniak/mesos-master:$(VERSION)

.PHONY: start-master

