#!/bin/bash

yum update
yum install -y epel-release yum-utils
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
yum install -y php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysql
systemctl start httpd && systemctl enable httpd
yum -y remove mariadb-libs.x86_64
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
yum -y install mysql-community-server --disablerepo=mysql80-community --enablerepo=mysql57-community
systemctl start mysqld && systemctl enable mysqld
pwd=`cat /var/log/mysqld.log | grep -i 'temporary password' | cut -d ' ' -f 11`
echo "Mysql temporary password is: ${pwd}"
mysql -uroot -p${pwd} --connect-expired-password -e "SET GLOBAL validate_password_policy = 0; SET PASSWORD = PASSWORD('123abc..'); FLUSH PRIVILEGES;"
# systemctl stop firewalld
