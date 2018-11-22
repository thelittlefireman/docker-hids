FROM docker.elastic.co/logstash/logstash:6.5.1
# install geoip-update

ARG DEP_PKG="libcurl-devel zlib-devel git"
RUN id -u -n
USER root
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y ${DEP_PKG}

# install geoip-update
RUN git clone https://github.com/maxmind/geoipupdate \
&& cd geoipupdate \
&& ./bootstrap \
&& ./configure \
&& make \
&& make install

ADD GeoIP.conf /etc/GeoIP.conf

RUN yum remove -y ${DEP_PKG}
RUN yum groupremove -y 'Development Tools'

RUN mkdir - p /var/lib/GeoIP
RUN geoipupdate -v -f /etc/GeoIP.conf -d /var/lib/GeoIP
RUN ls -l -a /var/lib/GeoIP

RUN logstash-plugin install logstash-filter-geoip
RUN logstash-plugin update

# comment out PAM
RUN yum -y install cronie
RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond

#Add your cron file
ADD cron_geoip /etc/cron.d/cron_geoip
RUN chmod 0644 /etc/cron.d/cron_geoip

#This will add it to the cron table (crontab -e)
RUN crontab /etc/cron.d/cron_geoip

CMD crond && tail -f /dev/null