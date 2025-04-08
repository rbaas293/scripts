#!/bin/bash

# Give your session a name
SESSION=mysession

# Create a new tmux session
tmux new-session -d -s $SESSION

# Split the window into 4 horizontal panes
tmux split-window -h
tmux split-window -h
tmux split-window -h

# Split each horizontal pane into 4 vertical panes
for i in {0..3}; do
  tmux split-window -v -t $SESSION:0.$((i * 4))
  tmux split-window -v -t $SESSION:0.$((i * 4 + 1))
  tmux split-window -v -t $SESSION:0.$((i * 4 + 2))
done

# Get the total width and height of the window
total_width=$(tmux display-message -p '#{window_width}')
window_height=$(tmux display-message -p '#{window_height}')
echo "-- $total_width X $window_height"

# Calculate the width and height of each pane
pane_width=$((total_width / 4))
pane_height=$((window_height / 4))
echo "-- $pane_width X $pane_height"

# Set the width and height of each pane
for i in {0..15}; do
  tmux resize-pane -t $SESSION:0.$i -x $pane_width -y $pane_height
done

# Run a command in each pane
# 1-8
for i in {0..7}; do
  j=$(($i + 1))
  tmux send-keys -t $SESSION:0.$i "fish" Enter "clear" Enter "echo gomp0${j}" Enter
done

# 9-16
for i in {8..15}; do
  j=$(($i + 1))
  n=$(($j - 8))
  tmux send-keys -t $SESSION:0.$i "fish" Enter "clear" Enter "echo comp0${n}" Enter
done

# Attach to the session
tmux attach-session -t $SESSION

# Close the session
#tmux kill-session -t $SESSION
