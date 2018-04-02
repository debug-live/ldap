#!/usr/bin/env bash
#1.安装ldap server
sudo apt-get install slapd

#2.重新配置，输入下面这条命令时，弹出图形界面，进入人机交互，这条命令下面的注释，是人机交互的提示和建议项
sudo dpkg-reconfigure slapd
#Omit OpenLDAP server configuration? ... No
#DNS domain name: ... globalvillage.biz        //根据自己需要输入，但必须和后面的相关地方保持一致，例如第三步的命令
#Name of your organization: ... Whatever & Co
#Admin Password: 888888 //自定义密码，这里写888888是为了下面的例子对应
#Confirm Password: 888888
#OK
#BDB
#Do you want your database to be removed when slapd is purged? ... No
#Move old database? ... Yes
#Allow LDAPv2 Protocol? ... No

#3.查询admin用户
ldapsearch -x -b dc=globalvillage,dc=biz

#4.增加用户组
sudo cat > /etc/openldap/schema/ops_group.ldif << EOF
dn: ou=OPS,dc=globalvillage,dc=biz
changetype: add
objectclass: organizationalUnit
ou: OPS
EOF
ldapadd -x -D "cn=admin,dc=globalvillage,dc=biz" -w "888888" -f /etc/openldap/schema/ops_group.ldif


#5.增加用户
sudo cat > /etc/openldap/schema/zqyLdap.ldif << EOF
dn: cn=zhangqingyuan,ou=OPS,dc=globalvillage,dc=biz
objectClass: person
objectClass: inetOrgPerson
objectClass: organizationalPerson
ou: OPS
sn: zhang
uid: qingyuan
cn: zhangqingyuan
EOF
ldapadd -x -D "cn=admin,dc=globalvillage,dc=biz" -w "888888" -f /etc/openldap/schema/zqyLdap.ldif

#6.修改新增用户的密码
ldappasswd -x -D "cn=admin,dc=globalvillage,dc=biz" -w "888888" "cn=zhangqingyuan,ou=OPS,dc=globalvillage,dc=biz" -S
#New password: xxxxx
#Re-enter new password: xxxxx

#7.查询用户和用户组
ldapsearch -x -b "ou=OPS,dc=globalvillage,dc=biz"
