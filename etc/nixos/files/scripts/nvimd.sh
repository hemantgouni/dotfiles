#!/usr/bin/env bash

# accept an argument for the port, or use 9090 as the default
nohup nvim --headless --listen "localhost:${1:-9090}"&

disown $!
