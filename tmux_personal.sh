#!/bin/bash

# session_name:relative_path_from_home
DIRS=(
	estado_cuentas:code/estado_cuentas
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
		# window 2: opencode
		tmux new-window -t $session: -c ~/$path -n opencode
		tmux send-keys -t $session:opencode "opencode" C-m
	fi
done

first=${DIRS[0]}
tmux attach-session -t ${first%%:*}
