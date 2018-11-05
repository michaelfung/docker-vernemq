#!/bin/bash

# $0 is a script name,
# $1, $2, $3 , ...etc are passed arguments
# $1 is our command
CMD=$1
: ${CMD:=start}  # default to start if not set

# set env params:
# export MYEVN


#
# disable leveldb to speed up perf when using QoS 1/2
# credit: https://github.com/chriswue
#
disable_leveldb() {
    cd /opt/vernemq/bin
    while [ : ]; do
        ./vmq-admin metrics show > /dev/null
        if [ $? -eq 0 ]; then
            echo "found running vernemq, disabling leveldb ..."
            ./vmq-admin plugin disable -m vmq_lvldb_store -f msg_store_write -a 2
            ./vmq-admin plugin disable -m vmq_lvldb_store -f msg_store_find -a 1
            ./vmq-admin plugin disable -m vmq_lvldb_store -f msg_store_read -a 2
            ./vmq-admin plugin disable -m vmq_lvldb_store -f msg_store_delete -a 2
            echo "... leveldb disabled"
            exit 0
        fi
        echo "vernemq not yet running, waiting a few secs ..."
        sleep 3
    done
}

if [ -n ${VMQ_USE_RAM} ] ; then
    disable_leveldb &
fi

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
