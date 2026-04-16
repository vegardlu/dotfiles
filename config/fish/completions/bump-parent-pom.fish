complete -c bump-parent-pom -l from -d 'Current parent-pom version to match' -x
complete -c bump-parent-pom -l to -d 'Target parent-pom version' -x
complete -c bump-parent-pom -l workspace -d 'Workspace directory' -r -F
complete -c bump-parent-pom -l dry-run -d 'Show what would be done without making changes'
complete -c bump-parent-pom -l no-wait -d 'Skip waiting for CI builds'
complete -c bump-parent-pom -l timeout -d 'CI wait timeout in minutes' -x
complete -c bump-parent-pom -s h -l help -d 'Show help message'
