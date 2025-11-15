#!/bin/bash

SESS="my_tmux_session"

tmux has-session -t $SESS 2>/dev/null

if [ $? != 0 ]; then
	tmux new-session -ds $SESS
	for dir in "ifco-digital-semantic-layer" "ifco-digital-data-apps"
	do
		tmux new-window -t $SESS -n $dir
		tmux send-keys -t $SESS:$dir "cd ~/$dir" C-m
		tmux send-keys -t $SESS:$dir "nvim" C-m
	done
	tmux kill-window -t $SESS:0

	# index
	tmux set-option -g base-index 1

fi


tmux attach-session -t $SESS
