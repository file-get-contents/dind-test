
#FROM docker:dind-rootless
#FROM docker:28-dind

FROM debian:bookworm-slim AS host
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git
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
RUN update-ca-certificates
RUN git config --global user.name "file-get-contents" \
    && git config --global user.email ymstmsy2@gmal.com
COPY --chown=www-data:www-data --chmod=770 . /app
#RUN apk add apache2


#https://github.com/file-get-contents/559.git