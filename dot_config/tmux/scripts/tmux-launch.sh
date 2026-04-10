#!/bin/bash

SESSIONNAME="development"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ] 
 then
    tmux new-session -s $SESSIONNAME -n script -d
    tmux send-keys -t $SESSIONNAME "cd ~/clients/vorwerk/current/" C-m 
    tmux send-keys -t $SESSIONNAME "tdlm c" C-m 
fi

tmux attach -t $SESSIONNAME
