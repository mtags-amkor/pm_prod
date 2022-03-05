#!/bin/bash
set -ex

sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php.ini
sed -i '/post_max_size = 8M/c\post_max_size = 24M' /etc/php.ini
sed -i '/upload_max_filesize = 2M/c\upload_max_filesize = 24M' /etc/php.ini
sed -i '/;date.timezone =/c\date.timezone = America/New_York' /etc/php.ini
sed -i '/expose_php = On/c\expose_php = Off' /etc/php.ini

sed -i '/;opcache.enable_cli=0/c\opcache.enable_cli=1' /etc/php.d/10-opcache.ini
sed -i '/opcache.max_accelerated_files=4000/c\opcache.max_accelerated_files=10000' /etc/php.d/10-opcache.ini
sed -i '/;opcache.max_wasted_percentage=5/c\opcache.max_wasted_percentage=5' /etc/php.d/10-opcache.ini
sed -i '/;opcache.use_cwd=1/c\opcache.use_cwd=1' /etc/php.d/10-opcache.ini
sed -i '/;opcache.validate_timestamps=1/c\opcache.validate_timestamps=1' /etc/php.d/10-opcache.ini
sed -i '/;opcache.fast_shutdown=0/c\opcache.fast_shutdown=1' /etc/php.d/10-opcache.ini



cd /tmp && tar -C /opt -xzf processmaker-3.5.7-community.tar.gz
chown -R apache. /opt/processmaker

cp /etc/hosts ~/hosts.new
sed -i "/127.0.0.1/c\127.0.0.1 localhost localhost.localdomain `hostname`" ~/hosts.new
cp -f ~/hosts.new /etc/hosts

#chkconfig sendmail on && service sendmail start
#chkconfig httpd on && service httpd start

chmod 770 /opt/processmaker/shared
cd /opt/processmaker/workflow/engine/
chmod 770 config content/languages plugins xmlform js/labels

chkconfig php-fpm on && service php-fpm start &
#service php-fpm restart

chkconfig supervisord on && service supervisord start &


touch /etc/sysconfig/network 

rm -f /etc/httpd/run/httpd.pid 


chkconfig httpd on && service httpd start &
#/usr/sbin/httpd -D FOREGROUND &

#/usr/sbin/httpd -D FOREGROUND "$@"
apachectl -D FOREGROUND
