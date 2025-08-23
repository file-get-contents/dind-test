FROM debian:trixie AS host
#
#ARG GID=1000
#ARG UID=${GID}
#ARG NON_ROOT=dinder
#ARG HOME_DIR=/home/${NON_ROOT}
#RUN groupadd -g ${GID} ${NON_ROOT} \
#    && useradd -u ${UID} -g ${NON_ROOT} -s /bin/bash -b /home -m ${NON_ROOT}
#
#RUN apt-get update -y \
#    && apt-get install -y --no-install-recommends \
#        ca-certificates \
#        curl \
#        #for rootless
#        dbus-user-session \ 
#        slirp4netns \
#        uidmap \
#        iptables \
#        kmod
#
# update-alternatives --set iptables /usr/sbin/iptables-legacy
# update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
#
#
##RUN curl -fsSL https://get.docker.com/rootless | SKIP_IPTABLES=1  sh 
#
#COPY --chown=${NON_ROOT}:${NON_ROOT} --chmod=770 . /app
#WORKDIR /app
#
##CMD [ "bash", "-c", "while :; do sleep 10; done" ]
#CMD ["bash"]