FROM mcr.microsoft.com/dotnet/core/sdk:3.1-bionic

# To make it easier for build and release pipelines to run apt-get,
# Configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

#Installing the basic files for our pipeline our dependincies Java, zip and docker.
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
        docker.io \
        default-jre \ 
        zip

#Installing dotnet-runtime V2.1 for SonarQube tasks, these will be upgraded to work with 3.1 in the future. Here is the issue from sonarqube https://jira.sonarsource.com/browse/VSTS-230
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb --output packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update; \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  apt-get install -y dotnet-runtime-2.1
WORKDIR /azp
COPY ./src/start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
