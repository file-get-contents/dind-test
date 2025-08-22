FROM debian:bookworm-slim AS debian-base
RUN sed -i 's|^URIs: http://deb.debian.org/debian$|URIs: http://ftp.jp.debian.org/debian|' /etc/apt/sources.list.d/debian.sources
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl



FROM debian-base AS host
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        fuse-overlayfs

#####################################################
# install docker                                    #
# https://docs.docker.com/engine/install/debian/    #
#####################################################
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

#####################################
# install node                      #
# https://github.com/nvm-sh/nvm     #
#####################################
#WORKDIR /root
#RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
#   && . /root/.bashrc \
#   && nvm install --lts --latest-npm

#########################
# install go            #
# https://go.dev/dl/    #
#########################
#WORKDIR /root
#RUN curl -LO https://go.dev/dl/go1.25.0.linux-amd64.tar.gz \
#    && tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz \
#    && rm -R *
#ENV PATH=$PATH:/usr/local/go/bin



#RUN update-ca-certificates


#RUN cp -au /var/lib/docker /var/lib/docker.bk 
#RUN echo '{"storage-driver": "overlay2"}' > /etc/docker/daemon.json


ARG GID=1000
ARG UID=${GID}
ARG NON_ROOT=dinder
ARG HOME_DIR=/home/${NON_ROOT}

RUN groupadd -g ${GID} ${NON_ROOT} \
    && useradd -u ${UID} -g ${NON_ROOT} -s /bin/bash -b /home -m ${NON_ROOT}
    
COPY --chown=${NON_ROOT}:${NON_ROOT} --chmod=770 . ${HOME_DIR}

#USER ${NON_ROOT}
#ENTRYPOINT [ "dockerd", "-l", "warn", "--storage-driver", "overlay2", "--storage-opt", "overlay2.size=1G" ]
ENTRYPOINT [ "dockerd", "-l", "warn",  "--storage-driver", "fuse-overlayfs"]
