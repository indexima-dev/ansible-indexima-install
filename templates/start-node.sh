# Copyright Indexima
#
# Start Indexima node in Stand Alone mode
#

if [ ! -r "{{ galactica_path }}/conf/galactica-env.sh" ] ; then
        echo "The file conf/galactica-env.sh is not found. Please create it based on the template file.";
    exit 1;
fi

export GALACTICA_LIB={{ galactica_path }}/indexima-core-{{ indexima_version }}.jar:{{ galactica_path }}/galactica-datascience-{{ indexima_version }}.jar:{{ galactica_path }}/galactica-datascience-livy-{{ indexima_version }}.jar

# libs that should be place first to solve incompatibilities
export ORDER_LIBS={{ galactica_path }}/lib/joda-time-2.9.4.jar:{{ galactica_path }}/lib/snappy-0.3.jar

source {{ galactica_path }}/conf/galactica-env.sh

$JAVA_HOME/bin/java -Xms$GALACTICA_MEM -Xmx$GALACTICA_MEM -Xss512k $GC_OPTIONS $JMX_OPTIONS -cp $ORDER_LIBS:{{ galactica_path }}/lib/*:{{ galactica_path }}/datascience/*:{{ galactica_path }}/conf:{{ galactica_path }}/web:$GALACTICA_LIB:$HADOOP_JARS io.galactica.server.NodeServer $@