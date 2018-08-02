#!/bin/bash

# $0 is a script name,
# $1, $2, $3 , ...etc are passed arguments
# $1 is our command
CMD=$1

# set env params:
# export MYEVN

case "$CMD" in
  "start" )
    # exec /usr/bin/env perl ./http-echo.pl prefork -w ${FORKS} -l "http://*:${LISTEN_PORT}"
    /usr/sbin/vernemq console
    ;;

   * )
    # Run custom command. Thanks to this line we can still use
    # "docker run our_image /bin/bash" and it will work
    exec $CMD ${@:2}
    ;;
esac
