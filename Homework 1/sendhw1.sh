#!/usr/bin/expect -f

spawn scp hw1.ml woong@lnxsrv.seas.ucla.edu:~/CS131/Homework1/hw1.ml

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

spawn scp hw1sample.ml woong@lnxsrv.seas.ucla.edu:~/CS131/Homework1/hw1sample.ml

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

spawn scp hw1test.ml woong@lnxsrv.seas.ucla.edu:~/CS131/Homework1/hw1test.ml

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