# docker-vernemq

Documentation for building a VerneMQ docker image.

It is based on the offical [docker-vernemq](https://github.com/erlio/docker-vernemq) Dockerfile. But the base distro used here is Ubuntu instead.


## Build

    docker build -t vmq:1.7.1-siot-1 .


## Performance tuning

### Disable levelDB

Set environment `VMQ_USE_RAM` to 'y'.

Ref: [Subscriber message delivery performance](https://github.com/erlio/vernemq/issues/771)


## Quick Test Run

  docker run --rm -e VMQ_USE_RAM=y -p 8903:1883 -p 8988:8888 michaelfung/vmq:1.7.1-siot-1
