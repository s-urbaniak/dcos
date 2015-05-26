# DCOS

This repository holds images for a small data center operating system.

## Overview

This project is able to bootstrap the following containers:

- **master**: A master image containing a mesos master,
a mesos slave and a zookeeper instance.
- **slave**: A slave image containing a mesos slave instance.

## Prerequsites

- Linux (or boot2docker - OSX only)
- Docker (recent version)

## Usage

To build the images:

    $ make mesos-master mesos-slave

*Note*: on OSX all variables (i.e. MASTER_IP)
can be ommitted.
They'll be queried via the boot2docker environment
automatically.

### master
To start the master image:

    $ make start-master MASTER_IP=w.x.y.z

where ``MASTER_IP`` is the IP address you want
to bound the master image to.

The container will start the following three
daemons using [runit](http://smarden.org/runit/):

1. mesos-master: A mesos master instance
2. mesos-slave: A mesos slave instance
3. zk: A zookeeper master instance

To query the general status of the above mentioned daemons:

    $ docker exec master sv status mesos-master mesos-slave zk
    run: mesos-master: (pid 12) 591s; run: log: (pid 10) 591s
    run: mesos-slave: (pid 13) 591s; run: log: (pid 9) 591s
    run: zk: (pid 14) 591s; run: log: (pid 11) 591s

See [sv(8)](http://smarden.org/runit/sv.8.html)
for other options.

To inspect the logs of a given daemon:

    $ docker exec master tail /var/log/mesos-master/current

Replace "meosos-master" with either "mesos-slave" or "zk"
to tail the logs from the other daemons.

