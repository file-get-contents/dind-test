FROM debian:bookworm-slim AS debian-base
RUN sed -i 's|^URIs: http://deb.debian.org/debian$|URIs: http://ftp.jp.debian.org/debian|' /etc/apt/sources.list.d/debian.sources
RUN apt-get update\
    && DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
        ca-certificates \
        curl



FROM debian-base AS host
#RUN apt-get update -y\
#    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#        git \
#        fuse-overlayfs

#####################################################
# install docker                                    #
# https://docs.docker.com/engine/install/debian/    #
####################################################
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc 
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update\
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin \
        docker-buildx-plugin \
        docker-ce-rootless-extras \
        docker-model-plugin
#   && sed -i 's/ulimit -Hn/# ulimit -Hn/g' /etc/init.d/docker 

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


ARG GID=1000
ARG UID=${GID}
ARG NON_ROOT=dinder
ARG HOME_DIR=/home/${NON_ROOT}

RUN groupadd -g ${GID} ${NON_ROOT} \
    && useradd -u ${UID} -g ${NON_ROOT} -s /bin/bash -b /home -m ${NON_ROOT}
    
COPY --chown=${NON_ROOT}:${NON_ROOT} --chmod=770 . ${HOME_DIR}

#USER ${NON_ROOT}
#ENTRYPOINT [ "dockerd", "--log-level", "warn", "--storage-driver", "fuse-overlayfs"]




dockerd --storage-driver vfs

fuse-overlayfs をインストールすると docker run hello-world でこける。
fuse-overlayfs をインストールしないと dockerd コマンドで起動した際に下記エラーが発生する。エラーが発生しても子コンテナの実行はできる。
ERRO[2025-08-24T20:38:22.221625542Z] failed to mount overlay: invalid argument     storage-driver=overlay2
ERRO[2025-08-24T20:38:22.221695959Z] exec: "fuse-overlayfs": executable file not found in $PATH  storage-driver=fuse-overlayfs