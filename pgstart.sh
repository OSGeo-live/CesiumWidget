#!/usr/bin/env bash
chown -Rf postgres:postgres /data/postgresql
chmod -R 700 /data/postgresql
su -u postgres /usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf