# linux下oracle无图形化界面安装

Cent OS 6_5(x86_64)下安装Oracle 11g
为了离线安装的大大们提供依赖包：

http://download.csdn.net/download/muluo7fen/9835679 http://download.csdn.net/download/muluo7fen/9850107 

1 硬件要求  
1.1 内存 & swap
物理内存不少于1G

硬盘可以空间不少于5G

swap分区空间不少于2G

Minimum: 1 GB of RAM  

Recommended: 2 GB of RAM or more

1.2 硬盘
由于CentOS安装后差不多有4~5G，再加上Oracle等等的安装，所以请准备至少10G的硬盘空间。

检查磁盘情况 :# df -h

2 软件
系统平台：CentOS6.5(x86_64)无图形界面

Oracle版本：Oracle11g

linux.x64_11gR2_database_1of2.zip

linux.x64_11gR2_database_2of2.zip

3 安装注意
本文中所描述的系统命令，未经特殊标示，均为“#”代表root权限，“$”代表oracle权限。

本文中所描述的所有安装包、依赖包均在附件中，请自行存放位置，以便安装。

本文中的命令和文本内容，不能完全直接复制使用！

4 安装前准备
首先，请先以root账号登入作一些前置设定作业。

输入密码后进入root账户

4.1 操作系统准备
查看主机名

 

 

#hostname

 

显示chances

在/etc/hosts文件内容的最底下添加主机名

 

#vi /etc/hosts

 

注掉原来的，然后添加192.168.206.135 CentOS

 

 #127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4

#::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

127.0.0.1 localhost

192.168.220.158 chances

   

4.2关闭、防火墙
关闭selinux

  

 

#vi /etc/selinux/config

 

设置SELINUX=disabled

 

  

#setenforce 0

防火墙临时关闭命令:

 

#service iptables stop

 

 

4.3安装依赖包
命令：#rpm -ivh 依赖包名（请先进入存放依赖包的目录下）

根据 #ls显示的文件顺序，直接将所有依赖包安装！

因为有依赖关系，所以如果没有出现进度条，并且提示错误信息，那就直接在命令最后，忽略依赖关系，直接安装！

安装命令：#rpm -ivh 依赖包名 --force --nodeps （进入依赖包的目录下，直接执行）

 

#rpm -ivh * --force --nodeps

 

安装依赖过程如下(执行顺序参考，可以忽略)：

rpm -ivh binutils-2.20.51.0.2-5.46.el6.x86_64.rpm --force --nodeps

rpm -ivh cloog-ppl-0.15.7-1.2.el6.x86_64.rpm --force --nodeps

rpm -ivh compat-libstdc++-33-3.2.3-69.el6.i686.rpm --force --nodeps

rpm -ivh compat-libstdc++-33-3.2.3-69.el6.x86_64.rpm --force --nodeps

rpm -ivh cpp-4.4.7-18.el6.x86_64.rpm --force --nodeps

rpm -ivh elfutils-0.164-2.el6.x86_64.rpm --force --nodeps

rpm -ivh elfutils-libelf-0.164-2.el6.x86_64.rpm --force --nodeps

rpm -ivh elfutils-libelf-devel-0.164-2.el6.x86_64.rpm --force --nodeps

rpm -ivh elfutils-libs-0.164-2.el6.x86_64.rpm --force --nodeps

rpm -ivh gcc-4.4.7-4.el6.x86_64.rpm --force --nodeps

rpm -ivh gcc-c++-4.4.7-4.el6.x86_64.rpm --force --nodeps

rpm -ivh glibc-2.12-1.209.el6_9.1.i686.rpm --force --nodeps

rpm -ivh glibc-2.12-1.209.el6_9.1.x86_64.rpm --force --nodeps

rpm -ivh glibc-common-2.12-1.209.el6_9.1.x86_64.rpm --force --nodeps

rpm -ivh glibc-devel-2.12-1.209.el6_9.1.x86_64.rpm --force --nodeps

rpm -ivh glibc-headers-2.12-1.209.el6_9.1.x86_64.rpm --force --nodeps

rpm -ivh ksh-20120801-33.el6.x86_64.rpm --force --nodeps

rpm -ivh libaio-0.3.107-10.el6.i686.rpm --force --nodeps

rpm -ivh libaio-devel-0.3.107-10.el6.i686.rpm --force --nodeps

rpm -ivh libaio-devel-0.3.107-10.el6.x86_64.rpm --force --nodeps

rpm -ivh libgcc-4.4.7-18.el6.i686.rpm --force --nodeps

rpm -ivh libgcc-4.4.7-18.el6.x86_64.rpm --force --nodeps

rpm -ivh libgomp-4.4.7-18.el6.x86_64.rpm --force --nodeps

rpm -ivh libstdc++-4.4.7-18.el6.i686.rpm --force --nodeps

rpm -ivh libstdc++-4.4.7-18.el6.x86_64.rpm --force --nodeps

rpm -ivh libstdc++-devel-4.4.7-18.el6.x86_64.rpm --force --nodeps

rpm -ivh make-3.81-23.el6.x86_64.rpm --force --nodeps

rpm -ivh mpfr-2.4.1-6.el6.x86_64.rpm --force --nodeps

rpm -ivh nss-softokn-freebl-3.14.3-23.3.el6_8.i686.rpm --force --nodeps

rpm -ivh nss-softokn-freebl-3.14.3-23.3.el6_8.x86_64.rpm --force --nodeps

rpm -ivh ppl-0.10.2-11.el6.x86_64.rpm --force --nodeps

rpm -ivh sysstat-9.0.4-33.el6.x86_64.rpm --force --nodeps

rpm -ivh tzdata-java-2017b-1.el6.noarch.rpm --force --nodeps

rpm -ivh unixODBC-2.2.14-14.el6.x86_64.rpm --force --nodeps

rpm -ivh unixODBC-devel-2.2.14-14.el6.x86_64.rpm --force --nodeps



 

 

4.4 创建安装用户、组、目录
4.4.1创建安装用户和组


#groupadd oinstall

#groupadd dba

#useradd -g oinstall -G dba oracle

#passwd oracle

#id oracle

  

输入后可以看到群组的情况：

 

 

4.4.2创建软件安装目录


#mkdir -p /opt/oracle //$ORACLE_BASE

#mkdir -p /opt/oracle/product/112010/db_1 //$ORACLE_HOME

#mkdir /opt/oracle/oradata //存放数据库目录

#mkdir /opt/oracle/inventory

#mkdir /opt/oracle/flash_recovery_area

#chown -R oracle:oinstall /opt/oracle

Chmod -R 775 /opt/oracle

  

4.4.3 将oracle使用者加入到sudo群组中


#vi /etc/sudoers

 

输入上面的命令后，打开sudoers文件进行编辑，找到
root       ALL=(ALL)       ALL 
这行，并且在底下再加入以下命令：（按esc退出insert插入模式，按下i进入编辑模式）

   

 

oracle ALL=(ALL) ALL

 

按下esc，直到退出insert模式，在最底下空白行输入“:wq!”（由于这是一份只读文档所以需要再加上!）并且按下Enter

修改后，可以打开/etc/sudoers文件确认一下修改是否完成

注：修改文件保存退出:“:wq”，不保存直接退出：”:q”，强制执行在命令后加”！”

 

4.5 配置系统环境
4.5.1 修改内核参数
# vi /etc/sysctl.conf

 

修改、添加以下内容（不能小于下面的数值，灰色的是已存在的不能比这个小）

 

kernel.shmall = 2097152

kernel.shmmax = 1073741824

fs.aio-max-nr = 1048576

fs.file-max = 6815744

kernel.shmmni = 4096

kernel.sem = 250 32000 100 128

net.ipv4.ip_local_port_range = 9000 65500

net.core.rmem_default = 262144

net.core.rmem_max = 4194304

net.core.wmem_default = 262144

net.core.wmem_max = 1048576

  

修改完毕后，启用配置

 

#sysctl -p

 

4.5.2修改用户限制文件


#vi /etc/security/limits.conf

 

行末添加以下内容


oracle           soft    nproc           2047

oracle           hard    nproc           16384

oracle           soft    nofile          1024

oracle           hard    nofile         65536

oracle           soft    stack           10240


4.5.3关联设置


#vi /etc/pam.d/login

 

行末添加以下内容:

 

session required  /lib64/security/pam_limits.so

session required   pam_limits.so

 

4.5.4修改/etc/profile


#vi /etc/profile

 

添加以下内容：

 

if [ $USER = "oracle" ]; then

 

if [ $SHELL = "/bin/ksh" ]; then

 

ulimit -p 16384

 

ulimit -n 65536

 

else

 

ulimit -u 16384 -n 65536

 

fi

 

fi

 

 

在root用户下，使用命令source profile使环境变量生效

#source /etc/profile

 

 

4.5.5 修改用户环境变量


#vi /home/oracle/.bash_profile

  

在最底下加入以下内容

 

# For Oracle

 

export  ORACLE_BASE=/opt/oracle;

 

export  ORACLE_HOME=/opt/oracle/product/112010/db_1

 

export  ORACLE_SID=orcl;

 

export  PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin

 

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib

 

if [ $USER = "oracle" ]; then

 

if [ $SHELL = "/bin/ksh" ]; then

 

ulimit -p 16384

 

ulimit -n 65536

 

else

 

ulimit -u 16384 -n 65536

 

fi

 

umask 022

 

fi

   

使环境变量生效

 

#source /home/oracle/.bash_profile

 

查看命令：# env

 

 

 

 

 

5正式安装
5.1解压oracle安装文件
Oracle 11g安装包：将安装包上传至服务器/opt/oracle/ 下面，这两个包属于oracle用户

 

linux.x64_11gR2_database_1of2.zip、linux.x64_11gR2_database_2of2.zip

 

安装包解压命令(使用oracle用户解压 )

 

$unzip linux.x64_11gR2_database_1of2.zip

$unzip linux.x64_11gR2_database_2of2.zip

  

解压完成后/opt/oracle下会生成database目录

 

 

5.2编辑oracle数据库安装应答文件
1、/opt/oracle/database/response（解压后的文件中）下有有db_install.rsp、dbca.rsp和netca.rsp三个应答文件，分别数据库安装文件、建立数据库实例和监听配置安装文件

Vidb_install.rsp

修改以下内容

 

oracle.install.option=INSTALL_DB_SWONLY   //29 行 安装类型

 

ORACLE_HOSTNAME=chances //37 行 主机名称

 

UNIX_GROUP_NAME=oinstall //42 行 安装组

 

INVENTORY_LOCATION=/opt/oracle/inventory //47 行 INVENTORY目录

 

SELECTED_LANGUAGES=zh_CN //78 行 选择语言

 

ORACLE_HOME=/opt/oracle/product/112010/db_1 //83 行 oracle_home

 

ORACLE_BASE=/opt/oracle //88 行 oracle_base

 

oracle.install.db.InstallEdition=EE //99 行 oracle版本

 

oracle.install.db.DBA_GROUP=dba //142行dba用户组

 

oracle.install.db.OPER_GROUP=oinstall //147行oper用户组

 

oracle.install.db.config.starterdb.type=GENERAL_PURPOSE //160行 数据库类型

 

oracle.install.db.config.starterdb.globalDBName=orcl //165行globalDBName

 

oracle.install.db.config.starterdb.SID=orcl //170行SID

 

oracle.install.db.config.starterdb.memoryLimit=800  //192行 自动管理内存的最小内存(M)

 

oracle.install.db.config.starterdb.password.ALL=oracle //233行 设定所有数据库用户使用同一个密码

 

DECLINE_SECURITY_UPDATES=true //385行 设置安全更新

 

 

5.3安装




使用oracle用户安装

 

#su oracle

 

进入刚才解压的database目录

 

$cd /opt/oracle/database/

 

$./runInstaller -silent -responseFile /opt/oracle/response/db_install.rsp -ignorePrereq

 

 

接下来就是等待（有点长，不要着急！！！）开始计时，快的话10分钟左右。（安装好的图示在下页）

安装过程中，如果提示[WARNING]不必理会，此时安装程序仍在后台进行，如果出现[FATAL]，则安装程序已经停止了。

可以在以下位置找到本次安装会话的日志:

/optoracle/oraInventory/logs/installActions2015-06-08_04-00-25PM.log

 

可以使用命令查看日志：后面的地址应该以安装过程中的提示为准

#tail -100f /optoracle/oraInventory/logs/installActions2015-06-08_04-00-25PM.log

 

 

 

从下可以看到：

安装过程是没有任何进度提示的，最多只能通过日志文件查看！

 

 

安装好或者是失败会有提示如下所示，是安装成功的信息提示。

 

 

5.4 安装后操作
按照要求执行脚本。

 

打开新的终端，以root身份登录，执行脚本：

 

#/opt/oracle/inventory/orainstRoot.sh

#/opt/oracle/product/112010/db_1/root.sh

 

完成后，返回原来的终端按下回车键

 

 

Oracle11g的安装就到此结束！

 

 

6 配置监听
编辑oracle安装目录下的netca.rsp应答文件，地址为：

/opt/oracle/database/response/netca.rsp，主要查看以下参数配置：

 

INSTALL_TYPE=""custom""安装的类型

 

LISTENER_NUMBER=1监听器数量

 

LISTENER_NAMES={"LISTENER"}监听器的名称列表

 

LISTENER_PROTOCOLS={"TCP;1521"}监听器使用的通讯协议列表

 

LISTENER_START=""LISTENER""监听器启动的名称

 

检查完毕后，执行命令：

 

$netca /silent /responseFile /opt/oracle/database/response/netca.rsp

 

执行后成功如下所示：

 

 

成功运行后，在/opt/oracle/product/112010/network/admin/中生成listener.ora和sqlnet.ora

 

 

 

安装完成后通过netstat命令可以查看1521端口正在监听（重开一个窗口）

 

#netstat -tnulp | grep 1521

 

错误：

 

出现某某文件too short的错误，很有可能是操作系统有问题，建议重装linux系统。

 

  

错误：

进入红色部分去看一下日志 #cat 路径

 

看到日志一大堆，最下面是关键host的ip回环没有配好，由于新系统，系统的host是默认的。

 

解决：

我们要用自己的host名：

#vi /etc/hosts

这步最早已经做过了（见4.1），这一步完成只是临时的，重启后据说就不行了

 

下面修改正式的内容：

 

#vi /etc/sysconfig/network

 

  

由于上面执行netca的时候已经生成了listener监听了，所以我们需要修改下面文件：

 

$vi $ORACLE_HOME/network/admin/listener.ora

 

这里把localhost 改成本机ip保存退出就好了



下面我们继续开启监听：$lsnrctl start 有一大堆东西，然后就可以继续下一步

 

7 添加数据库实例
7.1 修改/opt/oracle/database/response/dbca.rsp（就是解压安装文件目录下的）
根据数据库建立方式的不同编辑不同的数据库库选项。

比如在本次安装过程中设置了下列参数：(注意下面参数视情况而定，不要照抄，原文件都有说明的)

 

RESPONSEFILE_VERSION ="11.2.0"//不能更改

OPERATION_TYPE ="createDatabase"

GDBNAME ="orcl"//数据库的名字

SID ="ORCL"//对应的实例名字

TEMPLATENAME ="General_Purpose.dbc"//建库用的模板文件

SYSPASSWORD ="oracle"//SYS管理员密码

SYSTEMPASSWORD ="oracle"//SYSTEM管理员密码

SYSMANPASSWORD= "oracle"

DBSNMPPASSWORD= "oracle"

DATAFILEDESTINATION =/opt/oracle/oradata//数据文件存放目录

RECOVERYAREADESTINATION=/opt/oracle/flash_recovery_area//恢复数据存放目录

CHARACTERSET ="ZHS16GBK"//字符集，重要!!!建库后一般不能更改，所以建库前要确定清楚。

TOTALMEMORY ="1638"//1638MB，物理内存2G*80%。

 

7.2 安装
进入oracle安装目录的bin下，执行dbca命令

 

$dbca -silent -responseFile /opt/oracle/database/response/dbca.rsp

 

 

这里界面可能会出现闪动，可以等全部东西都不见了，是要输入SYS密码，但不知道为什么看不见提示，一闪而过。

然后输入完毕按下回车，又看见SYSTEM密码一闪而过，再次输入密码回车，这时就开始建库了。

 

完成(上述输入密码的步骤有可能直接略过)

 

建库后进行实例进程检查：

 

$ps -ef | grep ora_ | grep -v grep



查看监听状态：

 

$ lsnrctl status

  

修改/opt/oracle/product/112010/db_1/bin/dbstart

 

$ vi /opt/oracle/product/112010/db_1/bin/dbstart

 将ORACLE_HOME_LISTNER=$1修改为ORACLE_HOME_LISTNER=$ORACLE_HOME

  

修改/opt/oracle/product/112010/db_1/bin/dbshut

 

$ vi /opt/oracle/product/112010/db_1/bin/dbshut

 

 

将ORACLE_HOME_LISTNER=$1修改为ORACLE_HOME_LISTNER=$ORACLE_HOME

 

修改/etc/oratab文件

 

$vi /etc/oratab

  

将orcl:/data/oracle/product/11.2.0:N中最后的N改为Y，成为

orcl:/data/oracle/product/11.2.0:Y

 

输入命令dbshut和dbstart测试

 

$ dbshut

Oracle监听停止，进程消失。

 

$lsnrctl status

$ps -ef |grep ora_ |grep -v grep



 Oracle 监听启动，进程启动。

 

$ dbstart

$lsnrctl status

$ps -ef |grep ora_ |grep -v grep

 

 

 

登录查看实例状态：

 

$ sqlplus / as sysdba

 

错误：

 

 

解决：

 

$echo $ORACLE_HOME

$echo $ORACLE_SID

$export ORACLE_SID=orcl （sid看自己设的什么）

 

或者$env |grep ORACLE

 

继续

 

SQL> select status from v$instance;

 

 

错误：

 

解决：

该问题一般是认为sid设置混乱造成，oracle安装过程中有几个地方都设置sid和数据库名称之类的，很容易记错。


SQL>shutdown

SQL>quit

$dbshut

 

$echo $ORACLE_SID

或者$env |grep ORACLE

 

$export ORACLE_SID=orcl （sid看自己设的什么）

$dbstart

重新：$sqlplus / as sysdba

SQL>startup

8 收尾
8.1完成之后，我们需要将selinux打开
不然重启会出现问题，无法开机！！！

 

#vi /etc/selinux/config

 

将之前的disabled 改成targeted 然后就可以安心了。

 

8.2检查listener.ora
/opt/oracle/product/112010/db_1/network/admin/listener.ora

 

 

如果在安装监听过程中出现什么问题，可以将这个文件删除，然后重新执行netca步骤

 里面的内容应该是这样的

 

SID_LIST_LISTENER =

  (SID_LIST =

    (SID_DESC =
    
      (GLOBAL_DBNAME = orcl)
    
      (ORACLE_HOME = /opt/oracle/product/112010/db_1)
    
      (SID_NAME = orcl)
    
    )

  )

 

 

LISTENER =

  (DESCRIPTION_LIST =

    (DESCRIPTION =
    
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    
      (ADDRESS = (PROTOCOL = TCP)(HOST = 172.168.1.48)(PORT = 1521))
    
    )

  )

 

ADR_BASE_LISTENER = /opt/oracle

 

接下来：

如果在lsnrctl start 或是lsnrctl status中有看到下面红色部分：

 

那么需要执行以下步骤：

 

sql> alter system register

sql> show parameter local_listener

(address=(protocol=tcp)(host=192.168.129.201)(port=1521))

而listener实际用的ip是192.168.155.100。

发现这台机器有两张网卡，ip分别为：192.168.155.100和192.168.129.201，之前有维护人员大概想将listener绑定到192.168.129.201这个ip上，但采用的方法不对。

修改local_listener参数，sql> alter system set local_listener='';

再重新注册服务，sql> alter system register;

查看注册情况，$ lsnrctl status

 

8.3最后：看看密码


9 卸载ORACLE


Oracle卸载

1.停止监听服务（oracle用户登录）

[oracle@tsp-rls-dbserver ~]$ lsnrctl stop

2.停止数据库

[oracle@tsp-rls-dbserver ~]$ sqlplus / as sysdba

SQL>shutdown

3.删除oracle安装路径（root用户登录）

[root@tsp-rls-dbserver deps]# rm -rf /opt/oracle/product

[root@tsp-rls-dbserver deps]# rm -rf /opt/oracle/inventory

……安装前创建的和安装后生成的都删掉（oracle解压文件database不要误删）

4.删除系统路径文件（root用户登录）

[root@tsp-rls-dbserver deps]# rm -rf /usr/local/bin/dbhome

[root@tsp-rls-dbserver deps]# rm -rf /usr/local/bin/oraenv

[root@tsp-rls-dbserver deps]# rm -rf /usr/local/bin/coraenv

5.删除数据库实例表（root用户登录）

[root@tsp-rls-dbserver deps]# rm -rf /etc/oratab

6.删除数据库实例lock文件（root用户登录）

[root@tsp-rls-dbserver deps]# rm -rf /etc/oraInst.loc

7.删除oracle用户及用户组（root用户登录）重装oracle的话就不用删了

[root@tsp-rls-dbserver deps]# userdel -r oracle

[root@tsp-rls-dbserver deps]# groupdel oinstall

[root@tsp-rls-dbserver deps]# groupdel dba

 

10 其他操作


开启oracle服务：

$dbstart

$lsnrctl start

$sqlplus / as sysdba

SQL>startup

 

 

 

关闭oracle服务：

$dbshut

$lsnrctl stop

$sqlplus / as sysdba

SQL>shutdown