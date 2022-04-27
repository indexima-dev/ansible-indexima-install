# Copyright Indexima
#
export GALACTICA_MEM={{ indexima_ram }}m
export HADOOP_BASE={{ hadoop_base }}
export HADOOP_JARS=$HADOOP_BASE/etc/hadoop:$HADOOP_BASE/share/hadoop/common/*:$HADOOP_BASE/share/hadoop/common/lib/*:$HADOOP_BASE/share/hadoop/hdfs/*:$HADOOP_BASE/share/hadoop/mapreduce/*:$HADOOP_BASE/share/hadoop/yarn/*:$HADOOP_BASE/share/hadoop/tools/lib/*

# If you installed java on your own, you need to manually specify an JAVA_HOME variable
{% if java_home is defined %}
export JAVA_HOME={{ java_home }}
{% endif %}

{% if kerberos_full or kerberos_indexima %}
## In kerberos mode you can specify here the principal and keytab
KINIT_PRINCIPAL={{ kerberos_principal }}
KINIT_KEYTAB={{ kerberos_keytab }}
# Retrieve principal / keytab from a well formatted hive-site.xml
export KINIT_FROM_HIVE_SITE=true

{% endif %}
{% if kerberos_full == 0 and (kerberos_indexima == 1 or kerberos_hdfs == 1) %}
export NODESERVER_JVM_OPTIONS="-Djava.security.auth.login.config={{ galactica_path }}/jaas.conf -Djavax.security.auth.useSubjectCredsOnly=false"

{% endif %}
# JVM parameters
export GC_OPTIONS="{{ galactica_gc_options }}"

{% if aws_access_key_id is defined and aws_secret_access_key is defined %}
# AWS credentials for loading from S3
export AWS_ACCESS_KEY_ID={{ aws_access_key_id }}
export AWS_SECRET_ACCESS_KEY={{ aws_secret_access_key }}

{% endif %}

{% if google_credentials is defined %}
# Google Credentials for using GS
export GOOGLE_APPLICATION_CREDENTIALS={{ google_credentials }}

{% endif %}

{% if galactica_jmx_options is defined and galactica_jmx_options != '' %}
export JMX_OPTIONS='{{ galactica_jmx_options }}'

{% endif %}