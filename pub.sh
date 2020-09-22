#!/bin/bash
docker build -t hightechict/azuredevopsagent:pwsh-java .
docker push hightechict/azuredevopsagent:pwsh-java
docker tag hightechict/azuredevopsagent:pwsh-java hightechict/azuredevopsagent:latest
docker push hightechict/azuredevopsagent:latest
