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
        default-jre \ 
        zip

# Installing dotnet-runtime V2.1 for SonarQube tasks, these will be upgraded to work with 3.1 in the future. Here is the issue from sonarqube https://jira.sonarsource.com/browse/VSTS-230
# Install also dotnet sdk 3.1
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb --output packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update; \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  apt-get install -y dotnet-runtime-2.1 dotnet-sdk-3.1
