FROM debian:bookworm-slim AS debian-base
RUN sed -i 's|^URIs: http://deb.debian.org/debian$|URIs: http://ftp.jp.debian.org/debian|' /etc/apt/sources.list.d/debian.sources
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl



FROM debian-base AS host
RUN curl -fsSL https://get.docker.com | sh

ARG GID=1000
ARG UID=${GID}
ARG NON_ROOT=dinder
ARG HOME_DIR=/home/${NON_ROOT}

RUN groupadd -g ${GID} ${NON_ROOT} \
    && useradd -u ${UID} -g ${NON_ROOT} -s /bin/bash -b /home -m ${NON_ROOT}
    
COPY --chown=${NON_ROOT}:${NON_ROOT} --chmod=770 . ${HOME_DIR}

#USER ${NON_ROOT}
ENTRYPOINT [ "dockerd", "--log-level", "warn", "--storage-driver", "fuse-overlayfs"]
