FROM distributedx/docker-base-builder:latest

WORKDIR /astron

COPY cmake/ cmake/
COPY src/ src/
COPY test/ test/
COPY CMakeLists.txt CMakeLists.txt

RUN cmake . && make

FROM ubuntu:20.04

WORKDIR /astron

RUN mkdir -p logs && mkdir -p databases

RUN apt update && apt install libuv1-dev -y && rm -rf /var/lib/apt/lists/*

COPY --from=0 /astron/astrond .

CMD ["./astrond", "--loglevel",  "info",  "config/config.yml"]