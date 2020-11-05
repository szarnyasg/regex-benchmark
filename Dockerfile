FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

# Install common packages
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        gnupg2 \
        locales \
        software-properties-common \
        tzdata \
        unzip \
        wget

# Set the locale and timezone
RUN locale-gen en_US.UTF-8 && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## C
RUN apt-get install -yq --no-install-recommends \
        libpcre2-dev

## Crystal
RUN curl -sSL https://dist.crystal-lang.org/apt/setup.sh | bash && \
    apt-get install -yq --no-install-recommends \
        crystal

## C++
RUN apt-get install -yq --no-install-recommends \
        libboost-regex-dev

## C# Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        mono-devel

## C# .Net Core
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        dotnet-sdk-3.1

## D - DMD
RUN wget -q http://downloads.dlang.org/releases/2.x/2.089.0/dmd_2.089.0-0_amd64.deb -O dmd_2.089.0-0_amd64.deb && \
    dpkg -i --ignore-depends=libcurl3 dmd_2.089.0-0_amd64.deb

## D - LDC
RUN apt-get install -yq --no-install-recommends \
        ldc

## Dart
RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        dart && \
    ln -s /usr/lib/dart/bin/dart2native  /usr/local/bin/dart2native

## Go
RUN add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        golang-go

## Java - Open
RUN apt-get install -yq --no-install-recommends \
        openjdk-11-jre \
        openjdk-11-jdk

## Javascript - Node
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && \
    apt-get install -yq --no-install-recommends \
        nodejs

## Kotlin
RUN wget -q https://github.com/JetBrains/kotlin/releases/download/v1.3.50/kotlin-compiler-1.3.50.zip -O kotlin-compiler-1.3.50.zip && \
    unzip kotlin-compiler-1.3.50.zip -d /opt/ && \
    echo 'export PATH=$PATH:/opt/kotlinc/bin' >> ~/.bashrc && \
    ln -s /opt/kotlinc/bin/kotlin /usr/local/bin/kotlin && \
    ln -s /opt/kotlinc/bin/kotlinc /usr/local/bin/kotlinc

## Nim
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | sh -s -- -y && \
    ln -s /root/.nimble/bin/nim /usr/local/bin/nim

## PHP
RUN apt-get install -yq --no-install-recommends \
        php7.2-cli

## Python 2
RUN apt-get install -yq --no-install-recommends \
        python2.7

## Python 3
RUN apt-get install -yq --no-install-recommends \
        python3.6

## Ruby
RUN apt-get install -yq --no-install-recommends \
        ruby-full

## Rust
RUN wget -q https://sh.rustup.rs -O rustup-init.sh && \
    chmod +x rustup-init.sh && \
    ./rustup-init.sh -y && \
    rm rustup-init.sh && \
    echo 'export PATH=$HOME/.cargo/bin:$PATH' >> ~/.bashrc && \
    ln -s /root/.cargo/bin/cargo /usr/local/bin/cargo

## Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/regex

CMD ["/usr/bin/php", "/var/regex/run-benchmarks.php"]
