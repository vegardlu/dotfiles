function jdk --description 'Point JAVA_HOME at a JDK for this shell: jdk 21. No argument lists JDKs.'
    if test (count $argv) -eq 0
        /usr/libexec/java_home -V
        return
    end
    set -l home (/usr/libexec/java_home -F -v $argv[1]); or return
    set -gx JAVA_HOME $home
    java -version
end
