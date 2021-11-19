#!/bin/sh

sudo apt-get -y install postgresql-12
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'password';"