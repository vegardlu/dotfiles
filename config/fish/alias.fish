# Aliases
alias e='exa --icons --git -laTL 1'
alias googlecloud='gcloud auth login'

# Maven
alias mvnit="mvn clean install -Dintegration-test=true"
alias mvnp="mvn clean install -Dpackaging=true"
alias mvnitp="mvn clean install -Dpackaging=true -Dintegration-test=true"
alias mvnf='mvn install -DskipTests -pl \!(find *schemas -maxdepth 0)'

# Java
alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java8oracle='export JAVA_HOME=$JAVA_8_HOME_ORACLE'
alias java11='export JAVA_HOME=$JAVA_11_HOME'
alias java12='export JAVA_HOME=$JAVA_12_HOME'
alias java17='export JAVA_HOME=$JAVA_17_HOME'
alias java21='export JAVA_HOME=$JAVA_21_HOME'

# Docker
alias docker-compose-dev='docker compose -f ~/workspace/docker-compose-dev/docker-compose.yml'
alias dcd='docker-compose-dev'
