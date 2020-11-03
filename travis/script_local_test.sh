#!/bin/bash

set -e

distribution=$1
version=$2

## Before Test
sudo docker pull ${distribution}:${version}
sudo docker build --file=travis/Dockerfile.${distribution}-${version} --tag=${distribution}-${version}:ansible travis

## Test
container_id=$(mktemp)
sudo docker run --detach --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume="${PWD}":/etc/ansible/roles/ansible-indexima-install:ro \
    ${distribution}-${version}:ansible > "${container_id}"

sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 bash -c 'cd /etc/ansible/roles/ansible-indexima-install && molecule test -s local'

## Cleanup
sudo docker rm --force "$(cat ${container_id})"