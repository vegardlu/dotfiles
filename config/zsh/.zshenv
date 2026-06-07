# Docker / colima. Testcontainers does not read the active docker context, so it
# needs DOCKER_HOST pointed at colima's socket; the override gives Ryuk the
# in-VM socket path to bind-mount. Guarded so the dotfiles stay portable.
if [[ -S "$HOME/.colima/default/docker.sock" ]]; then
    export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
    export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock"
fi
