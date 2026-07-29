# Exports
set -xg WORKSPACE "/Users/et31464/workspace"

# Java
set -xg JAVA_11_HOME (/usr/libexec/java_home -v11)
set -xg JAVA_17_HOME (/usr/libexec/java_home -v17)
set -xg JAVA_21_HOME (/usr/libexec/java_home -v21)
set -xg JAVA_25_HOME (/usr/libexec/java_home -v25)

set -xg JAVA {$JAVA_21_HOME}/jre/bin/java

# Android SDK, managed by Android Studio. Gradle resolves the SDK from
# ANDROID_HOME, which is what lets an Android project build without a
# local.properties. Guarded so the dotfiles stay portable.
if test -d "$HOME/Library/Android/sdk"
    set -xg ANDROID_HOME "$HOME/Library/Android/sdk"
end

# Docker / colima. Testcontainers does not read the active docker context, so it
# needs DOCKER_HOST pointed at colima's socket; the override gives Ryuk the
# in-VM socket path to bind-mount. Guarded so the dotfiles stay portable.
if test -S "$HOME/.colima/default/docker.sock"
    set -xg DOCKER_HOST "unix://$HOME/.colima/default/docker.sock"
    set -xg TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE /var/run/docker.sock
end
