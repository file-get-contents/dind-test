FROM debian:bookworm-slim AS host
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        #for rootless
        dbus-user-session \ 
        slirp4netns \
        uidmap

RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc 

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y \
    && apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
    && sed -i 's/ulimit -Hn/# ulimit -Hn/g' /etc/init.d/docker 

RUN update-ca-certificates

#https://github.com/microsoft/WSL/issues/7466
#RUN update-alternatives --set iptables /usr/sbin/iptables-legacy \
#    && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

ARG GID=1000
ARG UID=${GID}
ARG NON_ROOT=dinder
ARG HOME_DIR=/home/${NON_ROOT}

RUN groupadd -g ${GID} ${NON_ROOT} \
    && useradd -u ${UID} -g ${NON_ROOT} -s /bin/bash -b /home -m ${NON_ROOT}
    
    
USER ${NON_ROOT}
WORKDIR /usr/bin
RUN  dockerd-rootless-setuptool.sh install --skip-iptables

#RUN  /usr/bin/dockerd-rootless-setuptool.sh install --skip-iptables

#USER root
#RUN modprobe nf_tables \
#    && modprobe ip_tables
COPY --chown=${NON_ROOT}:${NON_ROOT} --chmod=770 . ${HOME_DIR}
#ENTRYPOINT [ "bash", "-c", "$HOME/entrypoint.sh" ]
ENTRYPOINT [ "bash", "-c", "while :; do sleep 10; done" ]


#https://github.com/file-get-contents/559.git


#Alternatively iptables checks can be disabled with --skip-iptables .



#dinder@39967a19d21f:/$ /usr/bin/dockerd-rootless-setuptool.sh install --skip-iptables
#[INFO] systemd not detected, dockerd-rootless.sh needs to be started manually:
#
#PATH=/usr/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh  --iptables=false

#[INFO] Creating CLI context "rootless"
#Successfully created context "rootless"
#[INFO] Using CLI context "rootless"
#Current context is now "rootless"
#
#[INFO] Make sure the following environment variable(s) are set (or add them to ~/.bashrc):
## WARNING: systemd not found. You have to remove XDG_RUNTIME_DIR manually on every logout.
#export XDG_RUNTIME_DIR=/home/dinder/.docker/run
#export PATH=/usr/bin:$PATH
#
#[INFO] Some applications may require the following environment variable too:
#export DOCKER_HOST=unix:///home/dinder/.docker/run/docker.sock
#
#dinder@39967a19d21f:/$ systemd