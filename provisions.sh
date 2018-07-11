#!/bin/bash

yum update
yum install -y epel-release yum-utils wget 2> /dev/null
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm 2> /dev/null

# 安装 PHP 7.2
yum-config-manager --enable remi-php72
yum install -y php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysql 2> /dev/null
systemctl start httpd && systemctl enable httpd

# 安装 MySQL 5.7
yum -y remove mariadb-libs.x86_64 2> /dev/null
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm 2> /dev/null
yum -y install mysql-community-server --disablerepo=mysql80-community --enablerepo=mysql57-community 2> /dev/null
systemctl start mysqld && systemctl enable mysqld

# 修改 MySQL 密码
pwd=`cat /var/log/mysqld.log | grep -i 'temporary password' | cut -d ' ' -f 11` # 查询临时密码
echo "Mysql temporary password is: ${pwd}"
mysql -uroot -p${pwd} --connect-expired-password -e "SET GLOBAL validate_password_policy = 0; SET PASSWORD = PASSWORD('123abc..'); FLUSH PRIVILEGES;" 2> /dev/null

# 添加 PHP 测试文件
touch /var/www/html/info.php
echo '<?php phpinfo(); ?>' > /var/www/html/info.php

# 清理 yum
yum clean all
rm -rf /var/cache/yum
# systemctl stop firewalld # 停止防火墙
