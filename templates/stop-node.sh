# Copyright Indexima
#
# Stop Indexima nodes
#

if [ ! -r "{{ galactica_path }}/conf/galactica-env.sh" ] ; then
        echo "The file conf/galactica-env.sh is not found. Please create it based on the template file.";
    exit 1;
fi

export GALACTICA_LIB={{ galactica_path }}/indexima-core-{{ indexima_version }}.jar

source {{ galactica_path }}/conf/galactica-env.sh

$JAVA_HOME/bin/java -cp {{ galactica_path }}/lib/*:{{ galactica_path }}/conf:$GALACTICA_LIB:$HADOOP_JARS io.galactica.server.NodeServer --stop