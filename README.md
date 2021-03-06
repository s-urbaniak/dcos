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

### master
To start the master image:

    $ make start-master MASTER_IP=w.x.y.z

where ``MASTER_IP`` is the IP address you want
to bind the master instance to.

*Note*: on OSX all variables (i.e. MASTER_IP)
can be ommitted.
They'll be queried via the boot2docker environment
automatically.

The container will start the following three
daemons using [runit](http://smarden.org/runit/):

1. zk: A zookeeper master instance
2. mesos-master: A mesos master instance
3. mesos-slave: A mesos slave instance
4. marathon: A marathon master instance

To query the general status of the above mentioned daemons:

    $ docker exec master sv status zk mesos-master mesos-slave marathon
    run: zk: (pid 15) 30691s; run: log: (pid 12) 30691s
    run: mesos-master: (pid 16) 30691s; run: log: (pid 14) 30691s
    run: mesos-slave: (pid 17) 30691s; run: log: (pid 13) 30691s
    run: marathon: (pid 18) 30691s; run: log: (pid 11) 30691s

See [sv(8)](http://smarden.org/runit/sv.8.html)
for other options.

To inspect the logs of a given daemon:

    $ docker exec master tail /var/log/mesos-master/current

Replace "mesos-master" with either "mesos-slave" or "zk"
to tail the logs from the other daemons.

### slave
To start the slave image:

    $ make start-slave MASTER_IP=w.x.y.z SLAVE_IP=a.b.c.d

where ``MASTER_IP`` is the IP address of the mesos master node
and ``SLAVE_IP`` the IP address you want to bind the slave instance to.

The container will start the following daemon:

1. mesos-slave: The mesos slave instance

Consult the usage of ``runit`` commands above
to inspect the slave's current status and logs.

