#!/usr/bin/expect -f

spawn bash -c "scp -r * woong@lnxsrv.seas.ucla.edu:~/CS131/Homework3"

expect {
  -re ".*es.*o.*" {
    exp_send "yes\r"
    exp_continue
  }
  -re ".*sword.*" {
    exp_send "cg9wuuvp
    \r"
  }
}
interact