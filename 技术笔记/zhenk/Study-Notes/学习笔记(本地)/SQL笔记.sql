D:\phpStudy\MySQL\bin>mysqld --install mysql_cy --defaults-file=D:\phpStudy\MySQL\my.ini
mysqld --remove mysql_cy
����mysql_cyΪҪ�����ķ�����



�ܺͲ�ѯ��䣺select ѧ�ţ�sum(����) from ���� group by ѧ�� order by ѧ��;
ͨ����ǰ����now()������ѯ���䣺
              select year(now())-year(��������)+1 as ���� from ����;

insert into ����(�ֶ���,�ֶ���, �� ) values( �ֶ�ֵ,�ֶ�ֵ,��);


EXCEL��ͨ�����֤����B2�У�����
           ��C2�У��������ڹ�ʽ��=DATE(MID(B2,7,4),MID(B2,11,2),MID(B2,13,2))
                   ��ȡ�Ա�=TEXT(-1^MID(B2,15,3),"Ů;��")
                   ��ȡ���䣺=DATEDIF(C2,TODAY(),"y")

select @@tx_isolation;
start transaction;
update tx set num=10 where id=1;


��where ���������ĸ����ֶμ�(+)�ͱ�ʾ�������ֶ���ȵļ�¼


from ��1 left join ��2 on ���� �������ӣ������ذ�������е����м�¼���ұ��������ֶ���ȵļ�¼��


right join �������ӣ������ذ����ұ��е����м�¼������������ֶ���ȵļ�¼��


inner join ����ֵ���ӣ���ֻ�����������������ֶ���ȵ��С�


full join ��ȫ�����ӣ����������ұ������еļ�¼�����ұ��������ֶ���ȵļ�¼��

natural join����Ȼ���ӣ�������������һ������������ͬ�ֶ������У���Ȼ�����У����Ҳ���Ϊ����ָ�����ƴʡ����� p.category����p�������ƴʣ��ı�����Զ����ӣ����Ӻ�ֻ����һ���У�   ��select p.product_id,category_id,category_name from product_information p natural join categories ca;����ȷsql��䣩��


�ѿ����������û��ͬ���У���Ȼ�����У���Ϊ���������Ļ���ȴ��Ҫʹ���������������ϵĻ�����select * from countries natural join categories��


�����ӣ�inner join���������ӣ�outer join�������������ӣ�inner����ʡ�ԣ�ֻ����ʾƥ��ļ�¼���������ݿ��ܲ�����������������δƥ��ɹ��Ĳ������ݣ���Ҳ��ʾ������

�����ӣ���������������ߵı������ƣ������е��ж������ڽ�����У���
�����ӣ��������������ұߵı������ƣ�
ȫ���ӣ����������������ƣ��������е��ж�������ڽ�����С�
�������ӣ���û��where�Ӿ�Ľ�������ʱ�漰�ĵѿ�������

union��ѯ��ȡ���������߶��select ����ѯ������Ĳ��������Զ�ȥ��������е��ظ��У������union �������all�Ͳ���ȡ���ظ��У�
union all��ѯ��ȡ�ý�����Ĳ�����������ȡ���ظ��У���������
intersect��ѯ����ѯ������Ľ���������ѯ��ν���ظ��У���
minus��ѯ���



�ۺϺ�����1����ֵ������avg();2����ͺ�����sum();3������������count();


���ɱȽ�����������Ӳ�ѯ��ʱ���Ӳ�ѯ���صı����ǵ�ֵ������ in��all��exists��any�������Ӳ�ѯʱ���Ӳ�ѯ���صĶ���ֵ���е�ʱ��Ҳ�����ڱȽ�������������in��all��exists��any�ȵ�ʱ���Ӳ�ѯҲ�Ƿ��ض���ֵ��
exists��ʾ���ڵ���˼��


������create [unique|bitmap] index index_name
      on table_name(col[asc|desc);
     ��ע��col��ʾ����
     ����������û�б�Ĭ�ϳ�ʹ�ã���ѯ��ʱ��Ҫǿ��ʹ������
     ��select /*+ index ( table_name[index_name])*/ ���� from table_name;
�鿴������select * from user_indexes where table_name='table_name';
        user_indexes��ͼ��all_indexes����һ��table_name���䡣�ڶ���table_name�Ǵ���������ʵ�ڱ����������ӡ�����select *from user_indexes  where table_name='tpshop';
       ��������������alter index �ɵ������� rename to �µ�������;
       �ؽ����� �� alter index �ؽ��������� rebuild;
       ɾ������ �� drop  index ������;


��ͼ: һ�ֲ�ѯ���ƣ�һ�ſ��ӻ�������������߱����ĳЩ���ܣ�û�����ݣ�����

FK_COURSE_ID

FK_STUDENT_ID

PK_RESULT_ID


MySQL
  ��1����ʾ�������ݿ�
    show database��
  ��2����ʾ���б�
    show tables��
  ��3����ʾ��ṹ
     desc ������
�鿴��ṹ��desc ������oracle��;


�洢���̣�create or replace procedure �洢�������� as 
          begin 
          �洢���̶��� 



          end �洢��������;


����������һ���������йص����ݿ���󣬵����������ڱ��ϳ���ָ���¼�ʱ�������øö��󣬼���Ĳ����¼��������ϵĴ�����ִ�С�


��ҳ��ѯ��rownum��oracle��,linit��mysql��


1��������Oracle������ʵ��������mysql����ʵ�������� 

       oracle�½����У�SEQ_USER_Id.nextval 

2�������� 

       mysql������0��ʼ��Oracle��1��ʼ�� 

3����ҳ�� 

      mysql: select * from user order by desc limit n ,m. 

             ��ʾ���ӵ�n�����ݿ�ʼ���ң�һ������m�����ݡ� 

      Oracle��select * from user 
              select rownum a * from ((select * from user)a) 
              select * from (select rownum a.* from (select * from user) a ) 
              where r between n , m . 

��ʾ��n��ʾ�ӵ�n�����ݲ�ѯ�����ҵ�m�����ݡ�

  �ݹ��ѯ��
     SELECT * from
     CONNECT BY {PRIOR����1=����2|����1=PRIOR����2}
     [START WITH]��
     start with initial-condition connect by nocycle recurse-condition ��Ҫ��Ŀ�ģ��ӱ���ȡ����״���ݣ��ݹ��ѯ;prior�ŵ�����λ�þ����˼������Ե����ϻ����Զ�����,���У�CONNECT BY�Ӿ�˵��ÿ�����ݽ��ǰ����˳����������涨�����е������������ͽṹ�Ĺ�ϵ�С�PRIORY�����������������ӹ�ϵ��������ĳһ����ǰ�档���ڽڵ��ĸ��ӹ�ϵ��PRIOR�������һ���ʾ���ڵ㣬����һ���ʾ�ӽڵ㣬�Ӷ�ȷ���������ṹ�ǵ�˳�����Զ����»����Ե����ϡ������ӹ�ϵ�У����˿���ʹ�������⣬������ʹ���б��ʽ��START WITH�Ӿ�Ϊ��ѡ�������ʶ�ĸ��ڵ���Ϊ�������ͽṹ�ĸ��ڵ㡣�����Ӿ䱻ʡ�ԣ����ʾ���������ѯ����������Ϊ���ڵ㡣




col deptno heading "���"���� ��deptno���column"���"

alter table abc add/drop c number;�����ݱ�abc�����/ɾ��c�ֶ�

grant select  on (ִ���������������û����еı�)��A to ��һ���û���  ������һ���û�����Ȩ��A��������ͨ�����û���.��A�����û���������һ���û����еı�


DECODE(L.ORG_STRUT_FAR_ID, '-1','���ܼ���',
              (SELECT ORG_STRUT_L_NAME FROM XSR_XZ_PM_ORG_STRUT_L WHERE ORG_STRUT_L_ID = L.ORG_STRUT_FAR_ID)) ORG_STRUT_FAR_NAME



Dblink---���Կ籾�����ݿ��������һ�����ݿ���е�����
��䣺CREATE [SHARED] [PUBLIC] database link link_name
����[CONNECT TO [user] [current_user] IDENTIFIED BY password]��
����[AUTHENTICATED BY user IDENTIFIED BY password]��
����[USING 'connect_string']

Mysql ��start----------------------------------------------------------------
show databases;
use ���ݿ���;
show tables;
show variables like 'char%';  /*��ʾ�����ʽ*/
show create table _category;  /*��ѯ���ݿ�ͱ�ı���*/
show full columns from ����;

ALTER DATABASE `���ݿ�` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci 

����ALTER TABLE `���ݱ�` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci   ��ע���˾�ѱ�Ĭ�ϵ��ַ����������ַ��У�CHAR,VARCHAR,TEXT����Ϊ�µ��ַ�������


  alter table tb_anniversary convert to character set utf8; /*mysql������ַ�����ת����utf-8*/

 select @@tx_isolation;/*�鿴���ݿ������*/



mysql -h172.17.159.163 -uroot -pbaodongmei520131

explain SQL���;/*Explain������������ǲ鿴MYSQLִ��һ��SQL��ѡ���ִ�м�*/

 -----------------�������� start

�Ƚ�һ�����б����£� 
      /*����--Sequence �����*/
        CREATE TABLE IF NOT EXISTS `sequence` (`name` varchar(50) NOT NULL,`current_value` int(11) NOT NULL,`increment` int(11) NOT NULL DEFAULT '1') ENGINE=MyISAM DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='���б�����s_[table_name]'; 
  
     INSERT INTO `sequence` (`name`, `current_value`, `increment`) VALUES('s_blog_account', 0, 1) 

/*����--ȡ��ǰֵ�ĺ���*/
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


/*����--ȡ��һ��ֵ�ĺ���*/
   DROP FUNCTION IF EXISTS `nextval`;  
DELIMITER //  
CREATE  FUNCTION `nextval`(seq_name VARCHAR(50)) RETURNS int(11)  
    DETERMINISTIC  
BEGIN  
UPDATE sequence SET current_value = current_value + increment WHERE NAME = seq_name;  
RETURN currval(seq_name);  
END//  
DELIMITER ;
 

���ʹ��select nextval("s_blog_account")���ɵõ���һ��ֵ

 -----------------�������� end

Mysql :end-------------------------------------------------------------------

Oracle :start ---------------------------------------------------------------
   %ROWTYPE��(���ĳһ�м�¼����)��ʾ������Ϊ���������ͣ��洢��ʱ��Ϊһ�����ݣ�һ���кܶ��У��൱�ڱ��е�һ�����ݣ�Ҳ���Ե��α��е�һ�����ݡ�
 
  B  A.a%TYPE; --B��������һ���Ѿ������A.a(���ĳһ��)������ͬ

1)����:
DECLARE   
  V_ORG_NAME SF_ORG.ORG_NAME%TYPE; --��ORG_NAME������ͬ  
  V_PARENT_ID SF_ORG.PARENT_ID%TYPE;--��PARENT_ID������ͬ  
BEGIN  
  SELECT ORG_NAME,PARENT_ID INTO V_ORG_NAME,V_PARENT_ID  
  FROM SF_ORG SO  
  WHERE SO.ORG_ID=&ORG_ID;  
  DBMS_OUTPUT.PUT_LINE('�������ƣ�' || V_ORG_NAME);  
  DBMS_OUTPUT.PUT_LINE('�ϼ����ű��룺' || TO_CHAR(V_PARENT_ID));  
END;  

select name from v$datafile;
select * from v$logfile;
select name from v$controlfile;


update test set address=REPLACE(select address from test, '10.101.3.190', '111.59.38.12:8088') 

 systemĬ��:manager sysĬ��:change_on_install


E_Rows ���Ż����������ص�����
A_Rows ���м�ִ���Ƿ��ص�����


Oracle���һ����Oracle��¼����
1������SQLPLUS����

����C:\Users\wd-pc>sqlplus

2��ֱ�ӽ���SQLPLUS������ʾ��

����C:\Users\wd-pc>sqlplus /nolog

3����OS������� 

����C:\Users\wd-pc>sqlplus / as sysdba   ��

����SQL>connect / as sysdba

4����ͨ�û���¼

����C:\Users\wd-pc>sqlplus scott/123456 ����

����SQL>connect scott/123456  ��

����SQL>connect scott/123456@servername

5���Թ���Ա��¼

����C:\Users\wd-pc>sqlplus sys/123456 as sysdba����

����SQL>connect sys/123456 as sysdba

6���л��û�

����SQL>conn hr/123456 

����ע��connͬconnect

 7���˳�

����exit



Oracle���ݿⳣ��sql���

ORACLE ���õ�SQL�﷨�����ݶ���
һ.���ݿ������ (DML) ����

1.INSERT (�����ݱ�������¼�����)

INSERT INTO ����(�ֶ���1, �ֶ���2, ����) VALUES ( ֵ1, ֵ2, ����);
INSERT INTO ����(�ֶ���1, �ֶ���2, ����) SELECT (�ֶ���1, �ֶ���2, ����) FROM ����ı���;

�ַ������͵��ֶ�ֵ�����õ�����������, ����: ��GOOD DAY��
����ֶ�ֵ����������š� ��Ҫ�����ַ���ת��, ���ǰ����滻������������''.
�ַ������͵��ֶ�ֵ��������ĳ��Ȼ����, ����ڲ���ǰ���г���У��.

�����ֶε��ֶ�ֵ�����õ�ǰ���ݿ��ϵͳʱ��SYSDATE, ��ȷ����
�������ַ���ת���������ͺ���TO_DATE(��2001-08-01��,��YYYY-MM-DD��)
TO_DATE()���кܶ������ڸ�ʽ, ���Բο�ORACLE DOC.
��-��-�� Сʱ:����:�� �ĸ�ʽYYYY-MM-DD HH24:MI:SS

INSERTʱ���ɲ������ַ�������С�ڵ���4000�����ֽ�, ���Ҫ����������ַ���, �뿼���ֶ���CLOB����,
��������ORACLE���Դ���DBMS_LOB�����.

INSERTʱ���Ҫ�õ���1��ʼ�Զ����������к�, Ӧ���Ƚ���һ�����к�
CREATE SEQUENCE ���кŵ����� (����Ǳ���+���кű��) INCREMENT BY 1 START WITH 1
MAXVALUE 99999 CYCLE NOCACHE;
��������ֵ���ֶεĳ�������, ���������Զ����������к� NUMBER(6) , ���ֵΪ999999
INSERT ����������ֶ�ֵΪ: ���кŵ�����.NEXTVAL

2.DELETE (ɾ�����ݱ����¼�����)

DELETE FROM���� WHERE ����;

ע�⣺ɾ����¼�������ͷ�ORACLE�ﱻռ�õ����ݿ��ռ�. ��ֻ����Щ��ɾ�������ݿ���unused.

���ȷʵҪɾ��һ��������ȫ����¼, ������ TRUNCATE ����, �������ͷ�ռ�õ����ݿ��ռ�
TRUNCATE TABLE ����;
�˲������ɻ���.

3.UPDATE (�޸����ݱ����¼�����)

UPDATE���� SET �ֶ���1=ֵ1, �ֶ���2=ֵ2, ���� WHERE ����;

����޸ĵ�ֵNû�и�ֵ����ʱ, ����ԭ���ļ�¼������ΪNULL, ������޸�ǰ���зǿ�У��;
ֵN��������ĳ��Ȼ����, ����ڲ���ǰ���г���У��..

ע������:
A. ����SQL���Ա��������м���,
ȷ����ɺ�, ����������ﴦ����������� COMMIT ������ʽ��Ч,
����ı䲻һ��д�����ݿ���.
����볷����Щ����, ���������� ROLLBACK ��ԭ.

B. ������INSERT, DELETE �� UPDATE ���ǰ��ù���һ�¿��ܲ����ļ�¼��Χ,
Ӧ�ð����޶��ڽ�С (һ������¼) ��Χ��,. ����ORACLE������������õ��ܴ�Ļ��˶�.
������Ӧ������ʧȥ��Ӧ. �����¼����ʮ��������Щ����, ���԰���ЩSQL���ֶηִ����,
������COMMIT ȷ�����ﴦ��.
��.���ݶ��� (DDL) ����
1.CREATE (������, ����, ��ͼ, ͬ���, ����, ����, ���ݿ����ӵ�)

ORACLE���õ��ֶ�������
CHAR �̶����ȵ��ַ���
VARCHAR2 �ɱ䳤�ȵ��ַ���
NUMBER(M,N) ������M��λ���ܳ���, N��С���ĳ���
DATE ��������

������ʱҪ�ѽ�С�Ĳ�Ϊ�յ��ֶη���ǰ��, ����Ϊ�յ��ֶη��ں���

������ʱ���������ĵ��ֶ���, ����û�����Ӣ�ĵ��ֶ���

������ʱ���Ը��ֶμ���Ĭ��ֵ, ���� DEFAULT SYSDATE
����ÿ�β�����޸�ʱ, ���ó����������ֶζ��ܵõ�������ʱ��

������ʱ���Ը��ֶμ���Լ������
���� �������ظ� UNIQUE, �ؼ��� PRIMARY KEY

2.ALTER (�ı��, ����, ��ͼ��)

�ı�������
ALTER TABLE ����1 TO ����2;

�ڱ�ĺ�������һ���ֶ�
ALTER TABLE���� ADD �ֶ��� �ֶ�������;

�޸ı����ֶεĶ�������
ALTER TABLE���� MODIFY�ֶ��� �ֶ�������;

��������ֶμ���Լ������
ALTER TABLE ���� ADD CONSTRAINT Լ���� PRIMARY KEY (�ֶ���);
ALTER TABLE ���� ADD CONSTRAINT Լ���� UNIQUE (�ֶ���);

�ѱ���ڻ�ȡ�����ݿ���ڴ���
ALTER TABLE ���� CACHE;
ALTER TABLE ���� NOCACHE;

3.DROP (ɾ����, ����, ��ͼ, ͬ���, ����, ����, ���ݿ����ӵ�)

ɾ����������е�Լ������
DROP TABLE ���� CASCADE CONSTRAINTS;

4.TRUNCATE (��ձ�������м�¼, ������Ľṹ)

TRUNCATE ����;

��.��ѯ��� (SELECT) ����
SELECT�ֶ���1, �ֶ���2, ���� FROM ����1, [����2, ����] WHERE ����;

�ֶ������Դ��뺯��
����: COUNT(*), MIN(�ֶ���), MAX(�ֶ���), AVG(�ֶ���), DISTINCT(�ֶ���),
TO_CHAR(DATE�ֶ���,'YYYY-MM-DD HH24:MI:SS')

NVL(EXPR1, EXPR2)����
����:
IF EXPR1=NULL
RETURN EXPR2
ELSE
RETURN EXPR1

DECODE(AA�oV1�oR1�oV2�oR2....)����
����:
IF AA=V1 THEN RETURN R1
IF AA=V2 THEN RETURN R2
..��
ELSE
RETURN NULL

LPAD(char1,n,char2)����
����:
�ַ�char1���ƶ���λ��n��ʾ�������λ����char2�ַ����滻��ߵĿ�λ

�ֶ���֮����Խ�����������
����: (�ֶ���1*�ֶ���1)/3

��ѯ������Ƕ��
����: SELECT ���� FROM
(SELECT ���� FROM����1, [����2, ����] WHERE ����) WHERE ����2;

������ѯ���Ľ�����������ϲ���
����: ����UNION(ȥ���ظ���¼), ����UNION ALL(��ȥ���ظ���¼), �MINUS, ����INTERSECT

�����ѯ
SELECT�ֶ���1, �ֶ���2, ���� FROM ����1, [����2, ����] GROUP BY�ֶ���1
[HAVING ����] ;

�������ϱ�֮������Ӳ�ѯ

SELECT�ֶ���1, �ֶ���2, ���� FROM ����1, [����2, ����] WHERE
����1.�ֶ��� = ����2. �ֶ��� [ AND ����] ;

SELECT�ֶ���1, �ֶ���2, ���� FROM ����1, [����2, ����] WHERE
����1.�ֶ��� = ����2. �ֶ���(+) [ AND ����] ;

��(+)�ŵ��ֶ�λ���Զ�����ֵ

��ѯ��������������, Ĭ�ϵ�����������ASC, ������DESC

SELECT�ֶ���1, �ֶ���2, ���� FROM ����1, [����2, ����]
ORDER BY�ֶ���1, �ֶ���2 DESC;

�ַ���ģ���Ƚϵķ���

INSTR(�ֶ���, ���ַ�����)>0
�ֶ��� LIKE ���ַ���%�� [��%�ַ���%��]

ÿ������һ���������ֶ�ROWID, ������ż�¼��Ψһ��.

��.ORACLE�ﳣ�õ����ݶ��� (SCHEMA)
1.���� (INDEX)

CREATE INDEX ������ON ���� ( �ֶ�1, [�ֶ�2, ����] );
ALTER INDEX ������ REBUILD;

һ�����������ò�Ҫ�������� (����Ĵ�����), ����õ��ֶ�����, ���SQL���ķ���ִ�����,
Ҳ���Խ������ֶε���������ͻ��ں���������

ORACLE8.1.7�ַ���������������󳤶�Ϊ1578 ���ֽ�
ORACLE8.0.6�ַ���������������󳤶�Ϊ758 ���ֽ�

2.��ͼ (VIEW)

CREATE VIEW ��ͼ��AS SELECT ��. FROM ��..;
ALTER VIEW��ͼ�� COMPILE;

��ͼ����һ��SQL��ѯ���, �����԰ѱ�֮�临�ӵĹ�ϵ��໯.

3.ͬ��� (SYNONMY)
CREATE SYNONYMͬ�����FOR ����;
CREATE SYNONYMͬ�����FOR ����@���ݿ�������;

4.���ݿ����� (DATABASE LINK)
CREATE DATABASE LINK���ݿ�������CONNECT TO �û��� IDENTIFIED BY ���� USING �����ݿ������ַ�����;

���ݿ������ַ���������NET8 EASY CONFIG����ֱ���޸�TNSNAMES.ORA�ﶨ��.

���ݿ����global_name=trueʱҪ�����ݿ��������Ƹ�Զ�����ݿ�����һ��

���ݿ�ȫ�����ƿ���������������
SELECT * FROM GLOBAL_NAME;

��ѯԶ�����ݿ���ı�
SELECT ���� FROM ����@���ݿ�������;

��.Ȩ�޹��� (DCL) ���
1.GRANT ����Ȩ��
���õ�ϵͳȨ�޼�������������:
CONNECT(����������), RESOURCE(���򿪷�), DBA(���ݿ����)
���õ����ݶ���Ȩ�����������:
ALL ON ���ݶ�����, SELECT ON ���ݶ�����, UPDATE ON ���ݶ�����,
DELETE ON ���ݶ�����, INSERT ON ���ݶ�����, ALTER ON ���ݶ�����

GRANT CONNECT, RESOURCE TO �û���;
GRANT SELECT ON ���� TO �û���;
GRANT SELECT, INSERT, DELETE ON���� TO �û���1, �û���2;

2.REVOKE ����Ȩ��

REVOKE CONNECT, RESOURCE FROM �û���;
REVOKE SELECT ON ���� FROM �û���;
REVOKE SELECT, INSERT, DELETE ON���� FROM �û���1, �û���2;

��ѯ���ݿ��е�63�Ŵ���
select orgaddr,destaddr from sm_histable0116 where error_code='63';

��ѯ���ݿ��п����û�����ύ������·����� select MSISDN,TCOS,OCOS from ms_usertable��

��ѯ���ݿ��и��ִ��������ܺͣ�
select error_code,count(*) from sm_histable0513 group by error_code order
by error_code;

��ѯ�������ݿ��л���ͳ�������ѯ��
select sum(Successcount) from tbl_MiddleMt0411 where ServiceType2=111
select sum(successcount),servicetype from tbl_middlemt0411 group by servicetype

oracle����SQL���


1������SQL*Plus system/manager
2����ʾ��ǰ�����û�SQL> show user
3���鿴ϵͳӵ����Щ�û�SQL> select * from all_users;
4���½��û�����ȨSQL> create user a identified by a;��Ĭ�Ͻ���SYSTEM��ռ��£�SQL> grant connect,resource to a;
5�����ӵ����û�SQL> conn a/a
6����ѯ��ǰ�û������ж���SQL> select * from tab;
7��������һ����SQL> create table a(a number);
8����ѯ��ṹSQL> desc a
9�������¼�¼SQL> insert into a values(1);
10����ѯ��¼SQL> select * from a;
11�����ļ�¼SQL> update a set a=2;
12��ɾ����¼SQL> delete from a;
13���ع�SQL> roll;SQL> rollback;
14���ύSQL> commit;
---------------------------------------------------------------
----------------------------------------------------------------
�û���Ȩ:GRANT ALTER ANY INDEX TO "user_id "GRANT "dba " TO "user_id ";ALTER USER "user_id " DEFAULT ROLE ALL�����û�:CREATE USER "user_id " PROFILE "DEFAULT " IDENTIFIED BY " DEFAULT TABLESPACE "USERS " TEMPORARY TABLESPACE "TEMP " ACCOUNT UNLOCK;GRANT "CONNECT " TO "user_id ";�û������趨:ALTER USER "CMSDB " IDENTIFIED BY "pass_word "��ռ䴴��:CREATE TABLESPACE "table_space " LOGGING DATAFILE 'C:\ORACLE\ORADATA\dbs\table_space.ora' SIZE 5M
------------------------------------------------------------------------
1���鿴��ǰ���ж���
SQL > select * from tab;
2����һ����a��ṹһ���Ŀձ�
SQL > create table b as select * from a where 1=2;
SQL > create table b(b1,b2,b3) as select a1,a2,a3 from a where 1=2;
3���쿴���ݿ�Ĵ�С���Ϳռ�ʹ�����
SQL > col tablespace format a20SQL > select b.file_id�����ļ�ID,����b.tablespace_name������ռ�,����b.file_name���������������ļ���,����b.bytes�����������������ֽ���,����(b.bytes-sum(nvl(a.bytes,0)))��������ʹ��,����sum(nvl(a.bytes,0))����������������ʣ��,����sum(nvl(a.bytes,0))/(b.bytes)*100��ʣ��ٷֱȡ���from dba_free_space a,dba_data_files b����where a.file_id=b.file_id����group by b.tablespace_name,b.file_name,b.file_id,b.bytes����order by b.tablespace_name����/����dba_free_space --��ռ�ʣ��ռ�״������dba_data_files --�����ļ��ռ�ռ����� 4���鿴���лع��μ���״̬
SQL > col segment format a30SQL > SELECT SEGMENT_NAME,OWNER,TABLESPACE_NAME,SEGMENT_ID,FILE_ID,STATUS FROM DBA_ROLLBACK_SEGS;
5���鿴�����ļ����õ�·��
SQL > col file_name format a50SQL > select tablespace_name,file_id,bytes/1024/1024,file_name from dba_data_files order by file_id;
6����ʾ��ǰ�����û�
SQL > show user
7����SQL*Plus��������
SQL > select 100*20 from dual;
8�������ַ���
SQL > select ��1 | |��2 from ��1;SQL > select concat(��1,��2) from ��1;
9����ѯ��ǰ����
SQL > select to_char(sysdate,'yyyy-mm-dd,hh24:mi:ss') from dual;
10���û��临������
SQL > copy from user1 to user2 create table2 using select * from table1;
11����ͼ�в���ʹ��order by��������group by�������ﵽ����Ŀ��
SQL > create view a as select b1,b2 from b group by b1,b2;
12��ͨ����Ȩ�ķ�ʽ�������û�
SQL > grant connect,resource to test identified by test;
SQL > conn test/test
13�������ǰ�û����б�����
select unique tname from col;
-----------------------------------------------------------------------
/* ��һ���������ֶ� */alter table alist_table add address varchar2(100);
/* �޸��ֶ� ���� �ֶ�Ϊ�� */alter table alist_table modify address varchar2(80);
/* �޸��ֶ����� */create table alist_table_copy as select ID,NAME,PHONE,EMAIL,QQ as QQ2, /*qq ��Ϊqq2*/ADDRESS from alist_table;
drop table alist_table;rename alist_table_copy to alist_table/* �޸ı��� */
��ֵ������ʱҪ����ֵ����Ϊ��create table dept (deptno number(2) not null, dname char(14), loc char(13));
�ڻ���������һ��alter table deptadd (headcnt number(3));
�޸�����������alter table deptmodify dname char(20);ע��ֻ�е�ĳ������ֵ��Ϊ��ʱ�����ܼ�С����ֵ��ȡ�ֻ�е�ĳ������ֵ��Ϊ��ʱ�����ܸı�����ֵ���͡�ֻ�е�ĳ������ֵ��Ϊ����ʱ�����ܶ������Ϊnot null������alter table dept modify (loc char(12));alter table dept modify loc char(12);alter table dept modify (dname char(13),loc char(12)); 
����δ������select process,osuser,username,machine,logon_time ,sql_textfrom v$session a,v$sqltext b where a.sql_address=b.address;
-----------------------------------------------------------------1.��USER_��ʼ�������ֵ���ͼ������ǰ�û���ӵ�е���Ϣ, ��ѯ��ǰ�û���ӵ�еı���Ϣ:select * from user_tables;2.��ALL_��ʼ�������ֵ���ͼ����ORACLE�û���ӵ�е���Ϣ,��ѯ�û�ӵ�л���Ȩ���ʵ����б���Ϣ:select * from all_tables;
3.��DBA_��ʼ����ͼһ��ֻ��ORACLE���ݿ����Ա���Է���:select * from dba_tables;
4.��ѯORACLE�û���conn sys/change_on_installselect * from dba_users;conn system/manager;select * from all_users;
5.�������ݿ��û���CREATE USER user_name IDENTIFIED BY password;GRANT CONNECT TO user_name;GRANT RESOURCE TO user_name;��Ȩ�ĸ�ʽ: grant (Ȩ��) on tablename to username;ɾ���û�(���):drop user(table) username(tablename) (cascade);6.�򽨺õ��û��������ݱ�IMP SYSTEM/MANAGER FROMUSER = FUSER_NAME TOUSER = USER_NAME FILE = C:\EXPDAT.DMP COMMIT = Y7.����create index [index_name] on [table_name]( "column_name ")intersect����
���ز�ѯ�������ͬ�Ĳ���
exp:��������������Щ��ͬ�Ĺ���
selectjob
fromaccount
intersect
selectjob
fromresearch
intersect
selectjob
fromsales;

minus����
�����ڵ�һ����ѯ�������ڶ�����ѯ�������ͬ���ǲ����м�¼��
����Щ�����ڲƻᲿ���У��������۲���û�У�
exp:selectjobfromaccount
minus
selectjobfromsales;
1. oracle��װ��ɺ�ĳ�ʼ����? 
��internal/oracle 
����sys/change_on_install 
����system/manager 
����scott/tiger 
����sysman/oem_temp

2. oracle9ias web cache�ĳ�ʼĬ���û������룿 
administrator/administrator

3. oracle 8.0.5��ô�������ݿ�? 
��orainst��������motif���棬������orainst /m

4. oracle 8.1.7��ô�������ݿ�? 
dbassist

5. oracle 9i ��ô�������ݿ�? 
dbca

6. oracle�е����豸ָ����ʲô? 
���豸�����ƹ��ļ�ϵͳֱ�ӷ��ʵĴ���ռ�

7. oracle������� 64-bit/32bit �汾������ 
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

8. svrmgrʲô��˼�� 
svrmgrl��server manager. 
9i��û�У��Ѿ���Ϊ��sqlplus�� 
sqlplus /nolog 
��Ϊ�鵵��־�͵�

9. ������ηֱ�ĳ���û��Ǵ���̨������½oracle��? 
select machine , terminal from v$session;

10. ��ʲô����ѯ�ֶ��أ� 
desc table_name ���Բ�ѯ��Ľṹ 
select field_name,... from ... ���Բ�ѯ�ֶε�ֵ 
select * from all_tables where table_name like '%' 
select * from all_tab_columns where table_name='??'

11. �����õ������������̡������Ĵ����ű��� 
desc user_source 
user_triggers

12. ��������һ����ռ�õĿռ�Ĵ�С�� 
select owner,table_name, 
num_rows, 
blocks*aaa/1024/1024 "size m", 
empty_blocks, 
last_analyzed 
from dba_tables 
where table_name='xxx'; 
here: aaa is the value of db_block_size ; 
xxx is the table name you want to check

13. ��β鿴���Ự���� 
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
����Ϊ200���û��� 
select * from v$license; 
����sessions_highwater��¼������������Ự��

14. ��β鿴ϵͳ����������ʱ�䣿 
select * from v$locked_object ;

15. �����archivelog�ķ�ʽ����oracle�� 
init.ora 
log_archive_start = true 
restart database

16. ��ô��ȡ����Щ�û���ʹ�����ݿ� 
select username from v$session;

17. ���ݱ��е��ֶ�������Ƕ���? 
�����ͼ�е��������Ϊ 1000

18. ����������ݿ��sid ? 
select name from v$database; 
Ҳ����ֱ�Ӳ鿴 init.ora�ļ�

19. �����oracle��������ͨ��sqlplus�鿴����ip��ַ ? 
select sys_context('userenv','ip_address') from dual; 
�����ǵ�½�������ݿ⣬ֻ�ܷ���127.0.0.1���Ǻ�

20. unix ����ô�������ݿ��ʱ�䣿 
su -root 
date -u 08010000

21. ��oracle table�����ץȡmemo�����ֶ�Ϊ�յ����ݼ�¼? 
select remark from oms_flowrec where trim(' ' from remark) is not null ;


22. �����bbb�������ȥ����aaa�������(�й������ֶ�) 
up2003-10-17 aaa set bns_snm=(select bns_snm from bbb where aaa.dpt_no=bbb.dpt_no) where bbb.dpt_no is not null;

23. p4�������װ���� 
��symcjit.dll��Ϊsysmcjit.old

24. �β�ѯserver�ǲ���ops? 
select * from v$option; 
����parallel server=true����ops��

25. �β�ѯÿ���û���Ȩ��? 
select * from dba_sys_privs;

26. ��ν����ƶ���ռ�? 
alter table table_name move tablespace_name;

27. ��ν������ƶ���ռ�? 
alter index index_name rebuild tablespace tablespace_name;

28. ��linux,unix���������dba studio? 
oemapp dbastudio

29. ��ѯ����״���Ķ�����? 
v$lock, v$locked_object, v$session, v$sqlarea, v$process ; 
��ѯ���ı�ķ���: 
select s.sid session_id, s.username, decode(lmode, 0, 'none', 1, 'null', 2, 'row-s (ss)', 3, 'row-x (sx)', 4, 'share', 5, 's/row-x (ssx)', 6, 'exclusive', to_char(lmode)) mode_held, decode(request, 0, 'none', 1, 'null', 2, 'row-s (ss)', 3, 'row-x (sx)', 4, 'share', 5, 's/row-x (ssx)', 6, 'exclusive', to_char(request)) mode_requested, o.ccbzzp||'.'||o.object_name||' ('||o.object_type||')', s.type lock_type, l.id1 lock_id1, l.id2 lock_id2 from v$lock l, sys.dba_objects o, v$session s where l.sid = s.sid and l.id1 = o.object_id ;

30. ��ν���? 
alter system kill session ��sid,serir#��;

31. sqlplus������޸ı༭��? 
define _editor="" -- �������˫���� 
�������µı༭����Ҳ���԰����д��$oracle_home/sqlplus/admin/glogin.sql����ʹ��������Ч��

32. oracle�������������? 
dbms_random.random

33. linux�²�ѯ���̾���״������? 
sar -d

33. linux�²�ѯcpu����״������? 
sar -r

34. ��ѯ��ǰ�û�����? 
select * from user_objects; 
select * from dba_segments;

35. ��λ�ȡ������Ϣ? 
select * from user_errors;

36. ��λ�ȡ����״��? 
select * from dba_db_links;

37. �鿴���ݿ��ַ�״��? 
select * from nls_database_parameters; 
select * from v$nls_parameters;

38. ��ѯ��ռ���Ϣ? 
select * from dba_data_files;

39. oracle��interal�û�Ҫ����? 
�޸� sqlnet.ora 
sqlnet.authentication_services=(nts)

40. ����java.exe�Ľ���취? 
һ���ǽ�oracleorahomexihttpserver�ĳ��ֹ��������Ե� 
x��8��9

41. ��θ����м�ע�ͣ� 
sql>comment on table �� is '��ע��'; 
ע���Ѵ����� 
sql>comment on column ��.�� is '��ע��'; 
ע���Ѵ����� 
sql> select * from user_tab_comments where comments is not null;

42. ��β鿴������ռ�ռ�ô�������� 
sql> col tablespace format a20 
sql> select 
b.file_id �ļ�id��, 
b.tablespace_name ��ռ���, 
b.bytes �ֽ���, 
(b.bytes-sum(nvl(a.bytes,0))) ��ʹ��, 
sum(nvl(a.bytes,0)) ʣ��ռ�, 
sum(nvl(a.bytes,0))/(b.bytes)*100 ʣ��ٷֱ� 
from dba_free_space a,dba_data_files b 
where a.file_id=b.file_id 
group by b.tablespace_name,b.file_id,b.bytes 
order by b.file_id 
43. ���oracle����Ϊmts��ר��ģʽ�� 
#dispatchers="(protocol=tcp) (service=sidxdb)" 
���Ͼ���mts��ע�;���ר��ģʽ��sid��ָ���ʵ������

44. ��β��ܵ�֪ϵͳ��ǰ��scn�� ? 
select max(ktuxescnw * power(2, 32) + ktuxescnb) from x$ktuxe;

45. ���������oracle��ȡ����? 
 9i֮ǰ��֧��,9i��ʼ��timestamp. 
 9i������select systimestamp from dual;

46. ������ַ�����ӻس��� 
select 'welcome to visit'||chr(10)||'www.csdn.net' from dual ;

47. �������������ģ� 
oracle9i֮ǰ�������ǰ��ն����Ʊ����������ġ� 
��oracle9i�������˰���ƴ�������ס��ʻ������ܡ�����nls_sortֵ 
schinese_radical_m ���ղ��ף���һ˳�򣩡��ʻ����ڶ�˳������ 
schinese_stroke_m ���ձʻ�����һ˳�򣩡����ף��ڶ�˳������ 
schinese_pinyin_m ����ƴ������

48. oracle8i�ж����������������� 
����

49. ��θı�win��sql*plus����ѡ� 
sql*plus�����ѡ���������ǿ�����$oracle_home/sqlplus/admin/glogin.sql�����á�

50. �����޸�oracel���ݿ��Ĭ������? 
alter session set nls_date_format='yyyymmddhh24miss'; 
or 
������init.ora�м���һ�� 
nls_date_format='yyyymmddhh24miss'

51. ��ν�С�����keep����? 
alter table xxx storage(buffer_pool keep);

52. ��μ���Ƿ�װ��ĳ��patch? 
check that orainventory

53. ���ʹselect���ʹ��ѯ����Զ��������? 
select rownum,col from table;

54. ���֪�����ݿ���ĳ�������ڵ�tablespace? 
select tablespace_name from user_tables where table_name='test'; 
select * from user_tables���и��ֶ�tablespace_name����oracle��; 
select * from dba_segments where ��;

55. ��ô���Կ�����һ����ԭ��һ���ı��ݱ�? 
create table new_table as (select * from old_table);

55. ��ô��sqlplus���޸�procedure? 
select line,trim(text) t from user_source where name =��a�� order by line;

56. �������procedure����������? 
alter system kill session ,���Ǹ�session��ɱ����������Ҫ�Ȳ������session id 
or 
�Ѹù������¸ĸ����־Ϳ����ˡ�

57. sql reference�Ǹ�ʲô������ 
��һ��sql��ʹ���ֲᣬ�����﷨�������ȵȣ�oracle�ٷ���վ���ĵ�����������.

58. ��β鿴���ݿ��״̬? 
unix�� 
ps -ef |grep ora 
windows�� 
�������Ƿ����� 
�Ƿ�����������ݿ�

59. ��������޸�һ�ű������? 
alter table aaa 
drop constraint aaa_key ; 
alter table aaa 
add constraint aaa_key primary key(a1,b1) ;

60. �ı������ļ��Ĵ�С? 
�� alter database .... datafile .... ; 
�ֹ��ı������ļ��Ĵ�С������ԭ���� �����ļ���û���𺦡�

61. �����鿴oracle������Щ����������֮�У� 
�鿴v$sessions��

62. ��ô���Կ������ݿ��ж��ٸ�tablespace? 
select * from dba_tablespaces;

63. ����޸�oracle���ݿ���û��������� 
�޸�initsid.ora����process�Ӵ��������ݿ�.

64. ��β��һ����¼��������ʱ��? 
������logminer �쿴

65. �����pl/sql�ж�д�ļ��� 
utl_file����Ӧ�û�ͨ��pl/sql��д����ϵͳ�ļ���

66. �����ѡ�&������һ����¼�У� 
insert into a values (translate ('at{&}t','at{}','at'));

67. exp����μӣ������������ 
exp user/pass file=a.dmp tables(bsempms) 
query='"where emp_no="'s09394"'"" �r

68. ����oracle8i֧�ּ���ͷ�����ַ������⣿ 
zhs16gbk����֧

69. data guard��ʲô����� 
����standby�Ļ�����Ʒ

70. ��δ���spfile? 
sql> connect / as sysdba 
sql> select * from v$version; 
sql> create pfile from spfile; 
sql> create spfile from pfile='e:"ora9i"admin"eygle"pfile"init.ora'; 
�ļ��Ѵ����� 
sql> create spfile='e:"ora9i"database"spfileeygle.ora' from pfile='e:"ora9i"admin"eygle"pfile"init.ora'; 
�ļ��Ѵ�����

71. �ں˲�����Ӧ��? 
shmmax 
�������壺������ò�����������oracle���ݿ���߲���ϵͳʹ�ö��������ڴ棬ֻ������������ʹ�õ��ڴ���Ŀ���������Ҳ��Ӱ�����ϵͳ���ں���Դ�� 
�������÷�����0.5*�����ڴ� 
�������ӣ�set shmsys:shminfo_shmmax=10485760 
����shmmin 
�������壺�����ڴ����С��С�� 
�������÷�����һ�㶼���ó�Ϊ1�� 
�������ӣ�set shmsys:shminfo_shmmin=1�� 
����shmmni 
�������壺ϵͳ�й����ڴ�ε��������� 
�������ӣ�set shmsys:shminfo_shmmni=100 
����shmseg 
�������壺ÿ���û����̿���ʹ�õ����Ĺ����ڴ�ε���Ŀ�� 
�������ӣ�set shmsys:shminfo_shmseg=20�� 
����semmni 
�������壺ϵͳ��semaphore identifierer���������� 
�������÷����������������ֵ����Ϊ���ϵͳ�ϵ�����oracle��ʵ����init.ora�е������Ǹ�processes���Ǹ�ֵ��10�� 
�������ӣ�set semsys:seminfo_semmni=100 
����semmns 
�������壺ϵͳ��emaphores���������� 
�������÷��������ֵ����ͨ�����·�ʽ����õ�������oracleʵ����initsid.ora��ߵ�processes��ֵ���ܺͣ���ȥ����processes�������������Ǹ�processes��2��10��oracleʵ���ĸ����� 
�������ӣ�set semsys:seminfo_semmns=200 
����semmsl: 
�������壺һ��set��semaphore���������� 
�������÷��������ó�Ϊ10������oracleʵ����initsid.ora������processes��ֵ�� 
�������ӣ�set semsys:seminfo_semmsl=-200 
72. �����鿴��Щ�û�ӵ��sysdba��sysoperȨ�ޣ� 
sql>conn sys/change_on_install 
sql>select * from v_$pwfile_users;

73. ��ε�������һ�������� 
exp �û�/���� tables=(��1,��,��2)

74. ��ε�������һ�������û��� 
exp system/manager owner=(�û�1,�û�2,��,�û�n) file=�����ļ�

75. ��ζ�clob�ֶν���ȫ�ļ����� 
select * from a where dbms_lob.instr(a.a,'k',1,1)>0;

76. �����ʾ��ǰ�����û�? 
show user

77. ��β鿴�����ļ����õ�·�� ? 
col file_name format a50 
sql> select tablespace_name,file_id,bytes/1024/1024,file_name from dba_data_files order by file_id;

78. ��β鿴���лع��μ���״̬ ? 
sql> col segment format a30 
sql> select segment_name,ccbzzp,tablespace_name,segment_id,file_id,status from dba_rollback_segs

79. ��θı�һ���ֶγ�ʼ�����check��Χ�� 
sql> alter table xxx drop constraint constraint_name; 
֮���ٴ�����Լ��: 
sql> alter table xxx add constraint constraint_name check();

80. oracle����ϵͳ�ļ�����Щ�� 
ͨ��������ͼ��ʾ��Щ�ļ���Ϣ��v$database,v$datafile,v$logfile v$controlfile v$parameter;

81. ������inner join? 
select a.* from bsempms a,bsdptms b where a.dpt_no=b.dpt_no;

82. ���������? 
select a.* from bsempms a,bsdptms b where a.dpt_no=b.dpt_no(+); 
select a.* from bsempms a,bsdptms b wherea.dpt_no(+)=b.dpt_no;

83. ���ִ�нű�sql�ļ�? 
sql>@$path/filename.sql;

84. ��ο������һ�����? 
sql>truncate table table_name;

85. ��β��ж��ٸ����ݿ�ʵ��? 
sql>select * from v$instance;

86. ��β�ѯ���ݿ��ж��ٱ�? 
sql>select * from all_tables;

87. ��β���sql���ִ�����õ�ʱ��? 
sql>set timing on ; 
sql>select * from tablename; 
88. chr()�ķ�������? 
ascii() 
select char(65) from dual; 
select ascii('a') from dual;

89. �ַ��������� 
select concat(col1,col2) from table ; 
select col1||col2 from table ;

90. ��ô��select�����Ľ������һ���ı��ļ��У� 
sql>spool c:"abcd.txt; 
sql>select * from table; 
sql >spool off;

91. ��������sqlִ�е�i/o�� ? 
sql>set autotrace on ; 
sql>select * from table; 
or 
sql>select * from v$filestat ; 
���Բ鿴io��

92. �����sqlplus�¸ı��ֶδ�С? 
alter table table_name modify (field_name varchar2(100)); 
�Ĵ��У���С���У����Ƕ��ǿյģ�

93. ��β�ѯĳ�������? 
select * from table_name where trunc(�����ֶ�)��to_date('2003-05-02','yyyy-mm-dd');

94. sql �����β���ȫ�����ڣ� 
create table bsyear (d date); 
insert into bsyear 
select to_date('20030101','yyyymmdd')+rownum-1 
from all_objects 
where rownum

95. �����޸ı���? 
alter table old_table_name rename to new_table_name;

96. ���ȡ������ķ���״ֵ̬�� 
sqlcode=0

97. ���֪���û�ӵ�е�Ȩ��? 
select * from dba_sys_privs ;

98. ���������ص�oracle9i���г������ı�׼����ʲô���� 
�ӹ�����˵û������ֻ����oracle��˾�����Ĺ涨������վ�����ص�oracle��Ʒ�������� ��ҵ��;��������Ȩ��

99. �����ж����ݿ��������ڹ鵵ģʽ�»��������ڷǹ鵵ģʽ�£� 
����dbastudio������--�����ݿ�---���鵵�鿴��

100. sql>startup pfile��ifile,spfiled��ʲô���� 
pfile����oracle��ͳ�ĳ�ʼ�������ļ����ı���ʽ�ġ� 
ifile������c�������include�����ڰ���һ���ļ����� 
spfile��9i�������Ĳ�����Ĭ�ϵĲ����ļ��������Ƹ�ʽ 
startup��Ӧ��ֻ�ɽ�pfile

101. ���������ǰn����¼�� 
select * from employee where rownum

102. ���֪�������ϵ�oracle֧�ֶ��ٲ����û���? 
sql>conn internal ; 
sql>show parameter processes ;

103. db_block_size�����޸���? 
һ�㲻���ԩo�������������ġ�

104. ���ͳ��������ļ�¼����? 
select (select count(id) from aa)+(select count(id) from bb) ���� from dual;

105. ������sql���ʵ�ֲ���һ���е�n��ֵ�� 
select * from 
(select t.*,dense_rank() over (order by sal) rank from employee) 
where rank = n;


106. ����ڸ����е����ڼ���2�ꣿ( 
select add_months(sysdate,24) from dual;

107. used_ublkΪ��ֵ��ʾʲô��˼? 
it is "harmless".

108. connect string��ָʲô? 
Ӧ����tnsnames.ora�еķ��������������

109. ��������redo log�Ĵ�С�� 
����һ����ʱ��redolog�飬Ȼ���л���־��ɾ����ǰ����־�������µ���־��

110. tablespace �Ƿ��ܴ���4g? 
û������.

111. ���ش��ڵ���n����С����ֵ? 
select ceil(n) from dual;

112. ����С�ڵ���n����С����ֵ? 
select floor(n) from dual;

113. ���ص�ǰ�µ����һ��? 
select last_day(sys2003-10-17) from dual;

114. ��β�ͬ�û������ݵ���? 
imp system/manager file=aa.dmp fromuser=user_old touser=user_new rows=y indexes=y ;

115. ��������ݿ��������ֶε�����? 
sql>select * from user_constraints where constraint_type='p' and table_name='table_name';

116. ������������ӵĺ���? 
sql>select * from bsempms_old intersect select * from bsempms_new; 
sql>select * from bsempms_old union select * from bsempms_new; 
sql>select * from bsempms_old union all select * from bsempms_new;

117. ��������������ĺ���? 
sql>select * from bsempms_old minus select * from bsempms_new;

118. �������sequence? 
��sequence seq_custid 
create sequence seq_custid start 1 incrememt by 1; 
����ʱ: 
create table cust 
{ cust_id smallint not null, 
...} 
insert ʱ: 
insert into table cust 
values( seq_cust.nextval, ...)

Oracle :end------------------------------------------------------------------