FROM ubuntu:20.04

RUN true \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository universe \
    && apt-get update \
    && apt-get install -y -o Acquire::Retries=50 \
    binutils \
    build-essential \
    g++ \
    gcc \
    gcc-aarch64-linux-gnu \
    gcc-x86-64-linux-gnu \
    git-core \
    iasl \
    make \
    mtools \
    perl \
    python \
    subversion \
    liblzma-dev \
    iasl \
    mtools \
    subversion \
    lzma-dev \
    uuid-dev \
    zip \
    && true

RUN mkdir -p /opt/build
RUN ln -sf /bin/bash /bin/sh

WORKDIR /opt/build
CMD ["make"]
