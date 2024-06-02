list_recent_files () {
    # list all files with their mtimes, excluding hidden directories and files
    #
    # using Unicode 0x1F here, as a delimiter, from
    # https://en.wikipedia.org/wiki/C0_and_C1_control_codes#Field_separators
    find . -not -type d -not -path "*/.*" -printf "%T@␟%p\0" | \
        # Sort by the first field, starting (and ending) at the first field
        sort --zero-terminated --numeric-sort --key=1,1 --reverse | \
        # Set input and output record and field separators to nul and unicode
        # unit separator characters, respectively. Print the column of
        # filenames.
        awk 'BEGIN { RS="\0"; FS="␟"; ORS="\0"; OFS="␟" }; { print $2 }'
}

command_name=$(basename "$0")

if [ "$command_name" = "er" ]; then
    # extract the first (most recent) file; \000 specified for tr because the
    # manpage says it accepts \NNN octal values but doesn't necessarily handle \0
    "$VISUAL" "$(list_recent_files | head --zero-terminated --lines=1 | tr -d '\000')"
elif [ "$command_name" = "erl" ]; then
    # translate all null terminators to newlines to send to vim
    list_recent_files | head --zero-terminated --lines=10 | tr '\000' '\n' | \
        # noswapfile is an excmd that executes another command that possibly
        # creates a buffer and does not create a swapfile for that buffer
        nvim +noswapfile \
             +"setlocal buftype=nofile" \
             +"setlocal bufhidden=hide" \
             +"setlocal nobuflisted"
else
    printf '%s\n' "Called with invalid command name $command_name (not 'er' or 'erl'). Exiting."
fi
