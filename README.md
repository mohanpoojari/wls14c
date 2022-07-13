# Oracle WebLogic Server 14c Docker Overview

This will create a docker image containing an Oracle WLS 14c without a domain

## Building

Placeholder.  Include docker build process. **REPLACE CHANGEME with your project name**
    
    cd /path/to/dockerfile/location
    docker build --rm=true  --tag=some/tag/wls14c -f wls14c.dockerfile .

## Running

Placeholder.  Include simple and typical docker run processes.

    docker run -d --init --restart unless-stopped --name WLS14c some/tag/wls14c

## Connecting

In order to connect to your running container, simply execute the following command:

    docker exec -it WLS14c /bin/bash


[back](./README.md) 