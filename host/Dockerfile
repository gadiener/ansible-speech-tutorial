FROM debian:9.5

WORKDIR /root

RUN apt-get update && \
    apt-get install -y \
        dbus \
        rsyslog \
        iputils-ping \
        netbase \
        net-tools \
        python \
        openssh-server \
        nano \
        sudo \
        curl \
        python-yaml \
        python-jinja2 \
        python-paramiko \
        python-crypto \
        python-pip

RUN pip install \
    docker-py \
    docker-compose

RUN mkdir ~/.ssh && ssh-keygen -N "" -t rsa -f ~/.ssh/id_rsa

COPY files/id_rsa.pub /root/.ssh/authorized_keys
COPY files/entrypoint.sh /bin/entrypoint

ENV ALLOW_EXIT true

CMD entrypoint
