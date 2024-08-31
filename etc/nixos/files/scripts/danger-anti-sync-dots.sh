if [ "$EUID" -eq 0 ]; then
    printf '%s\n%s\n' \
        'Running as root-- this is not what you want (dotfiles for root will be replaced).' \
        'Wait for me to prompt you for sudo.'
    exit 1
fi

printf 'Replacing /etc/nixos\n'

sudo rsync --info=NAME --archive --delete \
      --exclude 'exclude' \
      --exclude 'hardware-configuration.nix' \
      "$HOME/.files/etc/nixos/" '/etc/nixos'

sudo chown -R root:root '/etc/nixos'

printf 'Replacing %s/.config/nvim\n' "$HOME"

sudo rsync --info=NAME --archive --delete \
      "$HOME/.files/.config/nvim/" "$HOME/.config/nvim"

compile-nvim-conf
