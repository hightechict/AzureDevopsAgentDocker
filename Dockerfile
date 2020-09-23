FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

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
        netcat \
        wget \
        liblttng-ust0 \
        libssl1.0.0 \
        docker.io \
        default-jre \ 
        zip

RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/powershell_7.0.3-1.ubuntu.18.04_amd64.deb
RUN dpkg -i powershell_7.0.3-1.ubuntu.18.04_amd64.deb
RUN apt-get install -f
RUN rm powershell_7.0.3-1.ubuntu.18.04_amd64.deb
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp
COPY ./src/start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
