list_recent_files () {
    # list all files with their mtimes, excluding hidden directories and files
    #
    # using Unicode 0x1F as a delimiter here, from
    # https://en.wikipedia.org/wiki/C0_and_C1_control_codes#Field_separators
    find . -not -type d -not -path "*/.*" -not -path "./$1/*" -printf "%T@␟%p\0" | \
        # Since the time appears first, we needn't sort by a particular field
        sort --zero-terminated --numeric-sort --reverse | \
        # Set input record and field separators to nul and unicode unit
        # separator characters, respectively. Use null terminators for
        # lines in output. Print the column of filenames.
        #
        # awk can handle separate record/field separators, and multi-byte
        # separators. cut can't.
        awk 'BEGIN { RS="\0"; FS="␟"; ORS="\0" }; { print $2 }'
}

command_name=$(basename "$0")

if [ "$command_name" = "er" ]; then
    # extract the first (most recent) file; \000 specified for tr because the
    # manpage says it accepts \NNN octal values but doesn't necessarily handle \0
    #
    # $() always creates a new quoting context
    nvim "$(list_recent_files "$1" | head --zero-terminated --lines=1 | tr -d '\000')"
elif [ "$command_name" = "erl" ]; then
    # translate all null terminators to newlines to send to vim
    list_recent_files "$1" | head --zero-terminated --lines=10 | \
        # $0 is the entire line, $1 is the first field, $2 is the second field, ...
        awk 'BEGIN { RS="\0"; ORS="\n\n" }; { print NR "\t" $0 }' | head --bytes=-1 | \
        # noswapfile is an excmd that executes another command that possibly
        # creates a buffer and does not create a swapfile for that buffer
        nvim +noswapfile \
             +"setlocal buftype=nofile" \
             +"setlocal bufhidden=hide" \
             +"setlocal nobuflisted" \
             +"normal! ll"
else
    printf '%s\n' "Called with invalid command name $command_name (not 'er' or 'erl'). Exiting."
fi
