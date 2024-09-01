clear_last_line() {
    echo -en "\033[1A\033[K"  # Move up one line and clear it
}

show_last_line() {
    local log_file=$1
    local last_line=""

    while true; do
        if [[ -f "$log_file" ]]; then
            local new_last_line=$(tail -n 1 "$log_file")
            if [[ "$new_last_line" != "$last_line" ]]; then
                if [[ -n "$last_line" ]]; then
                    clear_last_line
                fi
                echo "$new_last_line"
                last_line="$new_last_line"
            fi
        fi

        # Check if the background process is still running
        if ! kill -0 $2 2>/dev/null; then
            break
        fi
    done
}
