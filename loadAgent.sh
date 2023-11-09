#!/usr/bin/env bash

agentEnv=~/.ssh/.env

if [[ -f $agentEnv ]]; then
    . $agentEnv > /dev/null
    if [[ -S $SSH_AUTH_SOCK ]]; then
        if [[ -n $SSH_AGENT_PID ]] && [[ -f /proc/$SSH_AGENT_PID/cmdline ]] && grep -q ssh-agent /proc/$SSH_AGENT_PID/cmdline; then
		exit 0
        else
            eval $(ssh-agent | tee $agentEnv)
        fi
    else
        eval $(ssh-agent | tee $agentEnv)
    fi
else
    eval $(ssh-agent | tee $agentEnv)
fi
