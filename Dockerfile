# syntax=docker/dockerfile:1

FROM ubuntu:22.04 AS base
LABEL maintainer="Nick Richardson njkrichardson@gmail.com" 

WORKDIR /circuit_design

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    build-essential \
    gdb \
    wget \
    cmake \
    clang-format \
    verilator

CMD ["/bin/zsh"]
