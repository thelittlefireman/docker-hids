FROM ubuntu:latest

ARG libhtp_v="0.5.x"
ARG suricata_v="suricata-4.1.0"

ARG COMPILE_PKG="build-essential"
ARG BUILD_PKG="autoconf automake python ragel liblzma-dev libpcre3 liblz4-dev libpcre3-dbg libhiredis-dev libpcre3-dev build-essential libluajit-5.1-dev libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev libnss3-dev libgeoip-dev liblua5.1-dev libhiredis-dev libevent-dev"

RUN apt-get update \
&& apt-get install -y git ${COMPILE_PKG} ${BUILD_PKG} \
geoip-bin geoip-database geoipupdate apt-transport-https rustc cargo cmake ragel libboost-dev

# INSTALL HYPERSCAN
RUN git clone https://github.com/intel/hyperscan \
&& cd hyperscan \
&& mkdir build  \
&& cd build \
&& cmake -DBUILD_STATIC_AND_SHARED=1 ../ \
&& make -j "$(grep -c ^processor /proc/cpuinfo)" \
&& make install \
&& echo "/usr/local/lib" | tee --append /etc/ld.so.conf.d/usrlocal.conf \
&& ldconfig

# SURICATA


RUN cd / && git clone --branch ${suricata_v} https://github.com/OISF/suricata.git \
&& cd suricata \
&& git clone https://github.com/OISF/libhtp.git -b ${libhtp_v} \
&& cd libhtp \
&& ./autogen.sh \
&& ./configure \
&& make -j "$(grep -c ^processor /proc/cpuinfo)" \
&& make install \
&& cd .. \
&& ./autogen.sh \
&& ./configure --enable-geoip --enable-hiredis --enable-lua --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
&& make -j "$(grep -c ^processor /proc/cpuinfo)" \
&& make install-full \
&& ldconfig

RUN apt-get remove -y ${COMPILE_PKG} && apt-get autoremove -y

#add tcmalloc improvement: https://suricata.readthedocs.io/en/suricata-4.0.5/performance/tcmalloc.html
RUN apt-get install -y libtcmalloc-minimal4

# Open up the permissions on /var/log/suricata so linked containers can
# see it.
RUN mkdir -p /var/log/suricata && chmod 755 /var/log/suricata

COPY /docker-entrypoint.sh /

VOLUME /var/log/suricata

RUN suricata -V && suricata --build-info

ENTRYPOINT ["/docker-entrypoint.sh"]
