# Ansible role: Indexima installation
Ansible role to install, configure and start Indexima, with a few examples

[![Build Status](https://travis-ci.com/indexima-dev/ansible-indexima-install.svg?branch=master)](https://travis-ci.com/indexima-dev/ansible-indexima-install)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-ansible__indexima__install-blue)](https://galaxy.ansible.com/indexima_team/ansible_indexima_install)

# Quickstart

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
| version                 | Indexima version         |                  | 2021.2.1390.1                                                                           |
| internal_host           | Internal IP of each host |                  | "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}"                 |
| internet                | Hosts have internet access or not | 1/0     | 1                                                                                       |
| internal_use            | If you store your own Indexima package, you can use this instead of the official download.indexima.com/release url | 1/0 | 0                                                                                       |
| is_master               | A host variable that set the master. Only one host must be master | 1/0 | 0                                                                                       |
| systemd                 | Set to true to use systemd service to start/stop Indexima | true/false | true                                                                                    |
| install_path            | The base installation path |                  | /opt                                                                                    |
| indexima_path           | Indexima and Visualdoop2 (dev console) installation path |                  | "{{ install_path }}/indexima"                                                           |
| indexima_logs_path      | The base path for all Indexima logs |                  | /var/log/indexima                                                                       |
| indexima_log_dir        | Indexima logs |                  | "{{ indexima_logs_path }}/logs"                                                         |
| indexima_hive_log_dir   | Indexima embedded Hive server logs |                  | "{{ indexima_logs_path }}/hive"                                                         |
| indexima_history_dir    | Query history in log format |                  | "{{ indexima_logs_path }}/history"                                                      |
| indexima_history_export | Query history in csv format |                  | "{{ indexima_logs_path }}/history_csv"                                                  |

## Config parameters

| Variable                | Description                            | Possible values               | Default        |
| ----------------------- | -------------------------------------- | ----------------------------- | -------------- |
| nodes                   | Number of nodes in the cluster (required) |  | 1 |
| node_connect_timeout    | Time (in s) after which the cluster will start even if the number of nodes specified is not met |  |"{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] \| d('LOCAL_IP') }}" |
| cores                   | Number of cores per node |  |"{{ ansible_processor_vcpus }}"                                                         |
| ram                     | Total RAM per node. Indexima RAM will be 0.7 * ram |  |"{{ ansible_memtotal_mb }}" |
| disk                    | Number of disk per node |  |1                                                                                       |
| warehouse_type          | The type of filesytem used for the data warehouse | local/nfs/s3/gs/adl/hdfs | local |
| warehouse               | Path to the warehouse. If using S3, use the full s3 path, prefixed with 's3a://' (instead of the standard s3://) | | "{{ indexima_path }}/warehouse" |
| readers                 | The number of max readers tasks. _Deprecated after Indexima 2021.2_  |  | "{% if cores > 4 %}{{ (cores / 2)\|int }}{% else %}{{ cores\|int }}{% endif %}" |
| loaders                 | The number of max loaders tasks |  | "{% if cores > 4 %}{{ (cores / 2)\|int }}{% else %}{{ cores\|int }}{% endif %}" |
| queries                 | The number of max threading for queries |  | "{{ (cores * 8)\|int }}" |
| hybrids                 | The number of max threading for queries out of index. _Deprecated after Indexima 2021.1_ |  | 6 |
| partitions              | The number of partitions used for the data |  | "{{ (cores * nodes)\|int }}" |
| ha                      | Set to 1 to activate full master dynamic mode | 1/0 | 1 |
| node_port               | Port used by the nodes to communicate with each other. This will use the port specified here, and the port +1 | | 19999 |
| monitor_port            | Port used to access the monitor api | | 9999 |
| galactica_conf_extended | Path (on the Ansible host) to a file containing galactica.conf parameters. The content of the file will be appended at the ended of the automatically generated galactica.conf. Use this if a parameter you need is not yet supported by the Ansible install role. *Warning*: Be careful not to write a parameter already present in the template | | |

These are the main useful variables. If you wish to customize the installation further, open an issue for more information on certain parts of the role.

## Auth and integration

| Variable                | Description                           | Possible values                | Default        |
| ----------------------- | ------------------------------------- | ------------------------------ | -------------- |
| drivers                 | Set to true if you need to upload jdbc to Indexima nodes. By default, it copies every file present in the 'files/driver' located in at the root of the Ansible folder | 1/0 | 0 |
| drivers_url             | if you want to download the required jdbc drivers from a custom http url, set drivers_url to 1, and fill the driver_list with the names of the files. | | |
| aws_access_key_id       | The AWS_ACCESS_KEY_ID of the account you want to use for Indexima, if you are using S3 as a warehouse type for example | | |
| aws_secret_access_key   | The AWS_SECRET_ACCESS_KEY of the account you want to use for Indexima, if you are using S3 as a warehouse type for example | | |
| google_credentials      | The path on every nodes to which you will copy the credentials.json for GCP access. It is recommended to use the value "{{ galactica_path }}/conf" | | |
| fs_adl_oauth2_client_id | To use ADLS, you need to configure Azure credentials for Indexima. You can find these values on your Azure portal | | |
| fs_adl_oauth2_tenant_id | 
| dfs_adls_oauth2_password | 
| fs_defaultFS            | The URL to your ADLS, it look like 'adl://BUCKET_NAME.azuredatalakestore.net' | | |
| monitor_auth            | Set to true if you want to use the custom authentication to Indexima | true/false | false |
| galactica_users         | If monitor_auth is set to true, you must specify a list of coma-separated usernames | | admin |
| galactica_passwords     | Specify a list of coma-separated password. Each password match the user of the same index | | admin |
| galactica_admins        | Specify a list of coma-separated username. The users in galactica_users that are also present here will have admin rights | |admin |
| monitor_rights          | Set to true if you want to configure user rights for the Monitor | true/false | false |
| monitor_api_key         | The API key that will be needed to attach a Indexima cluster to the console | | ChangeMe |
| ldap                    | Set to true if you want to use LDAP to authenticate instead of custom auth. If set to true, ldap_url needs to be set | true/false | false |
| ldap_url                | The complete url to your LDAP server. Eg. ldap://ldap.example.com | | |
| ldap_user_dnpattern     | The LDAP User DN pattern to allow your users to login. Eg. cn=%s,ou=people,dc=example,dc=com. Note that the cn must always be %s for the login input variable | | |

# Tags

To only partially execute the Indexima install role, you can use the following tags

install, update, conf and start/stop/restart tags can be prefixed with a 'g' or a 'v' to only apply to Galactica (core engine) or Visualdoop (console) respectively. Eg. `ansible-playbook -i hosts indexima.yml -t 'grestart'` restarts only the core engine. `ansible-playbook -i hosts indexima.yml -t 'vconf'` only deploys the configuration for the console.

If no tags are provided, it is the equivalent of executing the following command: `ansible-playbook -i hosts indexima.yml -t 'prerequisites,update,conf,restart'`

| Tag value          | Description         | Command example |
| ------------------ | ------------------- | ------- |
| install | Executes the prerequisites install as well as Indexima. Also deploys the service files and the selected jdbc drivers. Does *not* deploy the conf. Prefix install with a 'g' to install only Galactica. Prefix with a 'v' for Visualdoop (dev console) | `ansible-playbook -i hosts indexima.yml -t 'install'` |
| update | Executes only the Indexima install and deploys the service files as well as the selected jdbc drivers. Does *not* install the prerequisistes, nor deploy the configuration. | `ansible-playbook -i hosts indexima.yml -t 'update'` |
| conf | Deploys the configuration files to the Indexima nodes. | `ansible-playbook -i hosts indexima.yml -t 'conf'` |
| service | Only deploys the service files | `ansible-playbook -i hosts indexima.yml -t 'service'` |
| driver | Only deploys the selected jdbc drivers | `ansible-playbook -i hosts indexima.yml -t 'driver'` |
| license | Deploys the Indexima license. A valid 'indexima.lic' must be placed in the files/ folder of this Ansible Role, or in the current working directory if installed with ansible-galaxy. | `ansible-playbook -i hosts indexima.yml -t 'license'` |
| azure_datalake | When deploying on Azure Datalake, additional configuration files are required. This tags deploys those files | `ansible-playbook -i hosts indexima.yml -t 'azure_datalake'` |
| start | Starts Indexima. | `ansible-playbook -i hosts indexima.yml -t 'start'` |
| stop | Stops Indexima. | `ansible-playbook -i hosts indexima.yml -t 'stop'` |
| restart | Restarts Indexima. | `ansible-playbook -i hosts indexima.yml -t 'restart'` |

# Update process
- Backup the warehouse folder + Backup the hosts file
- Download ZIP files (indexima installer & visualdoop2) from the [Indexima releases repository](https://download.indexima.com/release/)
- Upload ZIP files in the ansible folder ..\ansible-indexima-install\files\
- Modify the variable 'version' in the hosts file
- Launch the command : ```ansible-playbook -i client.hosts -t 'update,conf,restart'```

# External links

[Indexima website](https://indexima.com)

[Indexima documentation](https://docs.indexima.com)
