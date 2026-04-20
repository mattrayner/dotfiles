#!/bin/bash

SESSIONNAME="development"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ] 
 then
    # Session doesn't exist - create it and setup
    tmux new-session -s $SESSIONNAME -n script -d
    tmux send-keys -t $SESSIONNAME "cd ~/clients/vorwerk/current/" C-m 
    tmux send-keys -t $SESSIONNAME "tdlm c" C-m 
else
    # Session exists - check if it's a blank/new session (only has default window)
    # If so, run setup commands
    WINDOW_COUNT=$(tmux list-windows -t $SESSIONNAME | wc -l)
    if [ $WINDOW_COUNT -eq 1 ]; then
        # Only one window - this is a fresh session from systemd, run setup
        tmux send-keys -t $SESSIONNAME "cd ~/clients/vorwerk/current/" C-m 
        tmux send-keys -t $SESSIONNAME "tdlm c" C-m 
    fi
fi

# Since tdlm renames the session, rename it back to 'development' for continuum consistency
# Wait a moment for tdlm to complete
sleep 1
CURRENT_SESSION=$(tmux display-message -t $SESSIONNAME -p '#{session_name}' 2>/dev/null)
if [ "$CURRENT_SESSION" != "$SESSIONNAME" ]; then
    tmux rename-session -t "$CURRENT_SESSION" "$SESSIONNAME"
fi

# Only attach if running in an interactive terminal
if [ -t 0 ]; then
    tmux attach -t $SESSIONNAME
fi
