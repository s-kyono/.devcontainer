FROM debian:12.6-slim

ARG GITHUB_EMAIL
ARG GITHUB_ACCOUNT
ARG GITHUB_ACCESS_TOKEN

ENV GITHUB_EMAIL ${GITHUB_EMAIL}
ENV GITHUB_ACCOUNT ${GITHUB_ACCOUNT}
ENV GITHUB_ACCESS_TOKEN ${GITHUB_ACCESS_TOKEN}

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

# host ssh
  RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# git config settings
RUN git config --global user.email ${GITHUB_EMAIL}

RUN git config --global user.name ${GITHUB_ACCOUNT}

RUN chown -R dev-user:dev-user /init.sh
RUN chmod -R 777 /init.sh

RUN chown -R dev-user:dev-user /srv

WORKDIR /srv

USER dev-user

