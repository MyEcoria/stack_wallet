#!/bin/bash

while true; do
    # Add your command here
    ./stack_wallet

    # Check the exit status of the last command
    if [ $? -eq 0 ]; then
        echo "Command exited successfully. Exiting loop."
        break
    else
        echo "Command crashed. Restarting..."
        sleep 1  # You can adjust the sleep duration between restarts
    fi
done
