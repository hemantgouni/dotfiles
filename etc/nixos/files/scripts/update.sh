set -euo pipefail

action='noop'
method='boot'
host='none'

# nested quotes here aren't truly nested-- command substitution begins a new
# evaluation context, so the outer quotes don't apply and we don't need to
# escape the inner ones
argv_0="$(basename "$0")"

set_action () {
    if test "$action" == 'noop'
    then
        action="$1"
    else
        printf 'Cannot set more than one action. Exiting.\n'
        exit
    fi
}

while getopts 'hprsie:' opt
do
    case "$opt" in
        '?' | 'h')
            printf '%s\n%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n' \
                "Usage: $argv_0 [-hprsief]" \
                'Update nixos and reboot.' \
                '-h'      'Show this help text.' \
                '-p'      'Suspend without prompting.' \
                '-r'      'Reboot without prompting.' \
                '-s'      'Shutdown without prompting.' \
                '-i'      'Immediately switch to the updated system.' \
                '-e HOST' 'Use ssh://HOST to build the system.' \
                '-f'      'Update Firefox only'
            exit
            ;;
        'r')
            set_action 'reboot'
            ;;
        's')
            set_action 'shutdown now'
            ;;
        'p')
            set_action 'systemctl suspend'
            ;;
        'i')
            method='switch'
            ;;
        'e')
            host="$OPTARG"
            ;;
    esac
done

# removes all parsed options
shift "$((OPTIND - 1))"

sudo nix flake update /etc/nixos

nixos-rebuild dry-build

if test "$host" != 'none'
then
    nixos-rebuild --build-host "$host" build
fi

sudo nixos-rebuild "$method"

# could just run action here after setting it to ':' (bash noop) at the
# beginning instead of testing first, but just in case action is ever something
# that doesn't immediately stop execution (shutdown or reboot)...
if test "$action" != 'noop'
then
    $action
    exit
fi

read -rp 'Suspend, reboot or shutdown now? [p/r/s/n] ' answer

case "$answer" in
    'p')
        systemctl suspend
        ;;
    'r')
        systemctl reboot
        ;;
    's')
        systemctl poweroff
        ;;
    *)
        printf 'Exiting.\n'
        ;;
esac
