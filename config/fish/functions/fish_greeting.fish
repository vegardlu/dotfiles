# Replaces fish's welcome banner: one line with a random tip. Builtins only, so a
# new tab starts no extra processes. Tips skip Alt/Option keys, which type
# characters on a Norwegian keyboard instead of reaching fish.
function fish_greeting
    set -l tips \
        'Ctrl+R searches your history' \
        '→ takes the grey suggestion, Shift+→ one word of it' \
        'Shift+Tab completes and lets you filter the list' \
        'Ctrl+Z undoes an edit, Ctrl+Shift+Z redoes it' \
        'Ctrl+X copies the command line, Ctrl+V pastes' \
        'Ctrl+W deletes back one path segment' \
        'Ctrl+A / Ctrl+E jump to the start / end of the line' \
        'Shift+Enter adds a line without running' \
        'z proj jumps to your most-used dir matching "proj"' \
        'zi picks a directory with fzf' \
        'cd - goes back, dirh shows where you have been' \
        'e lists files with icons and git status' \
        'jdk 21 switches Java for this shell' \
        'math 1920 / 16 is a calculator' \
        'funced foo edits a function, funcsave foo keeps it' \
        'dotfiles re-runs the bootstrap'

    set -l name (string upper (string sub -l 1 $USER))(string sub -s 2 $USER)
    set -l where
    set -q SSH_CONNECTION; and set where ' on '(string split -m1 . $hostname)[1]

    set_color cyan; echo -n '><> '
    set_color --bold; echo -n "hi $name$where"
    set_color normal; set_color brblack; echo " · "(random choice $tips)
    set_color normal
end
