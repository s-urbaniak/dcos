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
