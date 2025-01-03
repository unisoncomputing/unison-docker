FROM debian:bookworm

ARG UCM_VERSION

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
COPY public.gpg /etc/apt/trusted.gpg.d/unison-computing.gpg
COPY unison-computing.list /etc/apt/sources.list.d/unison-computing.list
COPY backports.list /etc/apt/sources.list.d/backports.list
RUN adduser --disabled-password --home /codebase unison &&\
    apt-get update &&\
    apt-get -y -t bookworm-backports install fzf unisonweb=${UCM_VERSION} &&\
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen &&\
    dpkg-reconfigure --frontend=noninteractive locales &&\
    update-locale LANG=en_US.UTF-8 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
ENV UCM_PORT=8080
ENV UCM_TOKEN=public
EXPOSE 8080
WORKDIR /codebase
USER unison
ENTRYPOINT ["/usr/bin/ucm"]
CMD ["-c", "/codebase"]