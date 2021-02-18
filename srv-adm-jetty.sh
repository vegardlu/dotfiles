#!/bin/sh
export JETTY_HOME="$(brew --cellar jetty)/$( brew list --versions jetty | tr ' ' '\n' | tail -1)/libexec"
export JETTY_SH=$JETTY_HOME"/bin/jetty.sh"
export app=LOCAL
export logstashDestination=LOGSTASH_DESTINATION 
export JETTY_BASE=`pwd`
export JAVA_OPTIONS="-Xmx2g"
 
sh $JETTY_SH $1 JAVA=$JAVA JAVA_OPTIONS=$JAVA_OPTIONS JETTY_HOME=$JETTY_HOME JETTY_BASE=$JETTY_BASE JETTY_RUN=$JETTY_BASE
