--函数

create or replace function f_test(
v_param IN NUMBER)
return  varchar2
as v_name varchar2(200);
begin
CASE v_param
  WHEN '1' then
    select count(distinct STUDENT_ID) into v_name  from TEST_STUDENT order by student_id desc;
  WHEN '2' then
    select count(distinct COURSE_ID)  into v_name  FROM TEST_COURSE ORDER BY COURSE_ID DESC;
  WHEN '3' THEN
     SELECT count(distinct s.STUDENT_ID) into v_name   FROM TEST_STUDENT s,TEST_RESULT r WHERE s.student_id=r.student_id;
   END CASE;
RETURN (v_name);
end;


-- Create table
create table TEST_STUDENT
(
  pk_student_id NUMBER(2),
  student_code  VARCHAR2(50),
  student_name  VARCHAR2(20),
  student_id    NUMBER not null
)
tablespace ZNPM
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TEST_STUDENT.pk_student_id
  is '主键ID';
comment on column TEST_STUDENT.student_code
  is '学生编码';
comment on column TEST_STUDENT.student_name
  is '学生名字';
comment on column TEST_STUDENT.student_id
  is 'ID';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TEST_STUDENT
  add constraint UK_TEST_STUDENT unique (STUDENT_ID)
  using index 
  tablespace ZNPM
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
  
  
-- Create table
create table TEST_RESULT
(
  pk_result_id NUMBER(2),
  student_id   NUMBER(2) not null,
  course_id    NUMBER(2) not null,
  result       NUMBER(5)
)
tablespace ZNPM
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TEST_RESULT.pk_result_id
  is '主键ID';
comment on column TEST_RESULT.student_id
  is '学员ID';
comment on column TEST_RESULT.course_id
  is '课程ID';
comment on column TEST_RESULT.result
  is '成绩';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TEST_RESULT
  add constraint FK_COURSE_ID foreign key (COURSE_ID)
  references TEST_COURSE (COURSE_ID)
  disable;
alter table TEST_RESULT
  add constraint FK_STUDENT_ID foreign key (STUDENT_ID)
  references TEST_STUDENT (STUDENT_ID);
  
  
-- Create table
create table TEST_LOG
(
  log_id   NUMBER(2) not null,
  log_desc VARCHAR2(50)
)
tablespace ZNPM
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TEST_LOG.log_id
  is '日记ID';
comment on column TEST_LOG.log_desc
  is '日记描述';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TEST_LOG
  add constraint PK_LOG_ID primary key (LOG_ID)
  using index 
  tablespace ZNPM
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
  
  
  
  -- Create table
create table TEST_COURSE
(
  course_id    NUMBER(2) not null,
  course_code  VARCHAR2(50),
  course_name  VARCHAR2(20),
  pk_course_id NUMBER(2)
)
tablespace ZNPM
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TEST_COURSE.pk_course_id
  is '主键ID';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TEST_COURSE
  add constraint UK_TEST_COURSE unique (COURSE_ID)
  using index 
  tablespace ZNPM
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
  
  
  
  --视图
  --TEST_COURSE_V
CREATE OR REPLACE VIEW TEST_COURSE_V AS
SELECT COURSE_ID,COURSE_NAME,PK_COURSE_ID FROM TEST_COURSE;


--TEST_RESULT_V
CREATE OR REPLACE VIEW TEST_RESULT_V AS
SELECT r.PK_RESULT_ID,r.RESULT ,r.student_id,r.COURSE_ID,

(select s.student_name  from TEST_STUDENT s where r.student_id=s.student_id)student_NAME,

(select C.COURSE_NAME    from TEST_COURSE C  WHERE C.COURSE_ID=r.COURSE_ID) COURSE_NAME,
(select s.student_code  from TEST_STUDENT s where r.student_id=s.student_id)student_code
from TEST_RESULT r;


--TEST_STUDENT_V
CREATE OR REPLACE VIEW TEST_STUDENT_V AS
SELECT STUDENT_ID,STUDENT_NAME,PK_STUDENT_ID,STUDENT_CODE FROM TEST_STUDENT;

--触发器
--TEST_COURSE_V_T
create or replace trigger "TEST_COURSE_V_T"
instead of insert or delete or update on TEST_COURSE_V
for each row
  /*after insert or delete or update ON TEST_STUDENT */
declare
  v_errinfo    varchar2(1000);
begin
if inserting then
  insert into TEST_COURSE
         (COURSE_ID,
         COURSE_NAME
         )
        values(
        :new.COURSE_ID,
        :new.COURSE_NAME
        );
        NULL;
elsif updating then
       update TEST_COURSE
             set COURSE_ID=:new.COURSE_ID,
                 COURSE_NAME=:new.COURSE_NAME
              where PK_COURSE_ID =:old.PK_COURSE_ID;
 elsif deleting then
      delete TEST_COURSE c where c.PK_COURSE_ID=:old.PK_COURSE_ID;
 end if;
    if inserting or updating then
         null;
    end if;
exception when others then
     v_errinfo := SQLERRM;
     RAISE_APPLICATION_ERROR(-20004,'错误信息:'||v_errinfo);
end;

--TEST_RESULT_V_T
create or replace trigger "TEST_RESULT_V_T"
instead of insert or delete or update on TEST_RESULT_V
for each row
  /*after insert or delete or update ON TEST_STUDENT */
declare
  v_errinfo    varchar2(1000);
begin
  /*检查是否输入成绩错误信息*/
         if :new.RESULT>100 then

            v_errinfo := '只能输入小于100的数字成绩!';
            RAISE_APPLICATION_ERROR(-20004,'警告信息:'||v_errinfo);
            INSERT INTO TEST_LOG (LOG_DESC) VALUES(v_errinfo);
         end if;
if inserting OR UPDATING then
  insert into TEST_RESULT
         (PK_RESULT_ID,
         STUDENT_ID,
         COURSE_ID,
         RESULT
 
         )
        values(
        :new.PK_RESULT_ID,
        :NEW.STUDENT_ID,
        :new.COURSE_ID,
        :new.RESULT
        );
        NULL;
IF updating then
       update TEST_RESULT
             set PK_RESULT_ID=:new.PK_RESULT_ID,
                 COURSE_ID=:new.COURSE_ID,
                 RESULT=:new.RESULT
              where PK_RESULT_ID =:old.PK_RESULT_ID;
			  END IF;
			  END IF;
IF deleting then
      delete TEST_RESULT r where r.PK_RESULT_ID=:old.PK_RESULT_ID;
end if;
exception when others then
     v_errinfo := SQLERRM;
     RAISE_APPLICATION_ERROR(-20004,'错误信息:'||v_errinfo);
end;


--TEST_STUDENT_V_T
create or replace trigger "TEST_STUDENT_V_T"
instead of insert or delete or update on TEST_STUDENT_V
for each row
  /*after insert or delete or update ON TEST_STUDENT */
declare
  v_errinfo    varchar2(1000);
begin
if inserting then
  insert into TEST_STUDENT
         (STUDENT_ID,
         STUDENT_CODE,
         STUDENT_NAME
         )
        values(
        :new.STUDENT_ID,
        :new.STUDENT_CODE,
        :new.STUDENT_NAME
        );
    elsif updating then
       update TEST_STUDENT
             set STUDENT_ID=:new.STUDENT_ID,
                 STUDENT_CODE=:new.STUDENT_CODE,
                 STUDENT_NAME=:new.STUDENT_NAME
              where PK_STUDENT_ID =:old.PK_STUDENT_ID;
     elsif deleting then
      delete TEST_STUDENT t where t.PK_STUDENT_ID=:old.PK_STUDENT_ID;
    end if;
exception when others then
     v_errinfo := SQLERRM;
     RAISE_APPLICATION_ERROR(-20004,'错误信息:'||v_errinfo);
end;

--docInfoSelect
select v.* from (select p.SERIAL_NUMBER,
	   p.DOCUMENTS_ID,
       p.FOLDER_ID,     
       p.MACHINE_GROUP_NUMBER,
(SELECT V.VALUE_NAME FROM XSR_XZ_PM_PROBASE_VALUES V WHERE V.LOOKUP_CODE= p.MACHINE_GROUP_NUMBER AND v.LOOKUP_TYPE = 'GENSET_CODE') MACHINE_NAME,
       p.DOCUMENTS_TYPE,
       p.DOCUMENTS_CODE,
       p.DOCUMENTS_NAME,
       p.DOCUMENTATION_DATE,
       p.SOURCE_UINT,
decode(p.input_data,1,p.attribute1,0,P.SEND_UNIT_NAME)SEND_UNIT_NAME,
P.SOURCE_UINT_ID,
                 P.SOURCE_UINT_NAME,
       p.PROFESSION,
(SELECT V.VALUE_NAME FROM XSR_XZ_PM_PROBASE_VALUES V WHERE V.LOOKUP_CODE=P.PROFESSION AND v.LOOKUP_TYPE = 'PROFESSIONAL_TYPE') PROFESSION_NAME,
       p.FILE_ENTER_DATE,
       p.COMMENTS,
       p.AUDIT_STATUS_NAME,
       p.AUDIT_STATUS,
       p.CREATE_BY,
(select e.emp_name from xip_pub_emps e,xip_pub_users u where u.emp_id=e.emp_id and u.user_id=p.create_by) create_person,

       p.CREATE_DATE,
       p.INPUT_DATA,
       p.ORG_ID,
       p.PRJ_ID,
       p.ORIGIN_ID,
       p.SEND_UNIT,
                 P.SEND_UNIT_ID,
                 (SELECT COUNT(ATT_ID)
                FROM XIP_PUB_ATTS A
                WHERE  A.SRC_ID = p.documents_id
                AND A.ORG_ID = p.org_id) COUNTS, --附件数量
       p.IMAGE_VERSION,
       p.INNER_CONTECT_CODE,
       p.NUMBER_PAGE,
p.NUMBER_PAGE NUMBER_PAGE_S,
       p.RECEIVE_NUMBER,
       p.ENTER_PEOPLE,
       p.CATEGORY_CODE,
P.PROJECT_NAME,
P.EQUIPMENT_NAME,
P.DISTRIBUTE_STATUS,
P.DRAW_DTAE,
P.CURRENT_SITUATION,
(SELECT V.VALUE_NAME FROM XSR_XZ_PM_PROBASE_VALUES V WHERE V.DESCRIPTION=P.PROJECT_NAME and v.lookup_type='PROJECT_CODE') PROJECT_VALUE
  from xsr_xz_pm_doc_p p
 WHERE P.FOLDER_ID IN
       (select A.FOLDER_TREE_ID
          from XSR_XZ_PM_FOLDER A
   --      WHERE A.FOLDER_NODE_TYPE != 'M'
         start with A.folder_tree_id ={?folder_id?}
        connect by prior A.folder_tree_id = A.up_id))V where
 nvl(v.DOCUMENTS_NAME,' ') LIKE '%{#DOC_NAME#}%'
AND NVL(v.SOURCE_UINT_NAME,' ') LIKE '%{#SOURCE_UNIT#}%'
AND (TO_CHAR(v.DOCUMENTATION_DATE,'YYYY-MM-DD') >=NVL(TO_CHAR({?timestamp.DOC_DATE_S?},'YYYY-MM-DD'),TO_CHAR(SYSDATE-5000,'YYYY-MM-DD'))
     AND TO_CHAR(v.DOCUMENTATION_DATE,'YYYY-MM-DD')< =NVL(TO_CHAR({?timestamp.DOC_DATE_E?},'YYYY-MM-DD'),TO_CHAR(SYSDATE+5000,'YYYY-MM-DD'))
)
     AND nvl(v.PROJECT_VALUE,' ') LIKE '%{#RPO_NAME#}%' 
     AND nvl(v.PROFESSION_NAME,' ')  LIKE '%{#PROFESSION_NAME#}%'
     AND nvl(v.SEND_UNIT_NAME,' ') LIKE '%{#SEND_UNIT#}%'
	 
	 
	 
--光伏测试
-- Create table
create table XSR_XZ_BA_LKP_VALUE
(
  values_id         VARCHAR2(36) not null,
  lookup_type       VARCHAR2(32) not null,
  lookup_code       VARCHAR2(32) not null,
  value_name        VARCHAR2(512) not null,
  enabled_flag      NUMBER(1) not null,
  description       VARCHAR2(512),
  start_date_active DATE,
  end_date_active   DATE,
  last_update_date  DATE,
  last_updated_by   VARCHAR2(32),
  created_by        VARCHAR2(32),
  last_update_login VARCHAR2(32),
  creation_date     DATE not null,
  sort              NUMBER
)
tablespace XIP_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table XSR_XZ_BA_LKP_VALUE
  is '数据字典明细';
-- Add comments to the columns 
comment on column XSR_XZ_BA_LKP_VALUE.lookup_code
  is '代码';
comment on column XSR_XZ_BA_LKP_VALUE.value_name
  is '名称';
comment on column XSR_XZ_BA_LKP_VALUE.enabled_flag
  is '启用标志';
comment on column XSR_XZ_BA_LKP_VALUE.sort
  is '排序';
-- Create/Recreate primary, unique and foreign key constraints 
alter table XSR_XZ_BA_LKP_VALUE
  add constraint XSR_XZ_BA_LKP_VALUE primary key (VALUES_ID)
  using index 
  tablespace XIP_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
--XSR_XZ_BA_LKP_TYPE
-- Create table
create table XSR_XZ_BA_LKP_TYPE
(
  lookup_type         VARCHAR2(32) not null,
  type_name           VARCHAR2(128) not null,
  customization_level VARCHAR2(1) not null,
  description         VARCHAR2(512),
  last_update_date    DATE,
  last_updated_by     VARCHAR2(32),
  created_by          VARCHAR2(32),
  last_update_login   VARCHAR2(32),
  creation_date       DATE not null
)
tablespace XIP_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table XSR_XZ_BA_LKP_TYPE
  is '项目配置主信息';
-- Add comments to the columns 
comment on column XSR_XZ_BA_LKP_TYPE.lookup_type
  is '代码';
comment on column XSR_XZ_BA_LKP_TYPE.type_name
  is '标准类型';
comment on column XSR_XZ_BA_LKP_TYPE.customization_level
  is '"访问层次 U  User
                 E   Extensible
                 S   System"';
-- Create/Recreate primary, unique and foreign key constraints 
alter table XSR_XZ_BA_LKP_TYPE
  add constraint XSR_XZ_BA_LKP_TYPE primary key (LOOKUP_TYPE)
  using index 
  tablespace XIP_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
  


