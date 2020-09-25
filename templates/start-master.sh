#!/bin/bash

for i in {1..5}
do
   if [ "$(./status.sh |grep Acknowledge -wc)" == "{{ nodes - 1}}" ] ; then
   	  echo "Workers ready: Starting master..."
      ./start-node.sh --master
   else
   	  echo "Waiting for workers to start..."
   fi
   sleep 2
done