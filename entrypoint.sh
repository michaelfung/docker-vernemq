#!/bin/bash

# $0 is a script name,
# $1, $2, $3 , ...etc are passed arguments
# $1 is our command
CMD=$1
: ${CMD:=start}  # default to start if not set

# set env params:
# export MYEVN

case "$CMD" in
  "start" )
    cd /opt/vernemq
    /usr/local/bin/su-exec nobody:nogroup ./bin/vernemq console -noshell -noinput
    ;;

   * )
    # Run custom command. Thanks to this line we can still use
    # "docker run our_image /bin/bash" and it will work
    exec $CMD ${@:2}
    ;;
esac
