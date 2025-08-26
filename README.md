# failure docker in docker. 

## purpose 
host(mba) runs development container and development container is watched by delivery container by compose.watch .  
compose.watch needs host-child relation.

## environment
macbook air m1 sequoia15.6

    $ docker info
    Client:
     Version:    28.3.2
     Context:    desktop-linux
     Debug Mode: false
     Plugins:
        compose: Docker Compose (Docker Inc.)
            Version:  v2.39.1-desktop.1
        desktop: Docker Desktop commands (Docker Inc.)
            Version:  v0.2.0

## problems
outside container does not have any kernel modules. so failure when building child container.
