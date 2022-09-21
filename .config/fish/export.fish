# Exports
set -xg WORKSPACE "/Users/et31464/workspace"

# Java
set -xg JAVA_8_HOME (/usr/libexec/java_home -v1.8)
set -xg JAVA_11_HOME (/usr/libexec/java_home -v11)
set -xg JAVA_17_HOME (/usr/libexec/java_home -v17)

set -xg JAVA {$JAVA_11_HOME}/jre/bin/java

# Logstash
set -xg LOGSTASH_DESTINATION alt-aot-g-fou01.fe.cosng.net:4560

# Make Properties
set -xg envFile '--env-file=/Users/et31464/.env'
set -xg mvnProperties "-Ddb.url='$oracleDbUrl' -Ddb.user=$oracleDbUser -Ddb.password=$oracleDbPassword -Doracle.net.disableOob=true"
set -xg springArgs "--datasource.url=$oracleDbUrl --datasource.user=$oracleDbUser --datasource.password=$oracleDbPassword --oracle.net.disableOob=true"
