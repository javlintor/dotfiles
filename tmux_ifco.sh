#!/bin/bash

DIRS=(ifco-digital-semantic-layer ifco-digital-data-apps dotfiles)

for dir in ${DIRS[@]}; do
	tmux has-session -t $dir 2>/dev/null
	if [ $? != 0 ]; then
		# window 1: nvim
		tmux new-session -ds $dir -c ~/$dir -n nvim
		tmux send-keys -t $dir:nvim "nvim" C-m
		# window 2: claude
		tmux new-window -t $dir -c ~/$dir -n claude
		tmux send-keys -t $dir:claude "claude" C-m
	fi
done

tmux attach-session -t ${DIRS[0]}
