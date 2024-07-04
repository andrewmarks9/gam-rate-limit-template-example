This script implements an API rate limiting mechanism with exponential backoff retries. It includes the following functions:

- `log()`: Logs messages with the current timestamp.
- `run_command()`: Runs the command "gam all users print forward todrive".
- `check_rate_limit()`: Checks if the API rate limit has been exceeded, and resets the API call count and last reset time if necessary.
- `exponential_backoff()`: Implements an exponential backoff algorithm to wait before retrying a failed command.

The script first sets the API rate limit parameters and exponential backoff parameters. It then runs the `run_command()` function and checks if the rate limit has been exceeded or the command failed. If so, it retries the command using exponential backoff up to a maximum number of retries. If the command still fails after the maximum number of retries, the script exits with an error.

Requires: `gam` command line tool for Google Workspace.

https://github.com/GAM-team/GAM

https://github.com/taers232c/GAMADV-XTD3


## Installation

To install `ratelimit.sh`, clone this repository or download the script directly into your desired directory:


## Set the script to executable

```bash
chmod +x ratelimit.sh
```

## Usage

Update run_command() block with the code you would like to run

```bash
 run_command() {
  log "Running command: gam all users print forward todrive"
  gam all users print forward todrive
}
```

## Run the script

```bash
./ratelimit.sh
```

## Contributing
Contributions to ratelimit.sh are welcome! Please submit pull requests or open issues to propose changes or report bugs.

## License
ratelimit.sh is released under the MIT License. See the LICENSE file for more details. ``