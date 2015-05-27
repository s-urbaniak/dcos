#!/bin/bash

echo $@

# runsvdir-start clears environment variables
# initially export all variables (later reimport within /run file)
export > /env.bash

grep -q $MESOS_IP /etc/hosts || echo "$MESOS_IP $HOSTNAME" >>/etc/hosts

# start service
runsvdir -P /etc/service
