#!/usr/bin/env bash

# Alias
echo "alias ll='ls -alF' --color=auto" >> /home/vagrant/.bashrc

# Verifica aggiornamenti
echo "Aggiornamento pacchetti..."
apt-get update
apt-get dist-upgrade -y
apt-get install -y vim net-tools
echo "FINE"

# Instrallazione prerequisiti eXtraWay
dpkg --add-architecture i386
apt-get update
apt-get install -y libgcc1:i386 libzip4:i386 libc6:i386 libxml2:i386 libxslt1.1:i386 \
                libcurl4:i386 libncurses5:i386 libreadline7:i386 libstdc++6:i386

ln -s /usr/lib/x86_64-linux-gnu/libreadline.so.7 /usr/lib/x86_64-linux-gnu/libreadline.so.6
ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
ln -s /usr/lib/i386-linux-gnu/libzip.so.4 /usr/lib/i386-linux-gnu//libzip.so.2

useradd -m extraway -d /opt/3di.it -s /bin/bash
cp /home/vagrant/.bashrc /opt/3di.it/.bashrc
grep -qxF 'kernel.shmmax=268435456' /etc/sysctl.conf || echo "kernel.shmmax=268435456" >> /etc/sysctl.conf && sysctl -p
grep -qxF '0 0 * * 0 /bin/rm -f /opt/3di.it/extraway/xw/conversion/*.xml >/dev/null 2>&1' /etc/crontab || echo "0 0 * * 0 /bin/rm -f /opt/3di.it/extraway/xw/conversion/*.xml >/dev/null 2>&1" >> /etc/crontab

tar -C /opt/ -xzf /vagrant/eXtraWay-platform-*-linux.tar.*
chown -R extraway:extraway /opt

cp /opt/3di.it/extra/systemd-script/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable {extraway,docway-fcs,docway-fca,docway-msa,tomcat7,tomcat8}
systemctl start {extraway,docway-fcs,docway-fca,docway-msa,tomcat7}

# Installazione prerequisiti docway fca-fcs

apt-get install -y libreoffice tesseract-ocr poppler-utils imagemagick

# Installazione MongoDB

wget https://www.mongodb.org/static/pgp/server-3.6.asc && apt-key add server-3.6.asc
echo "deb [arch=amd64] http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
apt-get update && apt-get install -y mongodb-org-server mongodb-org-shell

systemctl enable mongod
systemctl start {mongod,tomcat8}
