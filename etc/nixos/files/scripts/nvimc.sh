nvim --server "localhost:${1:-9090}" --remote-expr "setenv('SSH_AUTH_SOCK', '$SSH_AUTH_SOCK')" > /dev/null 2>&1
# accept an argument for the port, or use 9090 as the default
nvim --server "localhost:${1:-9090}" --remote-ui
