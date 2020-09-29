#!/bin/bash

### Travis script in sh file for local testing
### Needs to be executed in the root directory of the role

## Env

distribution=ubuntu
version=bionic

## Before Test
sudo docker pull ${distribution}:${version}
sudo docker build --file=travis/Dockerfile.${distribution}-${version} --tag=${distribution}-${version}:ansible travis


container_id=$(mktemp)
sudo docker run --detach --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume="${PWD}":/etc/ansible/roles/ansible-indexima-install:ro \
    ${distribution}-${version}:ansible > "${container_id}"
  
sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook -v \
 /etc/ansible/roles/ansible-indexima-install/tests/test.yml -i /etc/ansible/roles/ansible-indexima-install/examples/hosts.local --syntax-check
  
sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
    -v /etc/ansible/roles/ansible-indexima-install/tests/test.yml -i /etc/ansible/roles/ansible-indexima-install/examples/hosts.local

sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
  -v /etc/ansible/roles/ansible-indexima-install/tests/test.yml -i /etc/ansible/roles/ansible-indexima-install/examples/hosts.local -t "conf" \
  | grep -q "changed=0.*failed=0" \
    && (echo "Idempotence test: pass" && exit 0) \
    || (echo "Idempotence test: fail" && exit 1)

sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
  -v /etc/ansible/roles/ansible-indexima-install/tests/test.yml -i /etc/ansible/roles/ansible-indexima-install/examples/hosts.local -t "istart" \
  | grep -q "changed=0.*failed=0" \
    && (echo "Idempotence test: pass" && exit 0) \
    || (echo "Idempotence test: fail" && exit 1)
  
sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
  -v /etc/ansible/roles/ansible-indexima-install/tests/test.yml -i /etc/ansible/roles/ansible-indexima-install/examples/hosts.local -t "istop"
  
sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
  -v /etc/ansible/roles/ansible-indexima-install/tests/test.yml -i /etc/ansible/roles/ansible-indexima-install/examples/hosts.local -t "istop" \
  | grep -q "changed=0.*failed=0" \
    && (echo "Idempotence test: pass" && exit 0) \
    || (echo "Idempotence test: fail" && exit 1) \
  
#sudo docker rm -f "$(cat ${container_id})"