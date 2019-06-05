# Z SH env 

# Source
source ~/.compiled-exports 
source ~/.exports
source ~/.functions
source ~/.aliases

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Default to Java 8 
java8

# z support
. /usr/local/etc/profile.d/z.sh
