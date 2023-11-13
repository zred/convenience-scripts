#!/usr/bin/env bash

agentEnv=~/.ssh/.env

# Function to start SSH agent
start_ssh_agent() {
    eval $(ssh-agent | tee $agentEnv)
}

# Function to check if SSH agent is running and valid
is_valid_ssh_agent() {
    [[ -S $SSH_AUTH_SOCK ]] && [[ -n $SSH_AGENT_PID ]] && [[ -f /proc/$SSH_AGENT_PID/cmdline ]] && grep -q ssh-agent /proc/$SSH_AGENT_PID/cmdline
}

# Main script execution
if [[ ! -f $agentEnv ]] || ! . $agentEnv > /dev/null || ! is_valid_ssh_agent; then
    start_ssh_agent
fi

