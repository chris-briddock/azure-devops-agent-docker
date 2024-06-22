FROM debian:bookworm-slim

# Update and install dependencies
RUN apt update -y && apt upgrade -y && \
    apt install -y curl git jq libicu72 gnupg lsb-release

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io 

# Install BuildKit
RUN curl -fsSL https://github.com/moby/buildkit/releases/download/v0.14.1/buildkit-v0.14.1.linux-amd64.tar.gz | tar -xz -C /usr/local
ENV PATH="/usr/local/bin:${PATH}"

# Set up BuildKit in rootless mode
RUN curl -fsSL https://raw.githubusercontent.com/moby/buildkit/master/examples/systemd/system/buildkit.service -o /etc/systemd/system/buildkit.service && \
    curl -fsSL https://raw.githubusercontent.com/moby/buildkit/master/examples/systemd/system/buildkit.socket -o /etc/systemd/system/buildkit.socket

ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

RUN usermod -aG docker agent && \
    newgrp docker

USER agent

RUN mkdir -p ~/.config/buildkit
COPY --chown=agent:agent buildkitd.toml ~/.config/buildkit/buildkitd.toml

VOLUME /var/run/docker.sock

ENTRYPOINT ./start.sh
