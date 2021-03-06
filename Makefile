MASTER_IP=$(shell boot2docker ip)
SLAVE_IP=$(shell boot2docker ip)
ZK_MYID=1

MESOS_ZK=zk://$(MASTER_IP):2181/mesos
MESOS_MASTER=zk://$(MASTER_IP):2181/mesos
MARATHON_MASTER=zk://$(MASTER_IP):2181/marathon

VERSION=0.21.0-1.0.ubuntu1404
MARATHON_VERSION=0.8.1-1.0.171.ubuntu1404

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
	sed -e "s/MESOS_VERSION/$(VERSION)/g" -e "s/MARATHON_VERSION/$(MARATHON_VERSION)/g" dockerfiles/$@ > Dockerfile
	docker build -t s-urbaniak/$@:$(VERSION) .
	rm -f Dockerfile

mesos-slave: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfiles/$@ > Dockerfile
	docker build -t s-urbaniak/$@:$(VERSION) .
	rm -f Dockerfile

mesos-spark: mesos check-version
	sed "s/VERSION/$(VERSION)/g" dockerfiles/$@ > Dockerfile
	docker build -t s-urbaniak/$@:$(VERSION) .

start-master:
	docker run \
	--detach=true \
	--privileged \
	--net="host" \
	--name="master" \
	-e MESOS_IP=$(MASTER_IP) \
	-e MESOS_ZK=$(MESOS_ZK) \
	-e MESOS_QUORUM=1 \
	-e MESOS_WORK_DIR=/var/lib/mesos \
	-e MESOS_CLUSTER=mesoscluster \
	-e MESOS_MASTER=$(MESOS_MASTER) \
	-e MESOS_CONTAINERIZERS=mesos,docker \
	-e MARATHON_MASTER=$(MARATHON_MASTER) \
	-e MARATHON_ZK=$(MESOS_ZK) \
	-e ZK_MYID=$(ZK_MYID) \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /sys:/sys \
	s-urbaniak/mesos-master:$(VERSION)

start-slave:
	docker run \
	--detach=true \
	--privileged \
	--net="host" \
	--name="slave" \
	-e MESOS_IP=$(SLAVE_IP) \
	-e MESOS_WORK_DIR=/var/lib/mesos \
	-e MESOS_MASTER=$(MESOS_MASTER) \
	-e MESOS_CONTAINERIZERS=mesos,docker \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /sys:/sys \
	s-urbaniak/mesos-slave:$(VERSION)

start-spark:
	docker run \
	-ti --rm \
	--name="mesos-spark" \
	--net="host" \
	-e MASTER=mesos://$(MESOS_ZK) \
	-e SPARK_EXECUTOR_URI=http://$(MASTER_IP):8000/spark-1.3.1-bin-cdh4.tgz \
	s-urbaniak/mesos-spark:$(VERSION) \
	--class org.apache.spark.repl.Main \
	--master mesos://$(MASTER_IP):5050 \
	spark-shell

.PHONY: start-master start-slave
