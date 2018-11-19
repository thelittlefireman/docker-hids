FROM debian:9-slim

ENV VERSION 2.0.1
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y curl wget python-pip python-dev git gcc gunicorn tcpdump gnupg2
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs
WORKDIR /tmp/
RUN wget https://github.com/StamusNetworks/scirius/archive/scirius-${VERSION}.tar.gz
RUN mkdir -p /opt/selks/sciriusdata
WORKDIR /opt/selks
RUN tar zxf /tmp/scirius-${VERSION}.tar.gz
RUN ln -sf /opt/selks/scirius-scirius-${VERSION} /opt/selks/scirius
WORKDIR /opt/selks/scirius
RUN npm install -g npm@latest webpack@3.11 && npm install
RUN pip install wheel
RUN pip install pyinotify
RUN pip install --upgrade six
RUN pip install -r requirements.txt

ADD django/scirius.json /tmp/
ADD django/scirius.sh /opt/selks/bin/
RUN chmod ugo+x /opt/selks/bin/scirius.sh
ADD kibana/reset_dashboards.sh /opt/selks/bin/
RUN chmod ugo+x /opt/selks/bin/reset_dashboards.sh
RUN git clone https://github.com/StamusNetworks/KTS6.git  /opt/kibana-dashboards/
RUN pip install elasticsearch-curator

EXPOSE 8000

ENTRYPOINT ["/opt/selks/bin/scirius.sh"]
