if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

alias mvnit="mvn clean install -Dintegration-test=true"
alias mvnp="mvn clean install -Dpackaging=true"
alias mvnitp="mvn clean install -Dpackaging=true -Dintegration-test=true"
alias mvnd="mvn clean install -DskipTests && ./deploy.sh"

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)

alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java11='export JAVA_HOME=$JAVA_11_HOME'

export JAVA=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/jre/bin/java

# default to Java 8 
java8

#Jetty
export JETTY_HOME=/usr/local/Cellar/jetty/9.4.15.v20190215/libexec/
export JETTY_SH=/usr/local/Cellar/jetty/9.4.15.v20190215/libexec/bin/jetty.sh

#Logstash
export LOGSTASH_DESTINATION=alt-aot-g-fou01.fe.cosng.net:4560

# z support
. /usr/local/etc/profile.d/z.sh
