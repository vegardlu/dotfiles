#!/bin/sh

export app=LOCAL
export logstashDestination=LOGSTASH_DESTINATION 
export JETTY_BASE=`pwd`
export JAVA_OPTIONS="-Xmx2g -Dspring.profiles.active=adcm,default"
 
sh $JETTY_SH $1 JAVA=$JAVA JAVA_OPTIONS=$JAVA_OPTIONS JETTY_HOME=$JETTY_HOME JETTY_BASE=$JETTY_BASE JETTY_RUN=$JETTY_BASE
