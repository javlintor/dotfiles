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

	# statusbar
	tmux set -g status-position bottom
	tmux set -g status-justify left
	tmux set -g status-style 'fg=black'
	tmux set -g status-left ''
	tmux set -g status-left-length 10
	tmux set -g status-right-style 'fg=black bg=white'
	tmux set -g status-right ''
	tmux set -g status-right-length 10 
	tmux set -g window-status-current-style 'fg=black bg=green'
	tmux set -g window-status-current-format ' #I #W '
	tmux set -g window-status-style 'fg=green bg=black'
	tmux set -g window-status-format ' #I #[fg=white]#W '
fi


tmux attach-session -t $SESS
