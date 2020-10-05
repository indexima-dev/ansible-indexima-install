#!/bin/bash

### Travis script in sh file for local testing
### Needs to be executed in the root directory of the role

## If MOLECULE_AMI_NAME is set, scenario to play is the one with the EC2
## Otherwise, the local docker scenarion is played

set -e

mkdir -p $HOME/.cache/molecule/ansible-indexima-install/aws-ec2
touch $HOME/.cache/molecule/ansible-indexima-install/aws-ec2/instance_config.yml

if [ ! -z "${MOLECULE_AMI_NAME}" ]; then
  molecule --debug test -s aws-ec2
else
  molecule test -s default
fi