# ansible-indexima-install
Ansible role to install, configure and start Indexima, with a few example 

<a href="https://travis-ci.org/estebgonza/roquette" title="Roquette SQL Stresser Build">
    <img src="https://travis-ci.com/indexima-dev/ansible-indexima-install.svg?branch=master" alt="Roquette SQL Stresser Build"/>
</a>

## Quickstart

If you are new to Ansible, here is how to install it

```pip install ansible```

Then install the indexima-install role

```ansible-galaxy install indexima_team.ansible_indexima_install```

You can execute the example playbook in examples with the example host file

```ansible-playbook -i examples/hosts.local examples/indexima.yml```

This will install Indexima locally, providing your current user has sudo access with no password.