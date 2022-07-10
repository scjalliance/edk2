# Reference: https://github.com/tianocore/tianocore.github.io/wiki/Using-EDK-II-with-Native-GCC
#            https://github.com/tianocore/tianocore.github.io/wiki/Common-instructions

ARG DEBIAN_VERSION=11

FROM debian:$DEBIAN_VERSION-slim

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
             ca-certificates \
             build-essential \
             uuid-dev \
             iasl \
             git \
             gcc \
             nasm \
             python-is-python3 \
             && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*
