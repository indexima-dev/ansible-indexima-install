# Ansible role: Indexima installation
Ansible role to install, configure and start Indexima, with a few example 

[![Build Status](https://travis-ci.com/indexima-dev/ansible-indexima-install.svg?branch=master)](https://travis-ci.com/indexima-dev/ansible-indexima-install)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-ansible__indexima__install-blue)](https://galaxy.ansible.com/indexima_team/ansible_indexima_install)

## Quickstart

If you are new to Ansible, here is how to install it with pip:

```pip install ansible```

Then install the indexima-install role:

```ansible-galaxy install indexima_team.ansible_indexima_install```

You can execute the example playbook in examples with the example host file:

```ansible-playbook -i examples/hosts.local examples/indexima.yml```

This will install Indexima locally, providing your current user has sudo access with no password.
If it does not, you need to either execute the playbook as root, or set the sudo password in the example/hosts.local file (uncomment and set the "ansible_sudo_pass" variable)

You can also make your own playbook

```
---
- hosts: localhost
  become: yes
  roles:
    - { role: indexima_team.ansible_indexima_install }
  vars:
    is_master: 1
```

# Variables

## Prerequisites and install

 Variable                 | Description              | Possible Values  | Default                                                                                 |
| ----------------------- | ----------------         | ---------------- | --------------------------------------------------------------------------------------- |
| version                 | Indexima version         |                  | 1.7.12.1257.1                                                                           |
| internal_host           | Internal IP of each host |                  | "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}"                 |
| internet                | Hosts have internet access or not | 1/0     | 1                                                                                       |
| internal_use            | If you store your own Indexima package, you can use this instead of the official download.indexima.com/release url | 1/0 | 0                                                                                       |
| is_master               | A host variable that set the master. Only one host must be master | 1/0 | 0                                                                                       |
| systemd                 | Set to true to use systemd service to start/stop Indexima | true/false | true                                                                                    |
| install_path            | The base installation path |                  | /opt                                                                                    |
| indexima_path           | Indexima and Visualdoop2 installation path |                  | "{{ install_path }}/indexima"                                                           |
| indexima_logs_path      | The base path for all Indexima logs |                  | /var/log/indexima                                                                       |
| indexima_log_dir        | Indexima logs |                  | "{{ indexima_logs_path }}/logs"                                                         |
| indexima_hive_log_dir   | Indexima embedded Hive server logs |                  | "{{ indexima_logs_path }}/hive"                                                         |
| indexima_history_dir    | Query history in log format |                  | "{{ indexima_logs_path }}/history"                                                      |
| indexima_history_export | Query history in csv format |                  | "{{ indexima_logs_path }}/history_csv"                                                  |

## Config parameters

 Variable                 | Description                            | Possible values               | Default        |
| ----------------------- | -------------------------------------- | ----------------------------- | -------------- |
| nodes                   | Number of nodes in the cluster (required) |  | 1 |
| node_connect_timeout    | Time (in s) after which the cluster will start even if the number of nodes specified is not met |  |"{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] | d('LOCAL_IP') }}" |
| cores                   | Number of cores per node |  |"{{ ansible_processor_vcpus }}"                                                         |
| ram                     | Total RAM per node. Indexima RAM will be 0.7 * ram |  |"{{ ansible_memtotal_mb }}" |
| disk                    | Number of disk per node |  |1                                                                                       |
| warehouse_type          | The type of filesytem used for the data warehouse | local/nfs/s3/gs/adl/hdfs | local |
| warehouse               | Path to the warehouse. If using S3, use the full s3 path, prefixed with 's3a://' (instead of the standard s3://) |  |"{{ indexima_path }}/warehouse" |
| partitions_number       | The number of partitions used for the data |  |"{{ cores|int * nodes }}" |
| ha                      | Set to 1 to activate full master dynamic mode | 1/0 | 1 |