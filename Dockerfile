FROM debian:bookworm-slim

# Update and install dependencies
RUN apt update -y && apt upgrade -y && \
    apt install -y curl git jq libicu72 gnupg lsb-release

# Install docker
RUN curl -fsSL https://get.docker.com | sh

ENV TARGETARCH="linux-x64"

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

COPY ./dind-wrapper.sh /usr/local/bin/dind-wrapper.sh
RUN chmod +x /usr/local/bin/dind-wrapper.sh

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

RUN usermod -aG docker agent && \
    newgrp docker

USER agent

VOLUME /var/run/docker.sock

ENTRYPOINT ["/usr/local/bin/dind-wrapper.sh"]
CMD ["./start.sh"]
