# docker-vernemq

Documentation for building a VerneMQ docker image.

It is based on the offical [docker-vernemq](https://github.com/erlio/docker-vernemq) Dockerfile. But the base distro used here is Ubuntu instead.


## Performance tuning

### Disable levelDB

Set environment `VMQ_USE_RAM` to 'y'.

Ref: [Subscriber message delivery performance](https://github.com/erlio/vernemq/issues/771)
