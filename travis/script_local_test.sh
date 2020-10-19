#!/bin/bash

set -e

distribution=$1
version=$2

## Before Test
sudo docker pull ${distribution}:${version}
sudo docker build --file=travis/Dockerfile.${distribution}-${version} --tag=${distribution}-${version}:ansible travis

## Test
container_id=$(mktemp)
sudo docker run --env ANSIBLE_FORCE_COLOR=1 --env GCP_PROJECT="${GCP_PROJECT}" --env GCS_BUCKET="${GCS_BUCKET}" --env GCS_PREFIX="${GCS_PREFIX}" --env GCP_SERVICE_ACCOUNT="${GCP_SERVICE_ACCOUNT}" \
    --detach --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume="${PWD}":/etc/ansible/roles/ansible-indexima-install:ro \
    ${distribution}-${version}:ansible > "${container_id}"
  
sudo docker exec "$(cat ${container_id})" bash -c 'cd /etc/ansible/roles/ansible-indexima-install && molecule test -s local'

## Cleanup
# sudo docker rm --force "$(cat ${container_id})"