#!/usr/bin/env bash

source ./scripts/helpers/command_exists.sh
source ./scripts/helpers/show_last_line.sh

INSTALL_NAME=".bashrc"
INSTALL_LOG_FILE=/tmp/patch-bashrc.log

install() {
    local DOTFILES_PATH="$(pwd)"

    echo "# Dotfiles config" >> ~/.bashrc
    echo "export DOTFILES_PATH=$DOTFILES_PATH" >> ~/.bashrc
    echo "source \$DOTFILES_PATH/.aliases" >> ~/.bashrc
    echo "export PATH=\"$DOTFILES_PATH/bin:\$PATH\"" >> ~/.bashrc
}

if ! grep -q '# Dotfiles config' ~/.bashrc; then
    echo "Patching $INSTALL_NAME..."
    install &> $INSTALL_LOG_FILE &
    install_pid=$!
    show_last_line $INSTALL_LOG_FILE $install_pid
    wait $install_pid
    exit_status=$?
    clear_last_line
    clear_last_line

    if [ -z "$exit_status" ] || [ "$exit_status" -ne 0 ]; then
        echo "Patching $INSTALL_NAME... Failed!"
        echo -e "\e[31m--- Installation Log ---" >&2
        cat $INSTALL_LOG_FILE >&2
        echo -e "--- End of Log ---\e[0m" >&2
        rm $INSTALL_LOG_FILE
        exit 1
    else
        echo "Patching $INSTALL_NAME... Done!"
        rm $INSTALL_LOG_FILE
    fi
else
    echo "Patching $INSTALL_NAME... Already Patched."
fi
