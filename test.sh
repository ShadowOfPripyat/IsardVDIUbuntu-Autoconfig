#!/usr/bin/expect -f

# Your command
set command "sudo apt install firefox"

# Password to be sent
set password "your_password_here"

# Spawn the command
spawn $command

# Expect a prompt containing "password" and send the password
expect "*password*"
send "$password\r"

# Wait for the command to finish
expect eof
