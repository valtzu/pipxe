FROM ubuntu:21.10

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
    perl \
    python \
    liblzma-dev \
    lzma-dev \
    uuid-dev \
    zip \
    wget \
    && true

# mtools version 4.0.32 in the ubuntu repo as of 2022-03-26 does not work, so let's download a working version manually
RUN \
    wget https://ftp.gnu.org/gnu/mtools/mtools_4.0.38_amd64.deb \
    && dpkg -i mtools_4.0.38_amd64.deb \
    && true

RUN mkdir -p /opt/build
RUN ln -sf /bin/bash /bin/sh

WORKDIR /opt/build
CMD ["make", "-j8"]
