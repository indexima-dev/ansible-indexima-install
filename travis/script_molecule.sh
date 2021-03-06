#!/bin/bash

### Travis script in sh file for local testing
### Needs to be executed in the root directory of the role

## If MOLECULE_AMI_NAME is set, scenario to play is the one with the EC2
## Otherwise, the local docker scenarion is played

set -e

mkdir -p $HOME/.cache/molecule/ansible-indexima-install/aws-ec2
touch $HOME/.cache/molecule/ansible-indexima-install/aws-ec2/instance_config.yml

if [ "${MOL_TEST}" == "amazon" ]; then
  molecule test -s aws-ec2
elif [ "${MOL_TEST}" == "local" ]; then
  ./travis/script_local_test.sh centos 7
elif [ "${MOL_TEST}" == "docker-auth" ]; then
  molecule test -s docker-auth
else
  molecule test -s default
fi