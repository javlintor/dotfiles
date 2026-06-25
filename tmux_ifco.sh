#!/bin/bash

# session_name:relative_path_from_home
DIRS=(
	ifco-digital-semantic-layer:ifco-digital-semantic-layer
	ifco-digital-data-apps:ifco-digital-data-apps
	dotfiles:dotfiles
	nvim:.config/nvim
)

for entry in ${DIRS[@]}; do
	session=${entry%%:*}
	path=${entry#*:}
	tmux has-session -t $session 2>/dev/null
	if [ $? != 0 ]; then
		# window 1: nvim
		tmux new-session -ds $session -c ~/$path -n nvim
		tmux send-keys -t $session:nvim "nvim" C-m
		# window 2: claude
		tmux new-window -t $session: -c ~/$path -n claude
		tmux send-keys -t $session:claude "claude" C-m
	fi
done

first=${DIRS[0]}
tmux attach-session -t ${first%%:*}
