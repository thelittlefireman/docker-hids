FROM debian:9-slim

RUN apt-get update \
&& apt-get install -y software-properties-common \
&& add-apt-repository ppa:oisf/suricata-stable \
&& apt-get update \
&& apt-get install -y suricata

# Open up the permissions on /var/log/suricata so linked containers can
# see it.
RUN chmod 755 /var/log/suricata

COPY /docker-entrypoint.sh /

VOLUME /var/log/suricata

RUN /usr/sbin/suricata -V

ENTRYPOINT ["/docker-entrypoint.sh"]