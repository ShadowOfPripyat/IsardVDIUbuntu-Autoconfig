#!/usr/bin/expect
set command "sudo apt update"
set PASS [lindex $argv 1]
set timeout 1
spawn $command
expect -exact "Enter new UNIX password: "
send -- "$PASS\r"
expect "*password*"
send -- "$PASS\r"
expect eof
