FROM ubuntu:resolute

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  wget \
  openssh-client \
  gnupg \
  git \
  vim \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/apt/keyrings \
  && wget -qO /etc/apt/keyrings/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
  && apt-get update \
  && apt-get install -y gh \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash dev
USER dev

ENV PATH="/home/dev/.local/bin:$PATH"
