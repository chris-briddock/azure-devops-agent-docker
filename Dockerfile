FROM debian:bookworm-slim

# Update and install dependencies
RUN apt update && apt upgrade -y && apt install -y curl git jq libicu72

ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent

ENTRYPOINT ./start.sh
