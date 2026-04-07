#!/bin/bash

SESS=ifco
DIRS=(ifco-digital-semantic-layer ifco-digital-data-apps daily_picker_wheel)

tmux has-session -t $SESS 2>/dev/null

if [ $? != 0 ]; then
	tmux new-session -ds $SESS
	for i in ${!DIRS[@]}; do
		dir=${DIRS[$i]}
		if [[ $i -eq 0 ]]; then
			# tmux index must start in 1
			tmux rename-window -t $SESS:1 $dir
		else
			tmux new-window -t $SESS:$((i+1)) -n $dir
		fi
		tmux send-keys -t $SESS:$dir "cd ~/$dir" C-m
		tmux send-keys -t $SESS:$dir "nvim" C-m
	done


fi

tmux attach-session -t $SESS:1
