if [ -n "$NVIM" ] && [ "$#" -gt 0 ]; then
    # double quoting $@ is special: quotes each entry in the list of arguments
    # separate by null terminators instead of newlines to handle files w/ spaces
    readlink --canonicalize --zero "$@" \
        | xargs --null nvim --server "$NVIM" --remote-tab

    # so the 'editor' waits for input
    read -rp $'Press enter to finish editing (for temporary files).\n'
else
    printf '%s\n' 'No arguments given, or not running inside nvim. Exiting.'
fi
