#!/usr/bin/env bash

source ./scripts/helpers/command_exists.sh
source ./scripts/helpers/show_last_line.sh

INSTALL_NAME="lazygit"
INSTALL_LOG_FILE=/tmp/install-lazygit.log

install() {
    brew install lazygit
}

if command_exists "lazygit"; then
    echo "Installing $INSTALL_NAME... Already Installed."
else
    echo "Installing $INSTALL_NAME..."
    install &> $INSTALL_LOG_FILE &
    install_pid=$!
    show_last_line $INSTALL_LOG_FILE $install_pid
    wait $install_pid
    exit_status=$?
    clear_last_line
    clear_last_line

    if [ -z "$exit_status" ] || [ "$exit_status" -ne 0 ]; then
        echo "Installing $INSTALL_NAME... Failed!"
        echo -e "\e[31m--- Installation Log ---" >&2
        cat $INSTALL_LOG_FILE >&2
        echo -e "--- End of Log ---\e[0m" >&2
        rm $INSTALL_LOG_FILE
        exit 1
    else
        echo "Installing $INSTALL_NAME... Done!"
        rm $INSTALL_LOG_FILE
    fi
fi
