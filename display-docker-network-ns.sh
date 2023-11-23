#!/bin/bash

# Create netns directory 
mkdir -p /var/run/netns

# Loop through running Docker containers
for i in $(docker ps -q); do

  # Get container PID
  PID=$(docker inspect -f '{{.State.Pid}}' $i)

  # Link netns 
  ln -sfT /proc/$PID/ns/net /var/run/netns/$i

done

# Now can view all namespaces
ip netns list
