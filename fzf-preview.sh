#!/usr/bin/bash

fzf \
	--preview="bat -p --color=always {}" \
	--preview-window='up,60%,border-bottom'
