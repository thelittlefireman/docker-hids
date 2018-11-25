#!/bin/bash

cd /opt/selks/scirius/

migrate_db() {
	python manage.py migrate
}

create_db() {
	python manage.py migrate --noinput
	python manage.py loaddata /tmp/scirius.json
	python manage.py createcachetable my_cache_table
	python manage.py addsource "ETOpen Ruleset" https://rules.emergingthreats.net/open/suricata-4.0/emerging.rules.tar.gz http sigs
	#python manage.py addsource "SSLBL abuse.ch" https://sslbl.abuse.ch/blacklist/sslblacklist.rules http sig
	python manage.py addsource "PT Research Ruleset" https://raw.githubusercontent.com/ptresearch/AttackDetection/master/pt.rules.tar.gz http sigs
	python manage.py defaultruleset "Default SELKS ruleset"
	python manage.py disablecategory "Default SELKS ruleset" stream-events
	python manage.py addsuricata suricata "Suricata on SELKS" /etc/suricata/rules "Default SELKS ruleset"
	python manage.py updatesuricata
}

start() {
	webpack
	echo "Starting scirius server."
	python manage.py runserver 0.0.0.0:8000
}

# update requirements if needed
pip install -r requirements.txt
#fix issue
pip install --upgrade django-filter~=1.1
pip freeze

if [ ! -e "/sciriusdata/scirius.sqlite3" ]; then
	create_db
else
	migrate_db
fi

/opt/selks/bin/reset_dashboards.sh &

start
