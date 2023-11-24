D:\phpStudy\MySQL\bin>mysqld --install mysql_cy --defaults-file=D:\phpStudy\MySQL\my.ini
mysqld --remove mysql_cy
其中mysql_cy为要创建的服务名



总和查询语句：select 学号，sum(分数) from 表名 group by 学号 order by 学号;
通过当前日期now()函数查询年龄：
              select year(now())-year(出生日期)+1 as 年龄 from 表名;

insert into 表名(字段名,字段名, … ) values( 字段值,字段值,…);


EXCEL中通过身份证（在B2列）计算
           （C2列）出生日期公式：=DATE(MID(B2,7,4),MID(B2,11,2),MID(B2,13,2))
                   获取性别：=TEXT(-1^MID(B2,15,3),"女;男")
                   获取年龄：=DATEDIF(C2,TODAY(),"y")

select @@tx_isolation;
start transaction;
update tx set num=10 where id=1;


在where 条件中在哪个表字段加(+)就表示返回其字段相等的记录


from 表1 left join 表2 on 条件 （左连接）：返回包括左表中的所有记录和右表中连接字段相等的记录。


right join （右连接）：返回包括右表中的所有记录和左表中连接字段相等的记录。


inner join （等值连接）：只返回两个表中连接字段相等的行。


full join （全外连接）：返回左右表中所有的记录和左右表中连接字段相等的记录。

natural join（自然连接）：就是两个有一个或者以上相同字段名称列（自然连接列，并且不能为该列指定限制词——如 p.category其中p就是限制词）的表进行自动连接，连接后只保留一个列，   【select p.product_id,category_id,category_name from product_information p natural join categories ca;（正确sql语句）】


笛卡尔积：如果没有同名列（自然连接列）做为搜索条件的话，却还要使两个表进行两两组合的话，（select * from countries natural join categories）


内连接（inner join）和外连接（outer join）的区别：内连接（inner可以省略）只是显示匹配的记录（所以数据可能不完整），而外连接未匹配成功的部分数据（）也显示出来。

左连接：对连接条件中左边的表不加限制（即所有的行都出现在结果集中）；
右连接：多连接条件中右边的表不加限制；
全连接：对两个表都不加限制，两个表中的行都会出现在结果集中。
交叉连接：即没有where子句的交叉连接时涉及的笛卡尔积。

union查询：取得两个或者多个select 语句查询结果集的并集（会自动去掉结果集中的重复行），如果union 后面加上all就不会取消重复行；
union all查询：取得结果集的并集，但不会取消重复行，不会排序；
intersect查询：查询结果集的交集（即查询所谓的重复行）；
minus查询：差集



聚合函数：1）均值函数：avg();2）求和函数：sum();3）计数函数：count();


当由比较运算符引入子查询的时候，子查询返回的必须是单值；当由 in、all、exists、any等引入子查询时，子查询返回的多行值。有的时候也可以在比较运算符后面加入in、all、exists、any等的时候，子查询也是返回多行值。
exists表示存在的意思；


索引：create [unique|bitmap] index index_name
      on table_name(col[asc|desc);
     【注】col表示列名
     创建的索引没有被默认成使用，查询的时候要强制使用索引
     ：select /*+ index ( table_name[index_name])*/ 列名 from table_name;
查看索引：select * from user_indexes where table_name='table_name';
        user_indexes视图和all_indexes，第一个table_name不变。第二个table_name是创建索引的实在表名。【例子】——select *from user_indexes  where table_name='tpshop';
       重新命名索引：alter index 旧的索引名 rename to 新的索引名;
       重建索引 ： alter index 重建的索引名 rebuild;
       删除索引 ： drop  index 索引名;


视图: 一种查询机制（一张可视化的虚拟表，但不具备表的某些功能（没有数据））。

FK_COURSE_ID

FK_STUDENT_ID

PK_RESULT_ID


MySQL
  （1）显示所有数据库
    show database；
  （2）显示所有表
    show tables；
  （3）显示表结构
     desc 表名；
查看表结构：desc 表名（oracle）;


存储过程：create or replace procedure 存储过程名称 as 
          begin 
          存储过程定义 



          end 存储过程名称;


触发器：是一种与表操作有关的数据库对象，当触发器所在表上出现指定事件时，将调用该对象，即表的操作事件触发表上的触发器执行。


分页查询：rownum（oracle）,linit（mysql）


1、主键，Oracle不可以实现自增，mysql可以实现自增。 

       oracle新建序列，SEQ_USER_Id.nextval 

2、索引： 

       mysql索引从0开始，Oracle从1开始。 

3、分页， 

      mysql: select * from user order by desc limit n ,m. 

             表示，从第n条数据开始查找，一共查找m条数据。 

      Oracle：select * from user 
              select rownum a * from ((select * from user)a) 
              select * from (select rownum a.* from (select * from user) a ) 
              where r between n , m . 

表示，n表示从第n条数据查询，查找到m条数据。

  递归查询：
     SELECT * from
     CONNECT BY {PRIOR列名1=列名2|列名1=PRIOR列名2}
     [START WITH]；
     start with initial-condition connect by nocycle recurse-condition 主要的目的：从表中取出树状数据，递归查询;prior放的左右位置决定了检索是自底向上还是自顶向下,其中：CONNECT BY子句说明每行数据将是按层次顺序检索，并规定将表中的数据连入树型结构的关系中。PRIORY运算符必须放置在连接关系的两列中某一个的前面。对于节点间的父子关系，PRIOR运算符在一侧表示父节点，在另一侧表示子节点，从而确定查找树结构是的顺序是自顶向下还是自底向上。在连接关系中，除了可以使用列名外，还允许使用列表达式。START WITH子句为可选项，用来标识哪个节点作为查找树型结构的根节点。若该子句被省略，则表示所有满足查询条件的行作为根节点。




col deptno heading "编号"…… 把deptno这个column"编号"

alter table abc add/drop c number;想数据表abc中添加/删除c字段

grant select  on (执行这条语句的所在用户名中的表)表A to 另一个用户名  ……另一个用户名授权给A表，即可以通过“用户名.表A”跨用户名操作另一个用户名中的表


DECODE(L.ORG_STRUT_FAR_ID, '-1','浙能集团',
              (SELECT ORG_STRUT_L_NAME FROM XSR_XZ_PM_ORG_STRUT_L WHERE ORG_STRUT_L_ID = L.ORG_STRUT_FAR_ID)) ORG_STRUT_FAR_NAME



Dblink---可以跨本地数据库访问另外一个数据库表中的数据
语句：CREATE [SHARED] [PUBLIC] database link link_name
　　[CONNECT TO [user] [current_user] IDENTIFIED BY password]　
　　[AUTHENTICATED BY user IDENTIFIED BY password]　
　　[USING 'connect_string']

Mysql ：start----------------------------------------------------------------
show databases;
use 数据库名;
show tables;
show variables like 'char%';  /*显示编码格式*/
show create table _category;  /*查询数据库和表的编码*/
show full columns from 表名;

ALTER DATABASE `数据库` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci 

　　ALTER TABLE `数据表` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci   （注：此句把表默认的字符集和所有字符列（CHAR,VARCHAR,TEXT）改为新的字符集：）


  alter table tb_anniversary convert to character set utf8; /*mysql将表的字符编码转换成utf-8*/

 select @@tx_isolation;/*查看数据库的事务*/



mysql -h172.17.159.163 -uroot -pbaodongmei520131

explain SQL语句;/*Explain命令可以让我们查看MYSQL执行一条SQL所选择的执行计*/

 -----------------创建序列 start

先建一个序列表，如下： 
      /*创建--Sequence 管理表*/
        CREATE TABLE IF NOT EXISTS `sequence` (`name` varchar(50) NOT NULL,`current_value` int(11) NOT NULL,`increment` int(11) NOT NULL DEFAULT '1') ENGINE=MyISAM DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='序列表，命名s_[table_name]'; 
  
     INSERT INTO `sequence` (`name`, `current_value`, `increment`) VALUES('s_blog_account', 0, 1) 

/*创建--取当前值的函数*/
DROP FUNCTION IF EXISTS `currval`;  
DELIMITER //  
CREATE  FUNCTION `currval`(seq_name VARCHAR(50)) RETURNS int(11)
    LANGUAGE SQL 
    DETERMINISTIC 
    CONTAINS SQL 
    SQL SECURITY DEFINER 
    READS SQL DATA  
    COMMENT ''  
BEGIN  
    DECLARE VALUE INTEGER;   
    SET VALUE = 0;  
    SELECT current_value INTO VALUE 
           FROM sequence 
           WHERE NAME = seq_name;  
    RETURN VALUE;  
END//  
DELIMITER ;


/*创建--取下一个值的函数*/
   DROP FUNCTION IF EXISTS `nextval`;  
DELIMITER //  
CREATE  FUNCTION `nextval`(seq_name VARCHAR(50)) RETURNS int(11)  
    DETERMINISTIC  
BEGIN  
UPDATE sequence SET current_value = current_value + increment WHERE NAME = seq_name;  
RETURN currval(seq_name);  
END//  
DELIMITER ;
 

最后使用select nextval("s_blog_account")即可得到下一个值

 -----------------创建序列 end

Mysql :end-------------------------------------------------------------------

Oracle :start ---------------------------------------------------------------
   %ROWTYPE：(表的某一行记录变量)表示该类型为行数据类型，存储的时候为一行数据，一行有很多列，相当于表中的一行数据，也可以的游标中的一行数据。
 
  B  A.a%TYPE; --B变量与另一个已经定义的A.a(表的某一列)类型相同

1)例子:
DECLARE   
  V_ORG_NAME SF_ORG.ORG_NAME%TYPE; --与ORG_NAME类型相同  
  V_PARENT_ID SF_ORG.PARENT_ID%TYPE;--与PARENT_ID类型相同  
BEGIN  
  SELECT ORG_NAME,PARENT_ID INTO V_ORG_NAME,V_PARENT_ID  
  FROM SF_ORG SO  
  WHERE SO.ORG_ID=&ORG_ID;  
  DBMS_OUTPUT.PUT_LINE('部门名称：' || V_ORG_NAME);  
  DBMS_OUTPUT.PUT_LINE('上级部门编码：' || TO_CHAR(V_PARENT_ID));  
END;  

select name from v$datafile;
select * from v$logfile;
select name from v$controlfile;


update test set address=REPLACE(select address from test, '10.101.3.190', '111.59.38.12:8088') 

 system默认:manager sys默认:change_on_install


E_Rows 是优化器评估返回的行数
A_Rows 是市级执行是返回的行数


Oracle命令（一）：Oracle登录命令
1、运行SQLPLUS工具

　　C:\Users\wd-pc>sqlplus

2、直接进入SQLPLUS命令提示符

　　C:\Users\wd-pc>sqlplus /nolog

3、以OS身份连接 

　　C:\Users\wd-pc>sqlplus / as sysdba   或

　　SQL>connect / as sysdba

4、普通用户登录

　　C:\Users\wd-pc>sqlplus scott/123456 　或

　　SQL>connect scott/123456  或

　　SQL>connect scott/123456@servername

5、以管理员登录

　　C:\Users\wd-pc>sqlplus sys/123456 as sysdba　或

　　SQL>connect sys/123456 as sysdba

6、切换用户

　　SQL>conn hr/123456 

　　注：conn同connect

 7、退出

　　exit



Oracle数据库常用sql语句

ORACLE 常用的SQL语法和数据对象
一.数据控制语句 (DML) 部分

1.INSERT (往数据表里插入记录的语句)

INSERT INTO 表名(字段名1, 字段名2, ……) VALUES ( 值1, 值2, ……);
INSERT INTO 表名(字段名1, 字段名2, ……) SELECT (字段名1, 字段名2, ……) FROM 另外的表名;

字符串类型的字段值必须用单引号括起来, 例如: ’GOOD DAY’
如果字段值里包含单引号’ 需要进行字符串转换, 我们把它替换成两个单引号''.
字符串类型的字段值超过定义的长度会出错, 最好在插入前进行长度校验.

日期字段的字段值可以用当前数据库的系统时间SYSDATE, 精确到秒
或者用字符串转换成日期型函数TO_DATE(‘2001-08-01’,’YYYY-MM-DD’)
TO_DATE()还有很多种日期格式, 可以参看ORACLE DOC.
年-月-日 小时:分钟:秒 的格式YYYY-MM-DD HH24:MI:SS

INSERT时最大可操作的字符串长度小于等于4000个单字节, 如果要插入更长的字符串, 请考虑字段用CLOB类型,
方法借用ORACLE里自带的DBMS_LOB程序包.

INSERT时如果要用到从1开始自动增长的序列号, 应该先建立一个序列号
CREATE SEQUENCE 序列号的名称 (最好是表名+序列号标记) INCREMENT BY 1 START WITH 1
MAXVALUE 99999 CYCLE NOCACHE;
其中最大的值按字段的长度来定, 如果定义的自动增长的序列号 NUMBER(6) , 最大值为999999
INSERT 语句插入这个字段值为: 序列号的名称.NEXTVAL

2.DELETE (删除数据表里记录的语句)

DELETE FROM表名 WHERE 条件;

注意：删除记录并不能释放ORACLE里被占用的数据块表空间. 它只把那些被删除的数据块标成unused.

如果确实要删除一个大表里的全部记录, 可以用 TRUNCATE 命令, 它可以释放占用的数据块表空间
TRUNCATE TABLE 表名;
此操作不可回退.

3.UPDATE (修改数据表里记录的语句)

UPDATE表名 SET 字段名1=值1, 字段名2=值2, …… WHERE 条件;

如果修改的值N没有赋值或定义时, 将把原来的记录内容清为NULL, 最好在修改前进行非空校验;
值N超过定义的长度会出错, 最好在插入前进行长度校验..

注意事项:
A. 以上SQL语句对表都加上了行级锁,
确认完成后, 必须加上事物处理结束的命令 COMMIT 才能正式生效,
否则改变不一定写入数据库里.
如果想撤回这些操作, 可以用命令 ROLLBACK 复原.

B. 在运行INSERT, DELETE 和 UPDATE 语句前最好估算一下可能操作的记录范围,
应该把它限定在较小 (一万条记录) 范围内,. 否则ORACLE处理这个事物用到很大的回退段.
程序响应慢甚至失去响应. 如果记录数上十万以上这些操作, 可以把这些SQL语句分段分次完成,
其间加上COMMIT 确认事物处理.
二.数据定义 (DDL) 部分
1.CREATE (创建表, 索引, 视图, 同义词, 过程, 函数, 数据库链接等)

ORACLE常用的字段类型有
CHAR 固定长度的字符串
VARCHAR2 可变长度的字符串
NUMBER(M,N) 数字型M是位数总长度, N是小数的长度
DATE 日期类型

创建表时要把较小的不为空的字段放在前面, 可能为空的字段放在后面

创建表时可以用中文的字段名, 但最好还是用英文的字段名

创建表时可以给字段加上默认值, 例如 DEFAULT SYSDATE
这样每次插入和修改时, 不用程序操作这个字段都能得到动作的时间

创建表时可以给字段加上约束条件
例如 不允许重复 UNIQUE, 关键字 PRIMARY KEY

2.ALTER (改变表, 索引, 视图等)

改变表的名称
ALTER TABLE 表名1 TO 表名2;

在表的后面增加一个字段
ALTER TABLE表名 ADD 字段名 字段名描述;

修改表里字段的定义描述
ALTER TABLE表名 MODIFY字段名 字段名描述;

给表里的字段加上约束条件
ALTER TABLE 表名 ADD CONSTRAINT 约束名 PRIMARY KEY (字段名);
ALTER TABLE 表名 ADD CONSTRAINT 约束名 UNIQUE (字段名);

把表放在或取出数据库的内存区
ALTER TABLE 表名 CACHE;
ALTER TABLE 表名 NOCACHE;

3.DROP (删除表, 索引, 视图, 同义词, 过程, 函数, 数据库链接等)

删除表和它所有的约束条件
DROP TABLE 表名 CASCADE CONSTRAINTS;

4.TRUNCATE (清空表里的所有记录, 保留表的结构)

TRUNCATE 表名;

三.查询语句 (SELECT) 部分
SELECT字段名1, 字段名2, …… FROM 表名1, [表名2, ……] WHERE 条件;

字段名可以带入函数
例如: COUNT(*), MIN(字段名), MAX(字段名), AVG(字段名), DISTINCT(字段名),
TO_CHAR(DATE字段名,'YYYY-MM-DD HH24:MI:SS')

NVL(EXPR1, EXPR2)函数
解释:
IF EXPR1=NULL
RETURN EXPR2
ELSE
RETURN EXPR1

DECODE(AA﹐V1﹐R1﹐V2﹐R2....)函数
解释:
IF AA=V1 THEN RETURN R1
IF AA=V2 THEN RETURN R2
..…
ELSE
RETURN NULL

LPAD(char1,n,char2)函数
解释:
字符char1按制定的位数n显示，不足的位数用char2字符串替换左边的空位

字段名之间可以进行算术运算
例如: (字段名1*字段名1)/3

查询语句可以嵌套
例如: SELECT …… FROM
(SELECT …… FROM表名1, [表名2, ……] WHERE 条件) WHERE 条件2;

两个查询语句的结果可以做集合操作
例如: 并集UNION(去掉重复记录), 并集UNION ALL(不去掉重复记录), 差集MINUS, 交集INTERSECT

分组查询
SELECT字段名1, 字段名2, …… FROM 表名1, [表名2, ……] GROUP BY字段名1
[HAVING 条件] ;

两个以上表之间的连接查询

SELECT字段名1, 字段名2, …… FROM 表名1, [表名2, ……] WHERE
表名1.字段名 = 表名2. 字段名 [ AND ……] ;

SELECT字段名1, 字段名2, …… FROM 表名1, [表名2, ……] WHERE
表名1.字段名 = 表名2. 字段名(+) [ AND ……] ;

有(+)号的字段位置自动补空值

查询结果集的排序操作, 默认的排序是升序ASC, 降序是DESC

SELECT字段名1, 字段名2, …… FROM 表名1, [表名2, ……]
ORDER BY字段名1, 字段名2 DESC;

字符串模糊比较的方法

INSTR(字段名, ‘字符串’)>0
字段名 LIKE ‘字符串%’ [‘%字符串%’]

每个表都有一个隐含的字段ROWID, 它标记着记录的唯一性.

四.ORACLE里常用的数据对象 (SCHEMA)
1.索引 (INDEX)

CREATE INDEX 索引名ON 表名 ( 字段1, [字段2, ……] );
ALTER INDEX 索引名 REBUILD;

一个表的索引最好不要超过三个 (特殊的大表除外), 最好用单字段索引, 结合SQL语句的分析执行情况,
也可以建立多字段的组合索引和基于函数的索引

ORACLE8.1.7字符串可以索引的最大长度为1578 单字节
ORACLE8.0.6字符串可以索引的最大长度为758 单字节

2.视图 (VIEW)

CREATE VIEW 视图名AS SELECT …. FROM …..;
ALTER VIEW视图名 COMPILE;

视图仅是一个SQL查询语句, 它可以把表之间复杂的关系简洁化.

3.同义词 (SYNONMY)
CREATE SYNONYM同义词名FOR 表名;
CREATE SYNONYM同义词名FOR 表名@数据库链接名;

4.数据库链接 (DATABASE LINK)
CREATE DATABASE LINK数据库链接名CONNECT TO 用户名 IDENTIFIED BY 密码 USING ‘数据库连接字符串’;

数据库连接字符串可以用NET8 EASY CONFIG或者直接修改TNSNAMES.ORA里定义.

数据库参数global_name=true时要求数据库链接名称跟远端数据库名称一样

数据库全局名称可以用以下命令查出
SELECT * FROM GLOBAL_NAME;

查询远端数据库里的表
SELECT …… FROM 表名@数据库链接名;

五.权限管理 (DCL) 语句
1.GRANT 赋于权限
常用的系统权限集合有以下三个:
CONNECT(基本的连接), RESOURCE(程序开发), DBA(数据库管理)
常用的数据对象权限有以下五个:
ALL ON 数据对象名, SELECT ON 数据对象名, UPDATE ON 数据对象名,
DELETE ON 数据对象名, INSERT ON 数据对象名, ALTER ON 数据对象名

GRANT CONNECT, RESOURCE TO 用户名;
GRANT SELECT ON 表名 TO 用户名;
GRANT SELECT, INSERT, DELETE ON表名 TO 用户名1, 用户名2;

2.REVOKE 回收权限

REVOKE CONNECT, RESOURCE FROM 用户名;
REVOKE SELECT ON 表名 FROM 用户名;
REVOKE SELECT, INSERT, DELETE ON表名 FROM 用户名1, 用户名2;

查询数据库中第63号错误：
select orgaddr,destaddr from sm_histable0116 where error_code='63';

查询数据库中开户用户最大提交和最大下发数： select MSISDN,TCOS,OCOS from ms_usertable；

查询数据库中各种错误代码的总和：
select error_code,count(*) from sm_histable0513 group by error_code order
by error_code;

查询报表数据库中话单统计种类查询。
select sum(Successcount) from tbl_MiddleMt0411 where ServiceType2=111
select sum(successcount),servicetype from tbl_middlemt0411 group by servicetype

oracle常用SQL语句


1、连接SQL*Plus system/manager
2、显示当前连接用户SQL> show user
3、查看系统拥有哪些用户SQL> select * from all_users;
4、新建用户并授权SQL> create user a identified by a;（默认建在SYSTEM表空间下）SQL> grant connect,resource to a;
5、连接到新用户SQL> conn a/a
6、查询当前用户下所有对象SQL> select * from tab;
7、建立第一个表SQL> create table a(a number);
8、查询表结构SQL> desc a
9、插入新记录SQL> insert into a values(1);
10、查询记录SQL> select * from a;
11、更改记录SQL> update a set a=2;
12、删除记录SQL> delete from a;
13、回滚SQL> roll;SQL> rollback;
14、提交SQL> commit;
---------------------------------------------------------------
----------------------------------------------------------------
用户授权:GRANT ALTER ANY INDEX TO "user_id "GRANT "dba " TO "user_id ";ALTER USER "user_id " DEFAULT ROLE ALL创建用户:CREATE USER "user_id " PROFILE "DEFAULT " IDENTIFIED BY " DEFAULT TABLESPACE "USERS " TEMPORARY TABLESPACE "TEMP " ACCOUNT UNLOCK;GRANT "CONNECT " TO "user_id ";用户密码设定:ALTER USER "CMSDB " IDENTIFIED BY "pass_word "表空间创建:CREATE TABLESPACE "table_space " LOGGING DATAFILE 'C:\ORACLE\ORADATA\dbs\table_space.ora' SIZE 5M
------------------------------------------------------------------------
1、查看当前所有对象
SQL > select * from tab;
2、建一个和a表结构一样的空表
SQL > create table b as select * from a where 1=2;
SQL > create table b(b1,b2,b3) as select a1,a2,a3 from a where 1=2;
3、察看数据库的大小，和空间使用情况
SQL > col tablespace format a20SQL > select b.file_id　　文件ID,　　b.tablespace_name　　表空间,　　b.file_name　　　　　物理文件名,　　b.bytes　　　　　　　总字节数,　　(b.bytes-sum(nvl(a.bytes,0)))　　　已使用,　　sum(nvl(a.bytes,0))　　　　　　　　剩余,　　sum(nvl(a.bytes,0))/(b.bytes)*100　剩余百分比　　from dba_free_space a,dba_data_files b　　where a.file_id=b.file_id　　group by b.tablespace_name,b.file_name,b.file_id,b.bytes　　order by b.tablespace_name　　/　　dba_free_space --表空间剩余空间状况　　dba_data_files --数据文件空间占用情况 4、查看现有回滚段及其状态
SQL > col segment format a30SQL > SELECT SEGMENT_NAME,OWNER,TABLESPACE_NAME,SEGMENT_ID,FILE_ID,STATUS FROM DBA_ROLLBACK_SEGS;
5、查看数据文件放置的路径
SQL > col file_name format a50SQL > select tablespace_name,file_id,bytes/1024/1024,file_name from dba_data_files order by file_id;
6、显示当前连接用户
SQL > show user
7、把SQL*Plus当计算器
SQL > select 100*20 from dual;
8、连接字符串
SQL > select 列1 | |列2 from 表1;SQL > select concat(列1,列2) from 表1;
9、查询当前日期
SQL > select to_char(sysdate,'yyyy-mm-dd,hh24:mi:ss') from dual;
10、用户间复制数据
SQL > copy from user1 to user2 create table2 using select * from table1;
11、视图中不能使用order by，但可用group by代替来达到排序目的
SQL > create view a as select b1,b2 from b group by b1,b2;
12、通过授权的方式来创建用户
SQL > grant connect,resource to test identified by test;
SQL > conn test/test
13、查出当前用户所有表名。
select unique tname from col;
-----------------------------------------------------------------------
/* 向一个表格添加字段 */alter table alist_table add address varchar2(100);
/* 修改字段 属性 字段为空 */alter table alist_table modify address varchar2(80);
/* 修改字段名字 */create table alist_table_copy as select ID,NAME,PHONE,EMAIL,QQ as QQ2, /*qq 改为qq2*/ADDRESS from alist_table;
drop table alist_table;rename alist_table_copy to alist_table/* 修改表名 */
空值处理有时要求列值不能为空create table dept (deptno number(2) not null, dname char(14), loc char(13));
在基表中增加一列alter table deptadd (headcnt number(3));
修改已有列属性alter table deptmodify dname char(20);注：只有当某列所有值都为空时，才能减小其列值宽度。只有当某列所有值都为空时，才能改变其列值类型。只有当某列所有值都为不空时，才能定义该列为not null。例：alter table dept modify (loc char(12));alter table dept modify loc char(12);alter table dept modify (dname char(13),loc char(12)); 
查找未断连接select process,osuser,username,machine,logon_time ,sql_textfrom v$session a,v$sqltext b where a.sql_address=b.address;
-----------------------------------------------------------------1.以USER_开始的数据字典视图包含当前用户所拥有的信息, 查询当前用户所拥有的表信息:select * from user_tables;2.以ALL_开始的数据字典视图包含ORACLE用户所拥有的信息,查询用户拥有或有权访问的所有表信息:select * from all_tables;
3.以DBA_开始的视图一般只有ORACLE数据库管理员可以访问:select * from dba_tables;
4.查询ORACLE用户：conn sys/change_on_installselect * from dba_users;conn system/manager;select * from all_users;
5.创建数据库用户：CREATE USER user_name IDENTIFIED BY password;GRANT CONNECT TO user_name;GRANT RESOURCE TO user_name;授权的格式: grant (权限) on tablename to username;删除用户(或表):drop user(table) username(tablename) (cascade);6.向建好的用户导入数据表IMP SYSTEM/MANAGER FROMUSER = FUSER_NAME TOUSER = USER_NAME FILE = C:\EXPDAT.DMP COMMIT = Y7.索引create index [index_name] on [table_name]( "column_name ")intersect运算
返回查询结果中相同的部分
exp:各个部门中有哪些相同的工种
selectjob
fromaccount
intersect
selectjob
fromresearch
intersect
selectjob
fromsales;

minus运算
返回在第一个查询结果中与第二个查询结果不相同的那部分行记录。
有哪些工种在财会部中有，而在销售部中没有？
exp:selectjobfromaccount
minus
selectjobfromsales;
1. oracle安装完成后的初始口令? 
　internal/oracle 
　　sys/change_on_install 
　　system/manager 
　　scott/tiger 
　　sysman/oem_temp

2. oracle9ias web cache的初始默认用户和密码？ 
administrator/administrator

3. oracle 8.0.5怎么创建数据库? 
用orainst。假如有motif界面，可以用orainst /m

4. oracle 8.1.7怎么创建数据库? 
dbassist

5. oracle 9i 怎么创建数据库? 
dbca

6. oracle中的裸设备指的是什么? 
裸设备就是绕过文件系统直接访问的储存空间

7. oracle如何区分 64-bit/32bit 版本？？？ 
$ sqlplus '/ as sysdba' 
sql*plus: release 9.0.1.0.0 - production on mon jul 14 17:01:09 2003 
(c) copyright 2001 oracle corporation. all rights reserved. 
connected to: 
oracle9i enterprise edition release 9.0.1.0.0 - production 
with the partitioning option 
jserver release 9.0.1.0.0 - production 
sql> select * from v$version; 
banner 
---------------------------------------------------------------- 
oracle9i enterprise edition release 9.0.1.0.0 - production 
pl/sql release 9.0.1.0.0 - production 
core 9.0.1.0.0 production 
tns for solaris: version 9.0.1.0.0 - production 
nlsrtl version 9.0.1.0.0 - production 
sql>

8. svrmgr什么意思？ 
svrmgrl，server manager. 
9i下没有，已经改为用sqlplus了 
sqlplus /nolog 
变为归档日志型的

9. 请问如何分辨某个用户是从哪台机器登陆oracle的? 
select machine , terminal from v$session;

10. 用什么语句查询字段呢？ 
desc table_name 可以查询表的结构 
select field_name,... from ... 可以查询字段的值 
select * from all_tables where table_name like '%' 
select * from all_tab_columns where table_name='??'

11. 怎样得到触发器、过程、函数的创建脚本？ 
desc user_source 
user_triggers

12. 怎样计算一个表占用的空间的大小？ 
select owner,table_name, 
num_rows, 
blocks*aaa/1024/1024 "size m", 
empty_blocks, 
last_analyzed 
from dba_tables 
where table_name='xxx'; 
here: aaa is the value of db_block_size ; 
xxx is the table name you want to check

13. 如何查看最大会话数？ 
select * from v$parameter where name like 'proc%'; 
sql> 
sql> show parameter processes 
name type value 
------------------------------------ ------- ------------------------------ 
aq_tm_processes integer 1 
db_writer_processes integer 1 
job_queue_processes integer 4 
log_archive_max_processes integer 1 
processes integer 200 
这里为200个用户。 
select * from v$license; 
其中sessions_highwater纪录曾经到达的最大会话数

14. 如何查看系统被锁的事务时间？ 
select * from v$locked_object ;

15. 如何以archivelog的方式运行oracle。 
init.ora 
log_archive_start = true 
restart database

16. 怎么获取有哪些用户在使用数据库 
select username from v$session;

17. 数据表中的字段最大数是多少? 
表或视图中的最大列数为 1000

18. 怎样查得数据库的sid ? 
select name from v$database; 
也可以直接查看 init.ora文件

19. 如何在oracle服务器上通过sqlplus查看本机ip地址 ? 
select sys_context('userenv','ip_address') from dual; 
假如是登陆本机数据库，只能返回127.0.0.1，呵呵

20. unix 下怎么调整数据库的时间？ 
su -root 
date -u 08010000

21. 在oracle table中如何抓取memo类型字段为空的数据记录? 
select remark from oms_flowrec where trim(' ' from remark) is not null ;


22. 如何用bbb表的数据去更新aaa表的数据(有关联的字段) 
up2003-10-17 aaa set bns_snm=(select bns_snm from bbb where aaa.dpt_no=bbb.dpt_no) where bbb.dpt_no is not null;

23. p4计算机安装方法 
将symcjit.dll改为sysmcjit.old

24. 何查询server是不是ops? 
select * from v$option; 
假如parallel server=true则有ops能

25. 何查询每个用户的权限? 
select * from dba_sys_privs;

26. 如何将表移动表空间? 
alter table table_name move tablespace_name;

27. 如何将索引移动表空间? 
alter index index_name rebuild tablespace tablespace_name;

28. 在linux,unix下如何启动dba studio? 
oemapp dbastudio

29. 查询锁的状况的对象有? 
v$lock, v$locked_object, v$session, v$sqlarea, v$process ; 
查询锁的表的方法: 
select s.sid session_id, s.username, decode(lmode, 0, 'none', 1, 'null', 2, 'row-s (ss)', 3, 'row-x (sx)', 4, 'share', 5, 's/row-x (ssx)', 6, 'exclusive', to_char(lmode)) mode_held, decode(request, 0, 'none', 1, 'null', 2, 'row-s (ss)', 3, 'row-x (sx)', 4, 'share', 5, 's/row-x (ssx)', 6, 'exclusive', to_char(request)) mode_requested, o.ccbzzp||'.'||o.object_name||' ('||o.object_type||')', s.type lock_type, l.id1 lock_id1, l.id2 lock_id2 from v$lock l, sys.dba_objects o, v$session s where l.sid = s.sid and l.id1 = o.object_id ;

30. 如何解锁? 
alter system kill session ‘sid,serir#’;

31. sqlplus下如何修改编辑器? 
define _editor="" -- 必须加上双引号 
来定义新的编辑器，也可以把这个写在$oracle_home/sqlplus/admin/glogin.sql里面使它永久有效。

32. oracle产生随机函数是? 
dbms_random.random

33. linux下查询磁盘竞争状况命令? 
sar -d

33. linux下查询cpu竞争状况命令? 
sar -r

34. 查询当前用户对象? 
select * from user_objects; 
select * from dba_segments;

35. 如何获取错误信息? 
select * from user_errors;

36. 如何获取链接状况? 
select * from dba_db_links;

37. 查看数据库字符状况? 
select * from nls_database_parameters; 
select * from v$nls_parameters;

38. 查询表空间信息? 
select * from dba_data_files;

39. oracle的interal用户要口令? 
修改 sqlnet.ora 
sqlnet.authentication_services=(nts)

40. 出现java.exe的解决办法? 
一般是将oracleorahomexihttpserver改成手工启动可以的 
x是8或9

41. 如何给表、列加注释？ 
sql>comment on table 表 is '表注释'; 
注释已创建。 
sql>comment on column 表.列 is '列注释'; 
注释已创建。 
sql> select * from user_tab_comments where comments is not null;

42. 如何查看各个表空间占用磁盘情况？ 
sql> col tablespace format a20 
sql> select 
b.file_id 文件id号, 
b.tablespace_name 表空间名, 
b.bytes 字节数, 
(b.bytes-sum(nvl(a.bytes,0))) 已使用, 
sum(nvl(a.bytes,0)) 剩余空间, 
sum(nvl(a.bytes,0))/(b.bytes)*100 剩余百分比 
from dba_free_space a,dba_data_files b 
where a.file_id=b.file_id 
group by b.tablespace_name,b.file_id,b.bytes 
order by b.file_id 
43. 如把oracle设置为mts或专用模式？ 
#dispatchers="(protocol=tcp) (service=sidxdb)" 
加上就是mts，注释就是专用模式，sid是指你的实例名。

44. 如何才能得知系统当前的scn号 ? 
select max(ktuxescnw * power(2, 32) + ktuxescnb) from x$ktuxe;

45. 请问如何在oracle中取毫秒? 
 9i之前不支持,9i开始有timestamp. 
 9i可以用select systimestamp from dual;

46. 如何在字符串里加回车？ 
select 'welcome to visit'||chr(10)||'www.csdn.net' from dual ;

47. 中文是如何排序的？ 
oracle9i之前，中文是按照二进制编码进行排序的。 
在oracle9i中新增了按照拼音、部首、笔画排序功能。设置nls_sort值 
schinese_radical_m 按照部首（第一顺序）、笔划（第二顺序）排序 
schinese_stroke_m 按照笔划（第一顺序）、部首（第二顺序）排序 
schinese_pinyin_m 按照拼音排序

48. oracle8i中对象名可以用中文吗？ 
可以

49. 如何改变win中sql*plus启动选项？ 
sql*plus自身的选项设置我们可以在$oracle_home/sqlplus/admin/glogin.sql中设置。

50. 怎样修改oracel数据库的默认日期? 
alter session set nls_date_format='yyyymmddhh24miss'; 
or 
可以在init.ora中加上一行 
nls_date_format='yyyymmddhh24miss'

51. 如何将小表放入keep池中? 
alter table xxx storage(buffer_pool keep);

52. 如何检查是否安装了某个patch? 
check that orainventory

53. 如何使select语句使查询结果自动生成序号? 
select rownum,col from table;

54. 如何知道数据裤中某个表所在的tablespace? 
select tablespace_name from user_tables where table_name='test'; 
select * from user_tables中有个字段tablespace_name，（oracle）; 
select * from dba_segments where …;

55. 怎么可以快速做一个和原表一样的备份表? 
create table new_table as (select * from old_table);

55. 怎么在sqlplus下修改procedure? 
select line,trim(text) t from user_source where name =’a’ order by line;

56. 怎样解除procedure被意外锁定? 
alter system kill session ,把那个session给杀掉，不过你要先查出她的session id 
or 
把该过程重新改个名字就可以了。

57. sql reference是个什么东西？ 
是一本sql的使用手册，包括语法、函数等等，oracle官方网站的文档中心有下载.

58. 如何查看数据库的状态? 
unix下 
ps -ef |grep ora 
windows下 
看服务是否起来 
是否可以连上数据库

59. 请问如何修改一张表的主键? 
alter table aaa 
drop constraint aaa_key ; 
alter table aaa 
add constraint aaa_key primary key(a1,b1) ;

60. 改变数据文件的大小? 
用 alter database .... datafile .... ; 
手工改变数据文件的大小，对于原来的 数据文件有没有损害。

61. 怎样查看oracle中有哪些程序在运行之中？ 
查看v$sessions表

62. 怎么可以看到数据库有多少个tablespace? 
select * from dba_tablespaces;

63. 如何修改oracle数据库的用户连接数？ 
修改initsid.ora，将process加大，重启数据库.

64. 如何查出一条记录的最后更新时间? 
可以用logminer 察看

65. 如何在pl/sql中读写文件？ 
utl_file包答应用户通过pl/sql读写操作系统文件。

66. 怎样把“&”放入一条记录中？ 
insert into a values (translate ('at{&}t','at{}','at'));

67. exp　如何加ｑｕｅｒｙ参数？ 
exp user/pass file=a.dmp tables(bsempms) 
query='"where emp_no="'s09394"'"" ﹔

68. 关于oracle8i支持简体和繁体的字符集问题？ 
zhs16gbk可以支

69. data guard是什么软件？ 
就是standby的换代产品

70. 如何创建spfile? 
sql> connect / as sysdba 
sql> select * from v$version; 
sql> create pfile from spfile; 
sql> create spfile from pfile='e:"ora9i"admin"eygle"pfile"init.ora'; 
文件已创建。 
sql> create spfile='e:"ora9i"database"spfileeygle.ora' from pfile='e:"ora9i"admin"eygle"pfile"init.ora'; 
文件已创建。

71. 内核参数的应用? 
shmmax 
　　含义：这个设置并不决定究竟oracle数据库或者操作系统使用多少物理内存，只决定了最多可以使用的内存数目。这个设置也不影响操作系统的内核资源。 
　　设置方法：0.5*物理内存 
　　例子：set shmsys:shminfo_shmmax=10485760 
　　shmmin 
　　含义：共享内存的最小大小。 
　　设置方法：一般都设置成为1。 
　　例子：set shmsys:shminfo_shmmin=1： 
　　shmmni 
　　含义：系统中共享内存段的最大个数。 
　　例子：set shmsys:shminfo_shmmni=100 
　　shmseg 
　　含义：每个用户进程可以使用的最多的共享内存段的数目。 
　　例子：set shmsys:shminfo_shmseg=20： 
　　semmni 
　　含义：系统中semaphore identifierer的最大个数。 
　　设置方法：把这个变量的值设置为这个系统上的所有oracle的实例的init.ora中的最大的那个processes的那个值加10。 
　　例子：set semsys:seminfo_semmni=100 
　　semmns 
　　含义：系统中emaphores的最大个数。 
　　设置方法：这个值可以通过以下方式计算得到：各个oracle实例的initsid.ora里边的processes的值的总和（除去最大的processes参数）＋最大的那个processes×2＋10×oracle实例的个数。 
　　例子：set semsys:seminfo_semmns=200 
　　semmsl: 
　　含义：一个set中semaphore的最大个数。 
　　设置方法：设置成为10＋所有oracle实例的initsid.ora中最大的processes的值。 
　　例子：set semsys:seminfo_semmsl=-200 
72. 怎样查看哪些用户拥有sysdba、sysoper权限？ 
sql>conn sys/change_on_install 
sql>select * from v_$pwfile_users;

73. 如何单独备份一个或多个表？ 
exp 用户/密码 tables=(表1,…,表2)

74. 如何单独备份一个或多个用户？ 
exp system/manager owner=(用户1,用户2,…,用户n) file=导出文件

75. 如何对clob字段进行全文检索？ 
select * from a where dbms_lob.instr(a.a,'k',1,1)>0;

76. 如何显示当前连接用户? 
show user

77. 如何查看数据文件放置的路径 ? 
col file_name format a50 
sql> select tablespace_name,file_id,bytes/1024/1024,file_name from dba_data_files order by file_id;

78. 如何查看现有回滚段及其状态 ? 
sql> col segment format a30 
sql> select segment_name,ccbzzp,tablespace_name,segment_id,file_id,status from dba_rollback_segs

79. 如何改变一个字段初始定义的check范围？ 
sql> alter table xxx drop constraint constraint_name; 
之后再创建新约束: 
sql> alter table xxx add constraint constraint_name check();

80. oracle常用系统文件有哪些？ 
通过以下视图显示这些文件信息：v$database,v$datafile,v$logfile v$controlfile v$parameter;

81. 内连接inner join? 
select a.* from bsempms a,bsdptms b where a.dpt_no=b.dpt_no;

82. 如何外连接? 
select a.* from bsempms a,bsdptms b where a.dpt_no=b.dpt_no(+); 
select a.* from bsempms a,bsdptms b wherea.dpt_no(+)=b.dpt_no;

83. 如何执行脚本sql文件? 
sql>@$path/filename.sql;

84. 如何快速清空一个大表? 
sql>truncate table table_name;

85. 如何查有多少个数据库实例? 
sql>select * from v$instance;

86. 如何查询数据库有多少表? 
sql>select * from all_tables;

87. 如何测试sql语句执行所用的时间? 
sql>set timing on ; 
sql>select * from tablename; 
88. chr()的反函数是? 
ascii() 
select char(65) from dual; 
select ascii('a') from dual;

89. 字符串的连接 
select concat(col1,col2) from table ; 
select col1||col2 from table ;

90. 怎么把select出来的结果导到一个文本文件中？ 
sql>spool c:"abcd.txt; 
sql>select * from table; 
sql >spool off;

91. 怎样估算sql执行的i/o数 ? 
sql>set autotrace on ; 
sql>select * from table; 
or 
sql>select * from v$filestat ; 
可以查看io数

92. 如何在sqlplus下改变字段大小? 
alter table table_name modify (field_name varchar2(100)); 
改大行，改小不行（除非都是空的）

93. 如何查询某天的数据? 
select * from table_name where trunc(日期字段)＝to_date('2003-05-02','yyyy-mm-dd');

94. sql 语句如何插入全年日期？ 
create table bsyear (d date); 
insert into bsyear 
select to_date('20030101','yyyymmdd')+rownum-1 
from all_objects 
where rownum

95. 假如修改表名? 
alter table old_table_name rename to new_table_name;

96. 如何取得命令的返回状态值？ 
sqlcode=0

97. 如何知道用户拥有的权限? 
select * from dba_sys_privs ;

98. 从网上下载的oracle9i与市场上卖的标准版有什么区别？ 
从功能上说没有区别，只不过oracle公司有明文规定；从网站上下载的oracle产品不得用于 商业用途，否则侵权。

99. 怎样判定数据库是运行在归档模式下还是运行在非归档模式下？ 
进入dbastudio，历程--〉数据库---〉归档查看。

100. sql>startup pfile和ifile,spfiled有什么区别？ 
pfile就是oracle传统的初始化参数文件，文本格式的。 
ifile类似于c语言里的include，用于把另一个文件引入 
spfile是9i里新增的并且是默认的参数文件，二进制格式 
startup后应该只可接pfile

101. 如何搜索出前n条记录？ 
select * from employee where rownum

102. 如何知道机器上的oracle支持多少并发用户数? 
sql>conn internal ; 
sql>show parameter processes ;

103. db_block_size可以修改吗? 
一般不可以﹐不建议这样做的。

104. 如何统计两个表的记录总数? 
select (select count(id) from aa)+(select count(id) from bb) 总数 from dual;

105. 怎样用sql语句实现查找一列中第n大值？ 
select * from 
(select t.*,dense_rank() over (order by sal) rank from employee) 
where rank = n;


106. 如何在给现有的日期加上2年？( 
select add_months(sysdate,24) from dual;

107. used_ublk为负值表示什么意思? 
it is "harmless".

108. connect string是指什么? 
应该是tnsnames.ora中的服务名后面的内容

109. 怎样扩大redo log的大小？ 
建立一个临时的redolog组，然后切换日志，删除以前的日志，建立新的日志。

110. tablespace 是否不能大于4g? 
没有限制.

111. 返回大于等于n的最小整数值? 
select ceil(n) from dual;

112. 返回小于等于n的最小整数值? 
select floor(n) from dual;

113. 返回当前月的最后一天? 
select last_day(sys2003-10-17) from dual;

114. 如何不同用户间数据导入? 
imp system/manager file=aa.dmp fromuser=user_old touser=user_new rows=y indexes=y ;

115. 如何找数据库表的主键字段的名称? 
sql>select * from user_constraints where constraint_type='p' and table_name='table_name';

116. 两个结果集互加的函数? 
sql>select * from bsempms_old intersect select * from bsempms_new; 
sql>select * from bsempms_old union select * from bsempms_new; 
sql>select * from bsempms_old union all select * from bsempms_new;

117. 两个结果集互减的函数? 
sql>select * from bsempms_old minus select * from bsempms_new;

118. 如何配置sequence? 
建sequence seq_custid 
create sequence seq_custid start 1 incrememt by 1; 
建表时: 
create table cust 
{ cust_id smallint not null, 
...} 
insert 时: 
insert into table cust 
values( seq_cust.nextval, ...)

Oracle :end------------------------------------------------------------------