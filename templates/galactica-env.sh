# Copyright Indexima
#
{% if indexima_ram is defined %}
export GALACTICA_MEM={{ indexima_ram }}m

{% else %}
{% set memory = (ram|float * 0.70) | int %}
export GALACTICA_MEM={{ memory }}m

{% endif %}
# If you installed java on your own, you need to manually specify an JAVA_HOME variable
{% if java_home is defined %}
export JAVA_HOME={{ java_home }}

{% endif %}
# If you installed hadoop on your own, you need to manually specify an HADOOP_BASE variable
{% if yarn_deploy and yarn_classpath %}
export HADOOP_JARS=$(yarn classpath)
{% else %}
export HADOOP_BASE={{ hadoop_base }}
export HADOOP_JARS=$HADOOP_BASE/etc/hadoop:$HADOOP_BASE/share/hadoop/common/*:$HADOOP_BASE/share/hadoop/common/lib/*:$HADOOP_BASE/share/hadoop/hdfs/*:$HADOOP_BASE/share/hadoop/mapreduce/*:$HADOOP_BASE/share/hadoop/yarn/*:$HADOOP_BASE/share/hadoop/tools/lib/*

{% endif %}
{% if kerberos_full or kerberos_indexima %}
## In kerberos mode you can specify here the principal and keytab
KINIT_PRINCIPAL={{ kerberos_principal }}
KINIT_KEYTAB={{ kerberos_keytab }}
# Retrieve principal / keytab from a well formatted hive-site.xml
export KINIT_FROM_HIVE_SITE=true

{% endif %}
{% if kerberos_full == 0 and (kerberos_indexima == 1 or kerberos_zookeeper == 1 or kerberos_hdfs == 1) %}
export NODESERVER_JVM_OPTIONS="-Djava.security.auth.login.config={{ galactica_path }}/jaas.conf -Djavax.security.auth.useSubjectCredsOnly=false"

{% endif %}
# JVM parameters
export GC_OPTIONS="-XX:+UseConcMarkSweepGC -XX:-OmitStackTraceInFastThrow"

{% if warehouse_type == "s3" or warehouse_type == "s3like" or aws == 1 %}
# AWS credentials for loading from S3
{% if aws_access_key_id is defined and aws_secret_access_key is defined %}
export AWS_ACCESS_KEY_ID={{ aws_access_key_id }}
export AWS_SECRET_KEY={{ aws_secret_access_key }}

{% endif %}

{% endif %}
{% if warehouse_type == "gs" or gs == 1 %}
# Google Credentials for using GS
{% if google_credentials is defined %}
export GOOGLE_APPLICATION_CREDENTIALS={{ google_credentials }}

{% endif %}

{% endif %}