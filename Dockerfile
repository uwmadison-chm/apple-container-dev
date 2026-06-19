FROM ubuntu:resolute
ARG USER=your_user
ARG UID=your_uid

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

RUN useradd --uid $UID -m -s /bin/bash $USER
USER $USER
ENV PATH="/home/$USER/.local/bin:$PATH"
RUN cat >> /home/$USER/.bashrc << 'EOF'
export PATH="/home/$USER/.local/bin:$PATH"
EOF

WORKDIR /tmp

# Bake whatever tools you might want into your image -- or install them in your
# container at runtime.
# For example, here's claude:
# RUN curl -fsSL https://claude.ai/install.sh | bash
# and uv:
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /home/$USER/.local/bin/

# Run entrypoint.sh as root so we can set our SSH_AUTH_SOCK permissions correctly
USER root
ENV CONTAINER_USER=$USER
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
