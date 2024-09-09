#!/bin/bash

LOG_FILE="nginx_access.log"

generate_ip() {
    echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}
generate_timestamp() {
    echo $(date +"[%d/%b/%Y:%H:%M:%S +0000]")
}

generate_log_line() {
    local route_number=$(printf "%03d" $1) # 001, 002, 003, etc.
    local ip=$(generate_ip)
    local timestamp=$(generate_timestamp)
    local method="GET"
    local route="/route/$route_number"
    local status="200"
    local bytes_sent="$((RANDOM % 1000 + 500))"
    local referrer="\"-\""
    local user_agent="\"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36\""

    # Format: IP - - [timestamp] "METHOD route HTTP/1.1" status bytes_sent "referrer" "user-agent"
    echo "$ip - - $timestamp \"$method $route HTTP/1.1\" $status $bytes_sent $referrer $user_agent" >> $LOG_FILE
}

route_counter=1 # Starting route number
interval=5 # Seconds between logs (customize this)

while true; do
    generate_log_line $route_counter
    echo "Generated log for /route/$(printf "%03d" $route_counter)"
    route_counter=$((route_counter + 1)) # Increment the route number
    sleep $interval # Wait for the defined interval before generating the next log
done


