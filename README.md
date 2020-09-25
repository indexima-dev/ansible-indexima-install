# Ansible role: Indexima installation
Ansible role to install, configure and start Indexima, with a few example 

<a href="https://travis-ci.com/indexima-dev/ansible-indexima-install" title="Ansible Indexima role">
    <img src="https://travis-ci.com/indexima-dev/ansible-indexima-install.svg?branch=master" alt="Ansible Indexima role"/>
</a>

## Quickstart

If you are new to Ansible, here is how to install it:

```pip install ansible```

Then install the indexima-install role:

```ansible-galaxy install indexima_team.ansible_indexima_install```

You can execute the example playbook in examples with the example host file:

```ansible-playbook -i examples/hosts.local examples/indexima.yml```

This will install Indexima locally, providing your current user has sudo access with no password.
If it does not, you need to either execute the playbook as root, or set the sudo password in the example/hosts.local file (uncomment and set the "ansible_sudo_pass" variable)
