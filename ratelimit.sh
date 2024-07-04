This script implements an API rate limiting mechanism with exponential backoff retries. It includes the following functions:

- `log()`: Logs messages with the current timestamp.
- `run_command()`: Runs the command "gam all users print forward todrive".
- `check_rate_limit()`: Checks if the API rate limit has been exceeded, and resets the API call count and last reset time if necessary.
- `exponential_backoff()`: Implements an exponential backoff algorithm to wait before retrying a failed command.

The script first sets the API rate limit parameters and exponential backoff parameters. It then runs the `run_command()` function and checks if the rate limit has been exceeded or the command failed. If so, it retries the command using exponential backoff up to a maximum number of retries. If the command still fails after the maximum number of retries, the script exits with an error.

Requires: `gam` command line tool for Google Workspace.

https://github.com/GAM-team/GAM
https://github.com/taers232c/GAMADV-XTD3


#!/bin/bash

rate_limit=100  # API rate limit per 100 seconds 
rate_limit_window=100 # Rate limit window in seconds

# Exponential backoff parameters
max_retries=5  # Maximum number of retries 
backoff=2      # Initial backoff time in seconds
max_wait=30    # Max backoff time in seconds

# Count of API calls made 
api_count=0  

# Last time rate limit was reset
last_reset=0  

# Logging 
log() {
  echo "[$(date)] $*"
}

# Run command 
# Replace this with your actual command
run_command() {
  log "Running command: gam all users print forward todrive"
  gam all users print forward todrive
}

# Check if rate limit exceeded 
check_rate_limit() {
  current_time=$(date +%s)  # Get current time in seconds
  
  log "Checking rate limit..."
  # If last reset time is not set or last 100s window has passed, reset count and time
  if [[ $last_reset -eq 0 ]] || [[ $((current_time - last_reset)) -gt $rate_limit_window ]]; then
    log "Resetting API call count and last reset time."
    api_count=0
    last_reset=$current_time
  fi
  
  # Increment API call count 
  api_count=$((api_count+1))
  log "API call count: $api_count"
  
  # If rate limit exceeded, return 1
  if [[ $api_count -gt $rate_limit ]]; then
    log "Rate limit exceeded!"
    return 1
  fi 
}

# Exponential backoff function 
exponential_backoff() {
  # Calculate backoff time 
  backoff_time=$((2 ** $1)) 
  log "Backoff time: $backoff_time seconds."

  # Cap backoff at max_wait 
  if [[ $backoff_time -gt $max_wait ]]; then
    backoff_time=$max_wait
  fi

  # Wait 
  sleep $backoff_time 
}

# Run command and check for failure 
run_command  
if [[ $? -ne 0 ]] || check_rate_limit; then
  log "Command failed or rate limit exceeded. Retrying..."

  # Exponential backoff 
  for i in $(seq 1 $max_retries); do 
    exponential_backoff $i
    run_command
    if [[ $? -eq 0 ]] && ! check_rate_limit; then
      log "Command succeeded after $i retries."  
      exit 0
    fi
  done 
fi

# Failed after max retries 
log "Command failed after $max_retries retries."
exit 1

