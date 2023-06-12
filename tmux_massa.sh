#!/bin/bash

apt install tmux -y
tmux kill-session -t rolls
source $HOME/.profile
tmux new-session -d -s rolls 'bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/massa/rolls.sh)'
tmux attach -t rolls