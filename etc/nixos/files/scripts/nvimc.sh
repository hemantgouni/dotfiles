# accept an argument for the port, or use 9090 as the default
nvim --server "localhost:${1:-9090}" --remote-ui
