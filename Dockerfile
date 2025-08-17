FROM debian:trixie-slim AS host
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        #for rootless
        dbus-user-session \ 
        slirp4netns \
        uidmap \
        kmod \
        # https://wiki.nftables.org/wiki-nftables/index.php/Building_and_installing_nftables_from_sources
        libmnl \
        libnftnl 


RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc 

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update \
    && apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin 
#    && sed -i 's/ulimit -Hn/# ulimit -Hn/g' /etc/init.d/docker 

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
    

#USER ${NON_ROOT}
#RUN  /usr/bin/dockerd-rootless-setuptool.sh install --skip-iptables
# insmod /lib/modules/`uname -r`/kernel/net/ipv4/netfilter/ip_tables.ko
#USER root
#RUN modprobe nf_tables \
#    && modprobe ip_tables
COPY --chown=${NON_ROOT}:${NON_ROOT} --chmod=770 . ${HOME_DIR}

#USER ${NON_ROOT}

ENTRYPOINT [ "bash", "-c", "while :; do sleep 10; done" ]
#https://github.com/file-get-contents/559.git

