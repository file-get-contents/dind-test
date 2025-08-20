FROM debian:trixie-slim AS host
RUN sed -i 's|^URIs: http://deb.debian.org/debian$|URIs: http://ftp.jp.debian.org/debian|' /etc/apt/sources.list.d/debian.sources
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libtool \
        autoconf \
#        libexpat1-dev\
        make \
        fuse-overlayfs


#########################################################
# install apache2                                       #
# https://httpd.apache.org/docs/2.4/ja/install.html     #
# https://apr.apache.org/download.cgi                   #
# https://github.com/PCRE2Project/pcre2/releases        #
#########################################################
# apr
WORKDIR /root
RUN curl -LO https://dlcdn.apache.org//apr/apr-1.7.6.tar.gz \
    && tar -xzf apr-1.7.6.tar.gz
WORKDIR /root/apr-1.7.6
RUN ./configure \
    && make \
    make install

#apr-iconv
RUN curl -LO https://dlcdn.apache.org//apr/apr-iconv-1.2.2.tar.gz \
    && tar -xzf apr-iconv-1.2.2.tar.gz
WORKDIR /root/apr-iconv-1.2.2
RUN ./configure --with-apr=/usr/local/apr \
    && make \
    make install

#apr-util
RUN curl -LO https://dlcdn.apache.org//apr/apr-util-1.6.3.tar.gz \
    && tar -xzf apr-util-1.6.3.tar.gz
WORKDIR /root/apr-util-1.6.3
RUN ./configure --with-apr=/usr/local/apr \
    && make \
    && make install

# PCRE
RUN curl -LO https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.45/pcre2-10.45.tar.gz \
    && tar -xzf pcre2-10.45.tar.gz
WORKDIR /root/pcre2-10.45
RUN ./configure \
    && make \
    && make install

# apache2
RUN curl -LO https://dlcdn.apache.org/httpd/httpd-2.4.65.tar.gz \
    && tar -xzf httpd-2.4.65.tar.gz
WORKDIR /root/httpd-2.4.65
RUN ./configure \
    && make \
    && make install
