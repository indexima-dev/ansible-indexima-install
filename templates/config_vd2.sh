# Copyright Indexima
#

{% if java_home is defined %}
export JAVA_HOME={{ java_home }}

{% endif %}
# Web server port number
{% if ssl == 1 %}
export VISUALDOOP_WEB_PORT=8081
export VISUALDOOP_WEB_PORT_SSL=8082
export VISUALDOOP_SSL=true
export VISUALDOOP_SSL_KEYSTORE_LOCATION={{ vd2_path }}/{{ keystore_file }}
export VISUALDOOP_SSL_KEYSTORE_PASSWORD={{ keystore_password }}

{% else %}
export VISUALDOOP_WEB_PORT=8082

{% endif %}
# Agent port number
export VISUALDOOP_HOST=0.0.0.0

#export TDS_DRIVER_CLASS=indexima_jdbc

{% if admin_type == 's3' %}
# AWS S3 storage
export VISUALDOOP_STORE=S3
export VISUALDOOP_BUCKET={{ vd_bucket }}
export VISUALDOOP_DATA={{ vd_data }}/visualdoop-data
{% if aws_access_key_id is defined and aws_secret_access_key is defined %}
export AWS_ACCESS_KEY_ID={{ aws_access_key_id }}
export AWS_SECRET_KEY={{ aws_secret_access_key }}
{% endif %}

{% elif admin_type == 'azure' %}
# Azure ADLS storage
export VISUALDOOP_STORE=ADLS
export VISUALDOOP_BUCKET={{ vd_bucket }}
export ADLS_CLIENT_ID={{ fs_adl_oauth2_client_id }}
export ADLS_CLIENT_SECRET={{ dfs_adls_oauth2_password }}
export ADLS_TENANT_ID={{ fs_adl_oauth2_tenant_id }}

{% elif admin_type == "gs" %}
# Google Credentials for using GS
export GOOGLE_APPLICATION_CREDENTIALS={{ google_credentials }}
export VISUALDOOP_STORE=GS
export VISUALDOOP_BUCKET={{ vd_bucket }}
export VISUALDOOP_DATA={{ vd_data }}

{% else %}
# Path of a directory to store administration and temporary files
export VISUALDOOP_DATA={{ vd_data }}

{% endif %}
{% if ldap |bool %}
# LDAP authentication
export VISUALDOOP_LOGIN=LDAP
export VISUALDOOP_LDAP_URL={{ ldap_url }}
export VISUALDOOP_LDAP_USER_DN_PATTERN={{ ldap_user_dnpattern }}

{% endif %}
{% if admin_users is defined %}
# VISUALDOOP Admin Users
export VISUALDOOP_ADMIN={{ admin_users }}

{% endif %}
{% if vd_pass is defined %}
export VISUALDOOP_DEFAULT_PASS={{ vd_pass }}

{% endif %}
{% if vd_cluster %}
export CLUSTER_MODE=true
export PROJECT_MODE=false

{% endif %}