FROM mcr.microsoft.com/powershell:lts-ubuntu-18.04

# To make it easier for build and release pipelines to run apt-get,
# Configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Installing the basic files for Azure DevOps Agent

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat

# INSTALL Azure DevOps Agent
		
WORKDIR /azp
COPY ./src/start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]

# INSTALL DOCKER

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        docker.io

# INSTALL JAVA and ZIP for our pipeline our own dependencies

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        zip

