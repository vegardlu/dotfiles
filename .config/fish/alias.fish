# Aliases
alias e='exa --icons --git -laTL 1'

# Maven
alias mvnit="mvn -T 4clean install -Dintegration-test=true"
alias mvnp="mvn -T 4 clean install -Dpackaging=true"
alias mvnitp="mvn -T 4 clean install -Dpackaging=true -Dintegration-test=true"
alias mvnskp="mvn -T 4 clean install -DskipTests && ./deploy.sh"
alias mvnf='mvn -T 4 install -DskipTests -pl \!(find *schemas -maxdepth 0)'
alias mvnin='mvn -T 4 clean install'

alias mvndit="mvnd clean install -Dintegration-test=true"
alias mvndp="mvnd clean install -Dpackaging=true"
alias mvnditp="mvnd clean install -Dpackaging=true -Dintegration-test=true"
alias mvndskp="mvnd clean install -DskipTests && ./deploy.sh"
alias mvndf='mvnd install -DskipTests -pl \!(find *schemas -maxdepth 0)'
alias mvndin='mvnd -T 4 clean install'

# Java
alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java8oracle='export JAVA_HOME=$JAVA_8_HOME_ORACLE'
alias java11='export JAVA_HOME=$JAVA_11_HOME'
alias java12='export JAVA_HOME=$JAVA_12_HOME'
alias java17='export JAVA_HOME=$JAVA_17_HOME'

# Docker
alias docker-compose-dev='docker-compose -f ~/workspace/ace-docker-compose-dev/docker-compose.yml'
alias dcd='docker-compose-dev'
alias dcdup='docker compose -f ~/workspace/ace-docker-compose-dev/docker-compose.yml up -d'
alias dcddo='docker compose -f ~/workspace/ace-docker-compose-dev/docker-compose.yml down'
