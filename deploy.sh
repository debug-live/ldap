#!/usr/bin/env bash
#1.安装、启动、关闭ldap server
#1.1安装ldap server
sudo apt-get install slapd

#1.2启动ldap server
systemctl start slapd

#1.3关闭ldap server
systemctl stop slapd

#1.4查看ldap server状态
systemctl status slapd

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

#8.删除用户
ldapdelete -x -D "cn=admin,dc=globalvillage,dc=biz" -w 888888 "cn=zhangqingyuan,ou=OPS,dc=globalvillage,dc=biz"

#9.修改用户
#9.1 新增某些字段
sudo cat > /etc/openldap/schema/modify_add.ldif << EOF
dn: cn=zhangqingyuan,ou=OPS,dc=globalvillage,dc=biz
add: mail
mail: 894500671@qq.com
EOF
ldapmodify -x -D "cn=admin,dc=globalvillage,dc=biz" -w 888888 -f /etc/openldap/schema/modify_add.ldif

#9.2 修改某些字段
sudo cat > /etc/openldap/schema/modify_replace.ldif << EOF
dn: cn=zhangqingyuan,ou=OPS,dc=globalvillage,dc=biz
replace: mail
mail: 894500670@qq.com
EOF
ldapmodify -x -D "cn=admin,dc=globalvillage,dc=biz" -w 888888 -f /etc/openldap/schema/modify_replace.ldif

#9.3 删除某些字段
sudo cat > /etc/openldap/schema/modify_delete.ldif << EOF
dn: cn=zhangqingyuan,ou=OPS,dc=globalvillage,dc=biz
delete: mail
EOF
ldapmodify -x -D "cn=admin,dc=globalvillage,dc=biz" -w 888888 -f /etc/openldap/schema/modify_delete.ldif

#9.4 重命名
#deleteoldrdn表示是否删除旧的条目，1-删除，0—不删除
sudo cat > /etc/openldap/schema/modify_rename.ldif << EOF
dn: cn=zhangqingyuan,ou=OPS,dc=globalvillage,dc=biz
changetype: modrdn
newrdn: cn=zqy
deleteoldrdn: 0
EOF
ldapmodify -x -D "cn=admin,dc=globalvillage,dc=biz" -w 888888 -f /etc/openldap/schema/modify_rename.ldif
