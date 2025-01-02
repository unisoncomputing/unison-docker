FROM debian:bookworm

ARG UCM_VERSION

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
COPY public.gpg /etc/apt/trusted.gpg.d/unison-computing.gpg
COPY unison-computing.list /etc/apt/sources.list.d/unison-computing.list
COPY backports.list /etc/apt/sources.list.d/backports.list
RUN adduser --disabled-password --home /unison unison &&\
    apt-get update &&\
    apt-get -y -t bookworm-backports install unisonweb=${UCM_VERSION} ca-certificates &&\
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen &&\
    dpkg-reconfigure --frontend=noninteractive locales &&\
    update-locale LANG=en_US.UTF-8

ENV UCM_PORT=8080
ENV UCM_TOKEN=public
EXPOSE 8080
WORKDIR /unison
USER unison
ENTRYPOINT ["/usr/bin/ucm"]
