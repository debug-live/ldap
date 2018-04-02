#!/usr/bin/env bash
#1.安装ldap server
sudo apt-get install slapd

#2.重新配置，输入下面这条命令时，弹出图形界面，进入人机交互，这条命令下面的注释，是人机交互的提示和建议项
sudo dpkg-reconfigure slapd
#Omit OpenLDAP server configuration? ... No
#DNS domain name: ... debuntu.local        //根据自己需要输入，但必须和后面的相关地方保持一致
#Name of your organization: ... Whatever & Co
#Admin Password: XXXXX
#Confirm Password: XXXXX
#OK
#BDB
#Do you want your database to be removed when slapd is purged? ... No
#Move old database? ... Yes
#Allow LDAPv2 Protocol? ... No

#3.查询admin用户
ldapsearch -x -b dc=soleray,dc=local
