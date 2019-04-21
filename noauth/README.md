# Test newly build image

Base on default config and allow anonymous access.

Copy the **vmq-config** folder to some place like your HOME.

The changes from stock config:

1. set allow_anonymous = on

2. listen on 0.0.0.0 for ports 1883 and 8888, instead of 127.0.0.1


## create container

```
docker run -d --name vmq-test \
  -v /home/mike/vmq-config:/opt/vernemq/etc \
  -p 8903:1883 -p 8988:8888 \
  vmq:1.7.1-siot-1

```

With levelDB disabled:

```
docker run -d --name vmq-test \
  -e VMQ_USE_RAM=y \
  -v /home/mike/vmq-config:/opt/vernemq/etc \
  -p 8903:1883 -p 8988:8888 \
  vmq:1.7.1-siot-1

```


Test with mosquitto client:

## start a subscriber

    mosquitto_sub -d -h 127.0.0.1 -p 8903 -t test/topic

## pub a message and see if it show on subscriber console

    mosquitto_pub -d -h 127.0.0.1 -p 8903 -t test/topic -m "hello world"
