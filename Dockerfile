FROM debian:12.6-slim

COPY ./init.sh /init.sh

# install git vim ca-certificates curl gpg lsb-release
RUN apt-get update && apt-get -y upgrade && \
  apt-get install -y git vim ca-certificates curl gpg lsb-release sudo

RUN groupadd -g 1200 docker


# docker cli
RUN  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
      apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# create dev-user
RUN useradd -m -d /home/dev-user -s /bin/bash -G docker,sudo dev-user && \
  echo dev-user:dev-user | chpasswd && echo "dev-user ALL=(root) NOPASSWD: /bin/chgrp" >> /etc/sudoers

RUN chown -R dev-user:dev-user /srv

WORKDIR /srv

USER dev-user

# config git


