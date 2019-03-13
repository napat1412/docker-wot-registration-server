FROM rust:1.33-stretch as rust-builder

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

# Create a non privileged user to build the Rust code.
RUN useradd -m -d /home/user -p user user
COPY . /home/user
RUN chown -R user /home/user

WORKDIR /home/user

ENV PATH=/home/user/.cargo/bin:/home/user/bin:$PATH
WORKDIR /home/user/server
RUN cargo build --release --features mysql

#----------------------------------------------------
FROM debian:stretch as pdns-builder

ENV DEBIAN_FRONTEND=noninteractive

ENV SHELL=/bin/bash

RUN apt-get update && \
    apt-get dist-upgrade -qqy && \
    apt-get install -y \
       bzip2 \
       ca-certificates \
       curl \
       g++ \ 
       gcc \
       libboost-all-dev \ 
       libc6-dev \
       libmariadbclient-dev-compat \
       libpq-dev \
       libsqlite3-dev \
       libssl-dev \
       libssl-dev \
       libtool \
       make \
       pkgconf \
       sqlite \ 
       -qqy \
       --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install powerdns 4.1.5
RUN curl https://downloads.powerdns.com/releases/pdns-4.1.5.tar.bz2 | tar xvjf -

RUN cd pdns-4.1.5 && ./configure --with-modules=remote && make && make install 

#----------------------------------------------------

FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive

ENV SHELL=/bin/bash

RUN apt-get update && \
    apt-get dist-upgrade -qqy && \
    apt-get install -y \
       ca-certificates \
       libmariadbclient-dev-compat \
       libsqlite3-dev \
       libssl-dev \
       --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY --from=pdns-builder /usr/local/sbin /usr/local/sbin
RUN useradd -m -d /home/user -p user user
COPY --from=rust-builder /home/user /home/user
RUN chown -R user /home/user

WORKDIR /home/user
CMD ["./entrypoint.sh"]
