--��ͼ
XZP_CONTENT_FILE_V   

PTS_RPT_REPORT_V  �����ݿ����ͼ

JTDS_PROJECT_COMPANY_V


--��֪��ռ�
XIP_DATA

--��
PTS_RPT_REPORT     --�����ݿ��--

XZP_ORGANIZATION   --��֯��Ϣ

XZP_USER          --�û���--

XZP_ORGANIZATION_STRUT   --��֯�ṹ��--

XZP_PERSON     --ְ����Ϣ��--

PTS_APPLICATION_CHECK  --Ӧ�ü����ϸ��  

PTS_RPT_REPORT   --���������

PTS_CHECK_PRO_AND_WEIGHT  --������Ŀ��Ȩ�ػ�����ϸ��

CTS_PROJECT     --��Ŀ��Ϣ

XZP_CONTENT_PATH  --��������������ϸ

XZP_CONTENT_FILE   --������Ϣ(�Ѵ���)

XZP_CONTENT_TYPE   --�����ļ�����(�Ѵ���)

--��
XSP_BASE_FUNCTION   --


--����
insert into PTS.PTS_RPT_REPORT 
( MAINFORM_ID, MAINFORM_TITLE, 
CREATED_BY, CREATION_DATE, 
CATEGORY_CODE, DEPARTMENT_CODE, 
STATUS ) 
values ( ?, ?, ?, ?, ?, ?, ? )


--
insert into XZAPPS.PTS_APPLICATION_CHECK_V 
( APP_CHECK_ID, PROJECT_ID, A01, A02, B01, C01, D01, E01, F01, G01, H01, K01, J01, L01, MAINFORM_ID, J04, COMPANY_ID ) 
values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )


--ҳ��չ��ҳ��
select MAINFORM_ID ATTRIBUTE_1,
MAINFORM_TITLE ATTRIBUTE_2,
PROJECT_SUM ATTRIBUTE_3,STATUS_NAME ATTRIBUTE_4, '' ATTRIBUTE_5, 
'' ATTRIBUTE_6, '' ATTRIBUTE_7, '' ATTRIBUTE_8, '' ATTRIBUTE_9, 
'' ATTRIBUTE_10, '' ATTRIBUTE_11, '' ATTRIBUTE_12, '' ATTRIBUTE_13, 
'' ATTRIBUTE_14, '' ATTRIBUTE_15, 
'' ATTRIBUTE_16, '' ATTRIBUTE_17, 
'' ATTRIBUTE_18, '' ATTRIBUTE_19, 
'' ATTRIBUTE_20, '' ATTRIBUTE_21, '' ATTRIBUTE_22, '' ATTRIBUTE_23, 
'' ATTRIBUTE_24, '' ATTRIBUTE_25, '' ATTRIBUTE_26, '' ATTRIBUTE_27, 
'' ATTRIBUTE_28, '' ATTRIBUTE_29, '' ATTRIBUTE_30, '' ATTRIBUTE_31, 
'' ATTRIBUTE_32, '' ATTRIBUTE_33, '' ATTRIBUTE_34, '' ATTRIBUTE_35, 
'' ATTRIBUTE_36, '' ATTRIBUTE_37, '' ATTRIBUTE_38, '' ATTRIBUTE_39, 
'' ATTRIBUTE_40,MAINFORM_ID Key_ID 
from PTS_RPT_REPORT_V 
where CATEGORY_CODE='PTS_APPLICATION_CHECK'




---PMISͶ����ɲ�ѯ

CREATE OR REPLACE VIEW XSR_XZ_BG_ALL_V AS
SELECT PV.TSK_ID,
       PV.TSK_CODE,
       PV.TSK_NAME,
       PV.TSK_FULL_CODE,
       PV.TSK_FULL_NAME,
       PV.UP_TSK_ID,
       PV.PRJ_ID,
       PV.STRU_LEVEL_NAME,
       (SELECT SUM(NVL(TV.Y_VAL, 0))
          FROM XSR_XZ_TSK_BG_TSK_V TV
         START WITH TV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR TV.TSK_ID = TV.UP_TSK_ID) Y_VAL, --Ԥ����
       (SELECT SUM(NVL(CTV.MONEY, 0))
          FROM XSR_XZ_TSK_CT_TSK_V CTV
         START WITH CTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR CTV.TSK_ID = CTV.UP_TSK_ID) CT_MONEY, --��ͬǩ�����
       (SELECT SUM(NVL(BTV.BUS_VAL, 0))
          FROM XSR_XZ_TSK_BUS_TSK_V BTV
        START WITH BTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR BTV.TSK_ID = BTV.UP_TSK_ID) BUS_VAL, --�ۼ�Ͷ����ɽ��
       (SELECT SUM(NVL(BTV.BUS_VAL, 0))
          FROM XSR_XZ_TSK_BUS_TSK_WCTZ_V BTV
        START WITH BTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR BTV.TSK_ID = BTV.UP_TSK_ID) NO_BUS_VAL, --δ��Ͷ����ɽ��
       (SELECT SUM(NVL(TV.Y_VAL, 0))
          FROM XSR_XZ_TSK_BG_TSK_V TV
         WHERE TV.BG_ITEM_ID = '23177d9f-8274-4650-9357-f90ed2bdac76'
         START WITH TV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR TV.TSK_ID = TV.UP_TSK_ID) Y_VAL_AZ, --��װԤ����
       (SELECT SUM(NVL(CTV.MONEY, 0))
          FROM XSR_XZ_TSK_CT_TSK_V CTV
         WHERE CTV.BG_ITEM_ID = '23177d9f-8274-4650-9357-f90ed2bdac76'
         START WITH CTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR CTV.TSK_ID = CTV.UP_TSK_ID) Y_VAL_AZ_CT, --��װ��ͬǩ����
       (SELECT SUM(NVL(BTV.BUS_VAL, 0))
          FROM XSR_XZ_TSK_BUS_TSK_V BTV
         WHERE BTV.BG_ITEM_ID = '23177d9f-8274-4650-9357-f90ed2bdac76'
         START WITH BTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR BTV.TSK_ID = BTV.UP_TSK_ID) BUS_VAL_AZ, --��װͶ����ɽ��
       (SELECT SUM(NVL(TV.Y_VAL, 0))
          FROM XSR_XZ_TSK_BG_TSK_V TV
         WHERE TV.BG_ITEM_ID = '6ccf1031-577a-471c-aa11-a341ad868215'
         START WITH TV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR TV.TSK_ID = TV.UP_TSK_ID) Y_VAL_SB, --�豸Ԥ����
       (SELECT SUM(NVL(CTV.MONEY, 0))
          FROM XSR_XZ_TSK_CT_TSK_V CTV
         WHERE CTV.BG_ITEM_ID = '6ccf1031-577a-471c-aa11-a341ad868215'
         START WITH CTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR CTV.TSK_ID = CTV.UP_TSK_ID) Y_VAL_SB_CT, --�豸��ͬǩ����
       (SELECT SUM(NVL(BTV.BUS_VAL, 0))
          FROM XSR_XZ_TSK_BUS_TSK_V BTV
         WHERE BTV.BG_ITEM_ID = '6ccf1031-577a-471c-aa11-a341ad868215'
         START WITH BTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR BTV.TSK_ID = BTV.UP_TSK_ID) BUS_VAL_SB, --�豸Ͷ����ɽ��
       (SELECT SUM(NVL(TV.Y_VAL, 0))
          FROM XSR_XZ_TSK_BG_TSK_V TV
         WHERE TV.BG_ITEM_ID = 'ae92c34e-79c4-4309-bea0-0559e8e8b831'
         START WITH TV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR TV.TSK_ID = TV.UP_TSK_ID) Y_VAL_QT, --����Ԥ����
       (SELECT SUM(NVL(CTV.MONEY, 0))
          FROM XSR_XZ_TSK_CT_TSK_V CTV
         WHERE CTV.BG_ITEM_ID = 'ae92c34e-79c4-4309-bea0-0559e8e8b831'
         START WITH CTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR CTV.TSK_ID = CTV.UP_TSK_ID) Y_VAL_QT_CT, --������ͬǩ����
       (SELECT SUM(NVL(BTV.BUS_VAL, 0))
          FROM XSR_XZ_TSK_BUS_TSK_V BTV
         WHERE BTV.BG_ITEM_ID = 'ae92c34e-79c4-4309-bea0-0559e8e8b831'
         START WITH BTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR BTV.TSK_ID = BTV.UP_TSK_ID) BUS_VAL_QT, --����Ͷ����ɽ��
       (SELECT SUM(NVL(TV.Y_VAL, 0))
          FROM XSR_XZ_TSK_BG_TSK_V TV
         WHERE TV.BG_ITEM_ID = 'd588f353-cecd-44c6-b3d0-fe4ee699f546'
         START WITH TV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR TV.TSK_ID = TV.UP_TSK_ID) Y_VAL_JZ, --����Ԥ����
       (SELECT SUM(NVL(CTV.MONEY, 0))
          FROM XSR_XZ_TSK_CT_TSK_V CTV
         WHERE CTV.BG_ITEM_ID = 'd588f353-cecd-44c6-b3d0-fe4ee699f546'
         START WITH CTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR CTV.TSK_ID = CTV.UP_TSK_ID) Y_VAL_JZ_CT, --������ͬǩ����
       (SELECT SUM(NVL(BTV.BUS_VAL, 0))
          FROM XSR_XZ_TSK_BUS_TSK_V BTV
         WHERE BTV.BG_ITEM_ID = 'd588f353-cecd-44c6-b3d0-fe4ee699f546'
         START WITH BTV.TSK_ID = PV.TSK_ID
        CONNECT BY PRIOR BTV.TSK_ID = BTV.UP_TSK_ID) BUS_VAL_JZ --����Ͷ����ɽ��
  FROM XSR_XZ_TSK_POINT_V PV
  
  
  --������ҳ
  select *
  from jtds_exp_inv_homepage_show_v
  
  --ͼƬ��״ͼ����
  javascript:show('../../../WebRaq45/showRaq/indexRaqPage.jsp?raq_url=KGXMNDTZWC7.raq',400,750);
  
  
  ---��ҳ��״ͼ
  SELECT  M.PROJECT_ID,
       M.REPORT_YEAR,
      (SELECT A.PRJ_NAME FROM XSR_XZ_PM_PRJ_ALL A WHERE A.PRJ_ID=M.PROJECT_ID)  PROJECT_NAME,
       SUM(TOTAL_INVEST) TOTAL_INVEST, --��Ͷ��
       SUM((SELECT NVL(SUM(E.PRE_MONTH_FINISH), 0)
          FROM XSR_XZ_BG_EXPECT_INVEST_MATH E
         WHERE E.PROJECT_ID = M.PROJECT_ID
           AND E.REPORT_YEAR = M.REPORT_YEAR
           AND to_number(E.REPORT_MONTH) <= to_number(M.REPORT_MONTH))) BEGINYEAR_SUM, --������ۼ���� 
        SUM(M.THIS_YEAR_PLAN) THIS_YEAR_PLAN --����Ͷ�ʼƻ�(�걨��)
FROM XSR_XZ_BG_EXPECT_INVEST_MATH M 
  -- where M.REPORT_YEAR = TO_CHAR(SYSDATE,'yyyy') 
   GROUP BY  M.PROJECT_ID,
       M.REPORT_YEAR
	 
	 
	 select * from XSR_XZ_BG_EXPECT_INVEST_MATH
  
  
--���̼�  
  /*SELECT M.MAINFORM_ID, M.MAINFORM_TITLE,M.REPORT_DATE FROM XSR_XZ_PM_REP_H M
 -- WHERE M.CATEGORY_CODE = ? 
	ORDER BY M.REPORT_DATE DESC*/
/*	
	select *
  from (*/select M.DOC_ID,
               M.DOC_CODE,
               M.DOC_NAME as title,
               (CASE WHEN length(M.DOC_NAME) >= 15 THEN  substr(M.DOC_NAME, 0, 15) || '����'  ELSE  '' END) || (CASE WHEN length(M.DOC_NAME) < 15 THEN  substr(M.DOC_NAME, 0, 15)ELSE ''END) as mainform_title,
               (CASE WHEN trunc(sysdate - M.CREATE_DATE) <= 3 THEN '<img src="../images/new.gif" width="20" height="11"/>' ELSE '' END) topnewimg,
               (CASE WHEN M.CREATE_DATE > (sysdate - 1) THEN '[��]'ELSE ''END) topnewtext,
               M.CREATE_DATE
          from XSR_XZ_PM_DOC_M M
         where M.DOC_CODE = 'PTS_PM_AM_GG1'
           and (m.project_id in
               (select P.PROJECT_ID
                   from xsr_xz_ba_org_prj_default E, XSR_XZ_MD_PRO P
                  where P.PRO_ID = E.PRJ_ID
                  and e.user_id = ?
                   ))
            or m.project_id is null
        
   /*     ) a
 order by a.CREATE_DATE desc*/
 
 
 
  select distinct
       TZ.PROJECT_ID,
       (SELECT A.PRJ_NAME FROM XSR_XZ_PM_PRJ_ALL A WHERE A.PRJ_ID=TZ.PROJECT_ID)  PROJECT_NAME,
       nvl(K.BEGINYEAR_SUM,0) BEGINYEAR_SUM,
       nvl(K.THIS_YEAR_PLAN,0) THIS_YEAR_PLAN,
       TZ.TOTAL_INVEST
FROM XSR_XZ_BG_EXPECT_INVEST_MATH TZ ,
(SELECT  M.PROJECT_ID,
      (SELECT A.PRJ_NAME FROM XSR_XZ_PM_PRJ_ALL A WHERE A.PRJ_ID=M.PROJECT_ID)  PROJECT_NAME,
       --sum(TOTAL_INVEST) TOTAL_INVEST, --��Ͷ��
       SUM((SELECT NVL(SUM(E.PRE_MONTH_FINISH), 0)
          FROM XSR_XZ_BG_EXPECT_INVEST_MATH E
         WHERE E.PROJECT_ID = M.PROJECT_ID
           AND E.REPORT_YEAR = M.REPORT_YEAR
           AND to_number(E.REPORT_MONTH) <= to_number(M.REPORT_MONTH))) BEGINYEAR_SUM, --������ۼ���� 
        SUM(M.THIS_YEAR_PLAN) THIS_YEAR_PLAN --����Ͷ�ʼƻ�(�걨��)
FROM XSR_XZ_BG_EXPECT_INVEST_MATH M 
   where M.REPORT_YEAR = TO_CHAR(SYSDATE,'yyyy') 
   GROUP BY  M.PROJECT_ID)   K
   where TZ.PROJECT_ID = K.PROJECT_ID(+)
  
  
  
--���̼�
select *
  from (select M.DOC_ID,
               M.DOC_CODE,
               M.DOC_NAME as title,
               (CASE
                 WHEN length(M.DOC_NAME) >= 15 THEN
                  substr(M.DOC_NAME, 0, 15) || '����'
                 ELSE
                  ''
               END) || (CASE
                 WHEN length(M.DOC_NAME) < 15 THEN
                  substr(M.DOC_NAME, 0, 15)
                 ELSE
                  ''
               END) as mainform_title,
               (CASE
                 WHEN trunc(sysdate - M.CREATE_DATE) <= 3 THEN
                  '<img src="../images/new.gif" width="20" height="11"/>'
                 ELSE
                  ''
               END) topnewimg,
               (CASE
                 WHEN M.CREATE_DATE > (sysdate - 1) THEN
                  '[��]'
                 ELSE
                  ''
               END) topnewtext,
               M.CREATE_DATE
          from XSR_XZ_PM_DOC_M M
         where M.DOC_CODE = 'PTS_PM_AM_GG1'
           and (m.project_id in
               (select P.PROJECT_ID
                   from xsr_xz_ba_org_prj_default E, XSR_XZ_MD_PRO P
                  where P.PRO_ID = E.PRJ_ID
                  --and e.user_id = ?
                   ))
            or m.project_id is null
        
        ) a
 order by a.CREATE_DATE desc
 
 --�鿴��־
 ps -ef|grep tomcat
 
--��Ŀ�ſ�
select l.org_strut_l_id,
       l.org_strut_l_code,
       l.org_strut_l_name,
       (select count(pj.prj_id)
          from XSR_XZ_PM_PRJ_ALL pj
         where pj.prj_id in
               (select sl.pro_id
                  from XSR_XZ_PM_ORG_STRUT_L sl
                 start with sl.org_strut_far_id = l.org_strut_l_id
                connect by prior sl.org_strut_l_id = sl.org_strut_far_id)
           and pj.prj_progress_status = 'ZJ') ZJ, --�ڽ�
       (select count(pj.prj_id)
          from XSR_XZ_PM_PRJ_ALL pj
         where pj.prj_id in
               (select sl.pro_id
                  from XSR_XZ_PM_ORG_STRUT_L sl
                 start with sl.org_strut_far_id = l.org_strut_l_id
                connect by prior sl.org_strut_l_id = sl.org_strut_far_id)
           and pj.prj_progress_status = 'JHZ') JHZ, --�ƻ�
       (select count(pj.prj_id)
          from XSR_XZ_PM_PRJ_ALL pj
         where pj.prj_id in
               (select sl.pro_id
                  from XSR_XZ_PM_ORG_STRUT_L sl
                 start with sl.org_strut_far_id = l.org_strut_l_id
                connect by prior sl.org_strut_l_id = sl.org_strut_far_id)
           and pj.prj_progress_status = 'JG') JG --����
  from XSR_XZ_PM_ORG_STRUT_L l
 where l.org_strut_far_id = '-1'
   and l.org_strut_h_id =
       (select h.org_strut_h_id
          from xsr_xz_pm_org_strut_h h
         where h.org_strut_h_name = '���ܼ���_��Ŀ��')
 order by l.no_directory;
 
 
 --��������������
 http://pm.zhenergy.com.cn:7780/TTABS/faces/orgStructShare/orgStructShareMain.jsp?strutId=org_strut_l_id
 
 --�����Ŀ��
 http://pm.zhenergy.com.cn:7780/WebRaq45/showRaq/showRaqPage.jsp?raq_url=XMGK_INDEX_STATUS.raq&params=PLATE_ID,STATUS&STATUS=JZ&PLATE_ID=1000008730
 
 
 --ds1
SELECT P.*
  FROM ITS_ORGANIZATION_V O, CTS_PROJECT P
 WHERE O.STRUT_ID = P.DEPARTMENT_ID(+)
   AND P.PROJECT_NAME IS NOT NULL
   AND P.ZN_PROJECT_STATUS = ?
 START WITH O.STRUT_ID = ?
CONNECT BY PRIOR O.STRUT_ID = O.UPPER_ORGANIZATION_ID

--ds1
 SELECT a.*
  FROM XSR_XZ_PM_ORG_STRUT_L l, XSR_XZ_PM_PRJ_ALL a
 WHERE l.pro_id = a.prj_id(+)
   AND a.PRJ_NAME IS NOT NULL
   AND a.prj_progress_status = ?
 START WITH l.org_strut_l_id = ?
CONNECT BY PRIOR l.org_strut_l_id = l.org_strut_far_id

--ds2
select l.org_strut_l_id,l.org_strut_l_name
  from XSR_XZ_PM_ORG_STRUT_L l
	where --org_strut_l_name like'%���'
	l.org_strut_far_id = '-1'
	and	l.org_strut_h_id =
       (select h.org_strut_h_id
          from xsr_xz_pm_org_strut_h h
         where h.org_strut_h_name = '���ܼ���_��Ŀ��')
 and l.org_strut_l_id=?
 
 --ds2
 select jpd.Department_Id,jpd.Department_Name
  from jj_pub_department jpd
 where jpd.Upper_Department_Id = 2628341
 and jpd.Department_Id=?
 
 
 --ds3
 SELECT * FROM JTDS_Project_Status_V S
 
--ds3
  --select * from XSR_XZ_PM_PRJ_ALL a
select * from(	
	SELECT distinct '������Ŀ' AS STATUS_NAME, 'JZ' AS STATUS FROM XSR_XZ_PM_PRJ_ALL
UNION ALL
SELECT distinct'�ڽ���Ŀ' AS STATUS_NAME, 'ZJ' AS STATUS FROM XSR_XZ_PM_PRJ_ALL
UNION ALL
SELECT distinct '�ƻ�������Ŀ' AS STATUS_NAME, 'JH' AS STATUS FROM XSR_XZ_PM_PRJ_ALL) a
where a.STATUS=?

--��Ŀ�ſ�
SELECT L.ORG_STRUT_L_ID AS ID, --1
       L.ORG_STRUT_L_ID,
       L.ORG_STRUT_FAR_ID,
      L.ORG_STRUT_FAR_ID AS "parent_id",
/*        L.ORG_STRUT_L_NAME AS "text", */
       decode((select a.prj_progress_status from XSR_XZ_PM_PRJ_ALL  a where a.prj_id=l.pro_id),
       'ZJ','<font style="color:#392884;">'||L.ORG_STRUT_L_NAME||'</font>'|| (select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' ʡ')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       'JHZ','<font style="color:#5BBD2C;">'||L.ORG_STRUT_L_NAME||'</font>'||(select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' ʡ')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       'JG','<font style="color:#E33439;">'||L.ORG_STRUT_L_NAME||'</font>'||(select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' ʡ')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       L.ORG_STRUT_L_NAME) as "text",
       L.ORG_STRUT_L_CODE AS "ICONCLS",--5
       L.ORG_STRUT_FAR_ID AS UP_ID,
     L.IS_DIRECTORY,--�Ƿ�Ŀ¼
     L.NO_DIRECTORY,--Ŀ¼���
     L.IS_COMPANY, --�Ƿ�˾
     L.COM_ID, --��˾ID     --10
     L.COM_NAME, --��˾����
     L.IS_PROJECT, --�Ƿ���Ŀ Y--�� N--��
     L.PRO_ID, --��ĿID
     L.PRO_NAME, --��Ŀ����
       L.NO_LEAF,--ĩ����� --15
     L.ORG_STRUT_COLOR, --��ɫ
     L.IS_USE, --�Ƿ����� Y--��  N--��
     decode(L.IS_PROJECT,'Y',
               (select REPLACE(P.BIRD_EYE_IMG,{?physicsPath?},{?virtualPath?})
                        from XSR_XZ_PM_PRJ_ALL p where p.prj_id=l.pro_id),
            '')BIRD_EYE_IMG,
     decode(L.IS_PROJECT,'Y',
               (select REPLACE(P.GENERALLAY_IMG,{?physicsPath?},{?virtualPath?})
                        from XSR_XZ_PM_PRJ_ALL p where p.prj_id=l.pro_id),
            '')GENERALLAY_IMG,
     decode(L.IS_PROJECT,'Y',
               (select REPLACE(P.ORG_INF_IMG,{?physicsPath?},{?virtualPath?})
                        from XSR_XZ_PM_PRJ_ALL p where p.prj_id=l.pro_id),
            '')ORG_INF_IMG,
     DECODE((SELECT COUNT(*)
                 FROM XSR_XZ_PM_ORG_STRUT_L SL
                WHERE L.ORG_STRUT_L_ID = SL.ORG_STRUT_FAR_ID),
              0,
              'true',
              'false') AS "leaf" --�Ƿ�Ҷ�ӽڵ�    --18
  FROM XSR_XZ_PM_ORG_STRUT_L L
 WHERE L.ORG_STRUT_H_ID IN (SELECT ORG_STRUT_H_ID FROM XSR_XZ_PM_ORG_STRUT_H H WHERE H.IS_CONTROL = 'Y')
   AND   L.ORG_STRUT_L_ID = {?org_strut_l_id?}
   AND (L.COM_ID = DECODE({?isQueryOrg?}, 'Y', DECODE({?isQueryPrj?}, 'Y', '-2', {?parentID?}), '-2')
    OR (L.ORG_STRUT_L_NAME LIKE '%' || NVL({?PRJ_NAME?}, '-NULL-') || '%' AND L.ORG_STRUT_FAR_ID IN(SELECT ORG_STRUT_L_ID FROM XSR_XZ_PM_ORG_STRUT_L WHERE ORG_STRUT_FAR_ID = {?parentID?}))
    OR L.ORG_STRUT_FAR_ID = DECODE({?isQueryOrg?}, 'Y', '-2',  DECODE({?isQueryPrj?}, 'Y', '-2', {?parentID?})))
--���ݵ����Ŀ����������ṹ
   AND L.ORG_STRUT_L_ID = DECODE(ORG_STRUT_FAR_ID,'-1',{?org_strut_l_id?},ORG_STRUT_L_ID)

 
 ----��ϵ��
 select h.MAINFORM_ID ,
       h.MAINFORM_CODE,
     h.ORGANIZATION_ID,
     h.AUDIT_STATUS_NAME,
     h.AUDIT_STATUS,
    (select o.org_name from xip_pub_orgs o where o.org_id = h.ORGANIZATION_ID) ORGANIZATION_NAME,
     h.MAINFORM_TITLE,
     (SELECT T.VALUE_NAME FROM XSR_XZ_BA_LKP_VALUE T WHERE T.LOOKUP_CODE = h.CATEGORY_CODE) CATEGORY_CODE,
     (select e.emp_name from xip_pub_emps e,xip_pub_users u  where h.report_create=u.user_id and u.emp_id=e.emp_id) REPORT_CREATE_NAME, 
     h.REPORT_DATE,
     h.CREATION_DATE,
     h.CREATE_BY,
     h.DEPARTMENT_CODE,
     h.PRJECT_ID,
     h.ATTRIBUTE1,
     h.ATTRIBUTE2,
     (select p.prj_name from xsr_xz_pm_prj_all p where p.prj_id=h.prject_id) PRJECT_NAME,
    (select d.dept_name from xip_pub_depts d where d.dept_code=l.SEND_DEPART) DEPARTMENT_NAME,
      h.REPORT_COMMENTS,
      h.INS_CODE,
      L.DETAIL_ID,
      L.UNIT_NO,
(SELECT V.VALUE_NAME FROM XSR_XZ_PM_PROBASE_VALUES V WHERE V.LOOKUP_CODE=L.UNIT_NO and V.LOOKUP_TYPE = 'GENSET_CODE')UNIT_NAME,
     
(SELECT  VALUE_NAME FROM XSR_XZ_PM_PROBASE_VALUES V WHERE V.LOOKUP_TYPE = 'UNIT_CODE' and V.LOOKUP_CODE= L.PROPOSED_UNIT_CODE) PROPOSED_UNIT_CODE,
      L.FILE_TYPE_CODE,
      L.SPECIALTY_CODE,
    (SELECT V.VALUE_NAME FROM XSR_XZ_PM_PROBASE_VALUES V WHERE V.LOOKUP_CODE=L.SPECIALTY_CODE)  VALUE_NAME,
      L.PROJECT_UNIT_CODE,
      L.IDENTIFIER_CODE,
      L.YEAR_CODE,
      L.LORD_SENT,
      L.COPY_SENT,
      L.IS_REPLY,
      L.REPLY_ODD_NUMBER,
      L.CONTRACT_ID,
   (SELECT H.CT_H_NAME FROM XSR_XZ_CT_H H WHERE H.CT_H_ID=L.CONTRACT_ID) CONTRACT_NAME,
      L.BUDGET_AMOUNT,
      L.DEPARTMENT_CODE,
      L.MANAGERS,
      L.ENTRY_DATE,
      L.ENTRY_PEOPLE,
      L.TEXT_CONTENT,
      L.PROJECT_ID,
   (SELECT T.MAINFORM_TITLE FROM XSR_XZ_PM_REP_H T WHERE T.MAINFORM_ID=L.MAIN_MAINFORM_ID) MAIN_MAINFORM_NAME,
      L.MAIN_MAINFORM_ID,
      L.SEND_DEPART,
(SELECT V.VALUE_NAME FROM XSR_XZ_BA_LKP_VALUE V WHERE V.LOOKUP_CODE=L.SEND_DEPART and V.LOOKUP_TYPE = 'ISSUING_DEPARTMENT')SEND_NAME,
      L.IS_URGENCY,
      L.IS_COST_RELATE,
      L.ASK_FOR_REPLY_DATE,
       L.ENTRY_PEOPLE,
          (select wm_concat(nvl((select c.emp_name
                     from xip_pub_users b,
                          xip_pub_emps  c
                    where b.emp_id=c.emp_id
                          and b.user_id = a.execute_user),
                   a.execute_user)) emp_name
          From xip_wf_ins_task a
         where a.instance_id in
               (select w.instance_id from xip_wf_process_instance w
                          where w.instance_code=h.ins_code)--���ݹ�����id
                and a.task_state='open'
             --   and rownum<2
         ) AUDIT_MAN, --��������-- 

    (SELECT COUNT(ATT_ID)
       FROM XIP_PUB_ATTS A
       WHERE A.CREATED_BY = 'e5bd19c0-79ef-4022-b77b-7d0ff5abc796'
       AND A.SRC_ID = h.MAINFORM_ID
       AND A.ORG_ID = h.ORGANIZATION_ID) COUNTS --��������
from xsr_xz_pm_rep_h h,xsr_xz_pm_rep_l l
where h.mainform_id=l.mainform_id
and h.CATEGORY_CODE=''
and  nvl(h.mainform_code,' ') like '%%'
and nvl(l.MANAGERS, ' ') like '%%'
and h.AUDIT_STATUS like '%%'
and h.create_by='e5bd19c0-79ef-4022-b77b-7d0ff5abc796'
order by h.creation_date desc

SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_PM_PROBASE_VALUES
         WHERE LOOKUP_TYPE = 'GENSET_CODE'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1)
       )
 ORDER BY SORT

/* SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_BA_LKP_VALUE
         WHERE LOOKUP_TYPE = 'GENERATOR'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT */

select t.dept_code code,t.dept_name name from XIP_PUB_DEPTS t

/* SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_BA_LKP_VALUE
         WHERE LOOKUP_TYPE = 'FILE_TYPE'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT */


SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_PM_PROBASE_VALUES
         WHERE LOOKUP_TYPE = 'FILE_TYPE'
           and description like '%����%'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT

/* SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_BA_LKP_VALUE
         WHERE LOOKUP_TYPE = 'ISSUING_ORGANIZATION'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT*/
 

SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_PM_PROBASE_VALUES
         WHERE LOOKUP_TYPE = 'UNIT_CODE'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT
/* SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_BA_LKP_VALUE
         WHERE LOOKUP_TYPE = 'ISSUING_ORGANIZATION'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT */

SELECT *
  FROM (SELECT ' ' CODE, '&nbsp;' NAME, 1 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_PM_PROBASE_VALUES
         WHERE LOOKUP_TYPE = 'PROFESSIONAL_TYPE'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT

/* SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_BA_LKP_VALUE
         WHERE LOOKUP_TYPE = 'PROJECT_UNIT'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT */

SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_PM_PROBASE_VALUES
         WHERE LOOKUP_TYPE = 'PROJECT_CODE'
/*            AND DESCRIPTION LIKE '%%' */
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1))
 ORDER BY SORT

SELECT STATUS_CATEGORY,STATUS_DESC FROM (
SELECT '' STATUS_CATEGORY,'&nbsp;' STATUS_DESC,0 SORT FROM DUAL UNION
SELECT M.STATUS_CATEGORY,M.STATUS_DESC,1 SORT
  FROM XIP_WF_BIZ_STATUS_ENUM M, XIP_WF_ENTITIES S
 WHERE M.ENTITY_ID = S.ENTITY_ID
   AND S.ENTITY_CODE = 'XSR_XZ_PM_REP_H_V'
   AND  M.Enable_Flag = 'Y') ORDER By SORT
   
   
   
---���̼�
select DISTINCT I.MAINFORM_ID,
                I.MAINFORM_TITLE,
                I.REPORT_DATE,
                I.CREATION_DATE,
                C.PRIORITY
  from XSR_XZ_PM_REP_H        i,
       XSR_XZ_PM_EBHPD_CONF_L c,
       XSR_XZ_PM_EBHPD_CONF_H H
 where i.CATEGORY_CODE like 'PTS_PM_EB_KB1%'
      --and i.OU_ORG_ID = 1000008681
   and c.PRJ_ID(+) = i.PRJECT_ID
   AND H.EBHPD_CONF_H_NAME LIKE '���̼�'
   and h.ebhpd_conf_h_id = c.ebhpd_conf_h_id
   and get_gcjb( /*i.OU_ORG_ID,*/ i.PRJECT_ID, i.MAINFORM_ID) <=
       c.PRIORITY_NUM
   and rownum <= 8
 ORDER BY C.PRIORITY ASC, I.REPORT_DATE DESC
 
 --���Ź��̼�
 select distinct i.PK_JTDS_DOC_MANAGEMENT,
                c.priority,
                i.project_id,
                xz_Zn_Character_Intercept(i.DOC_NAME, 'R', 30) mainform_title,
                i.DOC_NAME mainform_title0,
                i.CREATE_DATE creation_date
  from jtds_docs_interface_v i, jtds.jtds_eng_brief_conf c
 where i.DOC_CODE like 'PTS_PM_EB_KB1%'
   --and i.OU_ORG_ID = 1000008681
   and c.project_id(+) = i.project_id
 and jtds_eng_brief_conf_cou(/*i.OU_ORG_ID,*/i.project_id,i.PK_JTDS_DOC_MANAGEMENT)<=c.priority_num
 order by c.priority asc
 

--select * from XSR_XZ_PM_EBHPD_CONF_L L


--����֪ͨ
SELECT *
  FROM (SELECT M.DOC_ID,
               M.DOC_CODE,
               M.DOC_NAME AS TITLE,
               (CASE
                 WHEN length(M.DOC_NAME) >= 15 THEN
                  substr(M.DOC_NAME, 0, 15) || '����'
                 ELSE
                  ''
               END) || (CASE
                 WHEN length(M.DOC_NAME) < 15 THEN
                  substr(M.DOC_NAME, 0, 15)
                 ELSE
                  ''
               END) mainform_title,
               (CASE
                 WHEN trunc(sysdate - M.CREATE_DATE) <= 3 THEN
                  ''
                 ELSE
                  ''
               END) topnewimg,
               M.CREATE_DATE,
               (CASE
                 WHEN M.CREATE_DATE > (sysdate - 1) THEN
                  '[��]'
                 ELSE
                  ''
               END) topnewtext
          FROM XSR_XZ_PM_DOC_M M
         WHERE M.DOC_CODE = 'PTS_PM_AM_GG1'
           and (m.project_id in
               (select P.PROJECT_ID
                   from xsr_xz_ba_org_prj_default E, XSR_XZ_MD_PRO P
                  where P.PRO_ID = E.PRJ_ID
                    and e.user_id = ' null'))
            or M.PROJECT_ID IS null
		    AND rownum <= (select sum(l.priority_num)
                    from XSR_XZ_PM_EBHPD_CONF_L l
                   where M.PRJECT_ID = L.PRJ_ID)) a
 order by a.CREATE_DATE desc
 
 
 --����
 CREATE OR REPLACE PACKAGE BODY XSR_XZ_INDEX_PKG IS
/**
     GET_GCJB
    ��ҳ������ʾ��Ŀ--���̼�
**/
FUNCTION GET_GCJB(/*ouId IN NUMBER,*/pPROID IN VARCHAR2,pk in VARCHAR2)
  RETURN VARCHAR2 AS
  V_COU  NUMBER;
BEGIN
  V_COU := 0;
select rn into V_COU from
(
  Select ROW_NUMBER() OVER(order by H.REPORT_DATE desc) rn,H.MAINFORM_ID
  from XSR_XZ_PM_REP_H H
  where H.CATEGORY_CODE like 'PTS_PM_EB_KB1%'
  --and i.OU_ORG_ID = ouId
  and H.PRJECT_ID=pPROID)
  where MAINFORM_ID=pk;

  RETURN(V_COU);
END;
/**
     GET_GONGGTZ
    ��ҳ������ʾ��Ŀ--����֪ͨ
**/
FUNCTION GET_GONGGTZ(/*ouId IN NUMBER,*/pPROID IN VARCHAR2,pk in VARCHAR2)
  RETURN VARCHAR2 AS
  V_COU  NUMBER;
BEGIN
  V_COU := 0;
select rn into V_COU from
(
  Select ROW_NUMBER() OVER(order by H.REPORT_DATE desc) rn,H.MAINFORM_ID
  from XSR_XZ_PM_REP_H H
  where H.CATEGORY_CODE like 'PTS_PM_AM_GG1%'
  --and i.OU_ORG_ID = ouId
  and H.PRJECT_ID=pPROID)
  where MAINFORM_ID=pk;

  RETURN(V_COU);
END;

END XSR_XZ_INDEX_PKG;


---���ṹչ����ɫ
SELECT L.ORG_STRUT_L_ID   AS ID, --1
       L.ORG_STRUT_FAR_ID,
       L.ORG_STRUT_FAR_ID AS "parent_id",
       /*        L.ORG_STRUT_L_NAME AS "text", */
	   --��ʾ��ɫ����Ҫ����
       decode((select a.prj_progress_status
                from XSR_XZ_PM_PRJ_ALL a
               where a.prj_id = l.pro_id),
              'ZJ',
              '<font style="color:#392884;">' || L.ORG_STRUT_L_NAME ||
              '</font>' ||
              (select '<sup style="color:#E33439;">' ||
                      decode(a.is_pro_szd, 'Y', ' ʡ') || '</sup>'
                 from XSR_XZ_PM_PRJ_ALL a
                where a.prj_id = l.pro_id) ||
              (select '<sup style="color:#E33439;">' ||
                      decode(a.is_pro_foo, 'Y', ' 411') || '</sup>'
                 from XSR_XZ_PM_PRJ_ALL a
                where a.prj_id = l.pro_id),
              'JHZ',
              '<font style="color:#5BBD2C;">' || L.ORG_STRUT_L_NAME ||
              '</font>' ||
              (select '<sup style="color:#E33439;">' ||
                      decode(a.is_pro_szd, 'Y', ' ʡ') || '</sup>'
                 from XSR_XZ_PM_PRJ_ALL a
                where a.prj_id = l.pro_id) ||
              (select '<sup style="color:#E33439;">' ||
                      decode(a.is_pro_foo, 'Y', ' 411') || '</sup>'
                 from XSR_XZ_PM_PRJ_ALL a
                where a.prj_id = l.pro_id),
              'JG',
              '<font style="color:#E33439;">' || L.ORG_STRUT_L_NAME ||
              '</font>' ||
              (select '<sup style="color:#E33439;">' ||
                      decode(a.is_pro_szd, 'Y', ' ʡ') || '</sup>'
                 from XSR_XZ_PM_PRJ_ALL a
                where a.prj_id = l.pro_id) ||
              (select '<sup style="color:#E33439;">' ||
                      decode(a.is_pro_foo, 'Y', ' 411') || '</sup>'
                 from XSR_XZ_PM_PRJ_ALL a
                where a.prj_id = l.pro_id),
              L.ORG_STRUT_L_NAME) as "text",
       L.ORG_STRUT_L_CODE AS "ICONCLS", --5
       L.ORG_STRUT_FAR_ID AS UP_ID,
       L.IS_DIRECTORY, --�Ƿ�Ŀ¼
       L.NO_DIRECTORY, --Ŀ¼���
       L.IS_COMPANY, --�Ƿ�˾
       L.COM_ID, --��˾ID     --10
       L.COM_NAME, --��˾����
       L.IS_PROJECT, --�Ƿ���Ŀ Y--�� N--��
       L.PRO_ID, --��ĿID
       L.PRO_NAME, --��Ŀ����
       L.NO_LEAF, --ĩ����� --15
       L.ORG_STRUT_COLOR, --��ɫ
       L.IS_USE, --�Ƿ����� Y--��  N--��
       decode(L.IS_PROJECT,
              'Y',
              (select REPLACE(P.BIRD_EYE_IMG,
                              { ? physicsPath ? },
                              { ? virtualPath ? })
                 from XSR_XZ_PM_PRJ_ALL p
                where p.prj_id = l.pro_id),
              '') BIRD_EYE_IMG,
       decode(L.IS_PROJECT,
              'Y',
              (select REPLACE(P.GENERALLAY_IMG,
                              { ? physicsPath ? },
                              { ? virtualPath ? })
                 from XSR_XZ_PM_PRJ_ALL p
                where p.prj_id = l.pro_id),
              '') GENERALLAY_IMG,
       decode(L.IS_PROJECT,
              'Y',
              (select REPLACE(P.ORG_INF_IMG,
                              { ? physicsPath ? },
                              { ? virtualPath ? })
                 from XSR_XZ_PM_PRJ_ALL p
                where p.prj_id = l.pro_id),
              '') ORG_INF_IMG,
       DECODE((SELECT COUNT(*)
                FROM XSR_XZ_PM_ORG_STRUT_L SL
               WHERE L.ORG_STRUT_L_ID = SL.ORG_STRUT_FAR_ID),
              0,
              'true',
              'false') AS "leaf" --�Ƿ�Ҷ�ӽڵ�    --18
  FROM XSR_XZ_PM_ORG_STRUT_L L
 WHERE L.ORG_STRUT_H_ID IN (SELECT ORG_STRUT_H_ID
                              FROM XSR_XZ_PM_ORG_STRUT_H H
                             WHERE H.IS_CONTROL = 'Y')
   AND (L.COM_ID =
       DECODE({ ? isQueryOrg ? },
               'Y',
               DECODE({ ? isQueryPrj ? }, 'Y', '-2', { ? parentID ? }),
               '-2') OR
       (L.ORG_STRUT_L_NAME LIKE
       '%' || NVL({ ? PRJ_NAME ? }, '-NULL-') || '%' AND
       L.ORG_STRUT_FAR_ID IN
       (SELECT ORG_STRUT_L_ID
            FROM XSR_XZ_PM_ORG_STRUT_L
           WHERE ORG_STRUT_FAR_ID = { ? parentID ? })) OR
       L.ORG_STRUT_FAR_ID =
       DECODE({ ? isQueryOrg ? },
               'Y',
               '-2',
               DECODE({ ? isQueryPrj ? }, 'Y', '-2', { ? parentID ? })))

			   
--��ȿ���
select distinct i.PK_JTDS_DOC_MANAGEMENT,
                i2.rn,
                i.project_name,
                i.project_id,
                i.DOCUMENT_TYPE,
                i.ATTRIBUTE3 BH,
                xz_Zn_Character_Intercept(i.DOC_NAME, 'R', 40) mainform_title,
                i.DOC_NAME mainform_title0,
                i.CREATE_DATE creation_date,
                /*i.doc_url,
                i.document_name,
                decode(i.doc_url,'��','��','<a title="'||i.document_name||'" target="_blank" href="'||i.doc_url||'">����</a>') as href,*/
                i.CREATER,
                (CASE
                  WHEN trunc(sysdate - i.CREATE_DATE) <= 3 THEN
                   '[��]'
                  ELSE
                   ''
                END) newtext,
                DECODE((SELECT COUNT(1)
                         FROM jtds_docs_url_interface_v TL
                        WHERE TL.project_id = i.project_id /*��ǰ����������ĿID*/
                       /*�رո��˲��������� ���� person_code  
                                        AND TL.PROJECT_ID IN
                                            (SELECT p.project_company \*������˾STRUT_ID*\
                                               FROM XZP_PROFILE_OPTIONS_VALUES_V T,cts_project p
                                              WHERE T.PROFILE_OPTION_ID = 185698321 \*���˲�����Ŀ*\
                                              AND t.profile_option_value=p.project_id
                                                AND T.LEVEL_VALUE =
                                                    (SELECT XU.USER_ID
                                                       FROM XZP.XZP_USER XU
                                                      WHERE XU.USER_CODE =? )  \* ?? �û�ID*\    
                                             )
                       */
                       ),
                       0,
                       0,
                       1) PROFILE_OPTION_TURE
  from jtds_docs_url_interface_v i,
       (select rownum rn, only_id.PK_JTDS_DOC_MANAGEMENT PK_ID
          from (select distinct i.PK_JTDS_DOC_MANAGEMENT,
                                i.CREATE_DATE,
                                i.project_id
                  from jtds_docs_url_interface_v i
                 where i.DOC_CODE = ?
                /*and i.project_id in
                (select p.project_company
                   from xzp_organization_strut t, cts_project p
                  where p.project_company(+) = t.STRUT_ID
                    and p.project_id is not null
                 connect by prior t.STRUT_ID = t.UPPER_ORGANIZATION_ID
                  start with t.STRUT_ID = 1000076039)*/
                 order by i.CREATE_DATE desc, i.project_id desc) only_id) i2
 where i.DOC_CODE = ?
   and i2.PK_ID = i.PK_JTDS_DOC_MANAGEMENT
   and i.project_id = ?
      /*(select p.project_company
        from xzp_organization_strut t, cts_project p
       where p.project_company(+) = t.STRUT_ID
         and p.project_id is not null
      connect by prior t.STRUT_ID = t.UPPER_ORGANIZATION_ID
       start with t.STRUT_ID =1000076039)*/
   AND i.doc_type_code = NVL(?, i.doc_type_code)
 order by i.CREATE_DATE desc, i.project_id desc


select distinct i.PK_JTDS_DOC_MANAGEMENT,
                i2.rn,
                i.project_name,
                i.project_id,
                i.DOCUMENT_TYPE,
                i.ATTRIBUTE3 BH,
                xz_Zn_Character_Intercept(i.DOC_NAME, 'R', 40) mainform_title,
                i.DOC_NAME mainform_title0,
                i.CREATE_DATE creation_date,
                /*i.doc_url,
                i.document_name,
                decode(i.doc_url,'��','��','<a title="'||i.document_name||'" target="_blank" href="'||i.doc_url||'">����</a>') as href,*/
                i.CREATER,
                (CASE
                  WHEN trunc(sysdate - i.CREATE_DATE) <= 3 THEN
                   '[��]'
                  ELSE
                   ''
                END) newtext,
                DECODE((SELECT COUNT(1)
                FROM jtds_docs_url_interface_v TL
               WHERE TL.project_id = i.project_id    /*��ǰ����������ĿID*/
/*�رո��˲��������� ���� person_code  
                 AND TL.PROJECT_ID IN
                     (SELECT p.project_company \*������˾STRUT_ID*\
                        FROM XZP_PROFILE_OPTIONS_VALUES_V T,cts_project p
                       WHERE T.PROFILE_OPTION_ID = 185698321 \*���˲�����Ŀ*\
                       AND t.profile_option_value=p.project_id
                         AND T.LEVEL_VALUE =
                             (SELECT XU.USER_ID
                                FROM XZP.XZP_USER XU
                               WHERE XU.USER_CODE =? )  \* ?? �û�ID*\    
                      )
*/
                      ),0,0,1) PROFILE_OPTION_TURE
  from jtds_docs_url_interface_v i,
       (select rownum rn, only_id.PK_JTDS_DOC_MANAGEMENT PK_ID
          from (select distinct i.PK_JTDS_DOC_MANAGEMENT,
                                i.CREATE_DATE,
                                i.project_id
                  from jtds_docs_url_interface_v i
                 where i.DOC_CODE =?
                   /*and i.project_id in
                       (select p.project_company
                          from xzp_organization_strut t, cts_project p
                         where p.project_company(+) = t.STRUT_ID
                           and p.project_id is not null
                        connect by prior t.STRUT_ID = t.UPPER_ORGANIZATION_ID
                         start with t.STRUT_ID = 1000076039)*/
                 order by i.CREATE_DATE desc, i.project_id desc) only_id) i2
 where i.DOC_CODE =?
   and i2.PK_ID=i.PK_JTDS_DOC_MANAGEMENT
   and i.project_id =?
       /*(select p.project_company
          from xzp_organization_strut t, cts_project p
         where p.project_company(+) = t.STRUT_ID
           and p.project_id is not null
        connect by prior t.STRUT_ID = t.UPPER_ORGANIZATION_ID
         start with t.STRUT_ID =1000076039)*/
     AND i.doc_type_code=NVL(?,i.doc_type_code)
 order by i.CREATE_DATE desc, i.project_id desc 
			   
--���̼�
/indexDataManageAction.do?method=getGcjbInfoByCode&CATEGORY_CODE=PTS_PM_EB_KB1
--��Ŀ�ſ�
/indexDataManageAction.do?method=getXmgkInfo
--����֪ͨ
/indexDataManageAction.do?method=getGongGtzInfoByUserId

--���Ͷ�ʼƻ���������
/indexDataManageAction.do?method=getExpectInvestMath

--PMISͶ����ɲ�ѯ
/indexDataManageAction.do?method=getPmis

--��ȡ��ҳͼƬ�б�
/indexDataManageAction.do?method=getScrollPhots


/indexDataManageAction.do?method=getDBSYCount


"���|��˾���ƣ�"+query2("jdbc/ctsAppsDS","select t.all_organization_name from xzp.xzp_organization_strut t WHERE t.strut_id="+@STRUT_ID)+pro.Select(PRJ_NAME)

SELECT M.PROJECT_ID,
       M.REPORT_YEAR,
       (SELECT A.PRJ_NAME
          FROM XSR_XZ_PM_PRJ_ALL A
         WHERE A.PRJ_ID = M.PROJECT_ID) PROJECT_NAME,
       SUM(TOTAL_INVEST) TOTAL_INVEST,
	   SUM(M.BEFORE_YEAR_FINISH)BEFORE_YEAR_FINISH,
       SUM((SELECT NVL(SUM(E.PRE_MONTH_FINISH), 0)
             FROM XSR_XZ_BG_EXPECT_INVEST_MATH E
            WHERE E.PROJECT_ID = M.PROJECT_ID
              AND E.REPORT_YEAR = M.REPORT_YEAR
              AND to_number(E.REPORT_MONTH) <= to_number(M.REPORT_MONTH))) BEGINYEAR_SUM,
       SUM(M.THIS_YEAR_PLAN) THIS_YEAR_PLAN
  FROM XSR_XZ_BG_EXPECT_INVEST_MATH M
 WHERE M.REPORT_YEAR = TO_CHAR(SYSDATE, 'yyyy')
 GROUP BY M.PROJECT_ID, M.REPORT_YEAR
 
 
 
 ---�����״ͼ����
 http://10.156.76.41:8089/znjtpm/showRaq/showRaqPage.jsp?raq_url=KGXMNDTZWC7.raq
 
 
 ---�������ڵ����Ŀ
 SELECT L.ORG_STRUT_L_ID AS ID, --1
       L.ORG_STRUT_FAR_ID,
      L.ORG_STRUT_FAR_ID AS "parent_id",
/*        L.ORG_STRUT_L_NAME AS "text", */
       decode((select a.prj_progress_status from XSR_XZ_PM_PRJ_ALL  a where a.prj_id=l.pro_id),
       'ZJ','<font style="color:#392884;">'||L.ORG_STRUT_L_NAME||'</font>'|| (select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' ʡ')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       'JHZ','<font style="color:#5BBD2C;">'||L.ORG_STRUT_L_NAME||'</font>'||(select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' ʡ')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       'JG','<font style="color:#E33439;">'||L.ORG_STRUT_L_NAME||'</font>'||(select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' ʡ')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       L.ORG_STRUT_L_NAME) as "text",
       L.ORG_STRUT_L_CODE AS "ICONCLS",--5
       L.ORG_STRUT_FAR_ID AS UP_ID,
     L.IS_DIRECTORY,--�Ƿ�Ŀ¼
     L.NO_DIRECTORY,--Ŀ¼���
     L.IS_COMPANY, --�Ƿ�˾
     L.COM_ID, --��˾ID     --10
     L.COM_NAME, --��˾����
     L.IS_PROJECT, --�Ƿ���Ŀ Y--�� N--��
     L.PRO_ID, --��ĿID
     L.PRO_NAME, --��Ŀ����
       L.NO_LEAF,--ĩ����� --15
     L.ORG_STRUT_COLOR, --��ɫ
     L.IS_USE, --�Ƿ����� Y--��  N--��
     decode(L.IS_PROJECT,'Y',
               (select REPLACE(P.BIRD_EYE_IMG,{?physicsPath?},{?virtualPath?})
                        from XSR_XZ_PM_PRJ_ALL p where p.prj_id=l.pro_id),
            '')BIRD_EYE_IMG,
     decode(L.IS_PROJECT,'Y',
               (select REPLACE(P.GENERALLAY_IMG,{?physicsPath?},{?virtualPath?})
                        from XSR_XZ_PM_PRJ_ALL p where p.prj_id=l.pro_id),
            '')GENERALLAY_IMG,
     decode(L.IS_PROJECT,'Y',
               (select REPLACE(P.ORG_INF_IMG,{?physicsPath?},{?virtualPath?})
                        from XSR_XZ_PM_PRJ_ALL p where p.prj_id=l.pro_id),
            '')ORG_INF_IMG,
     DECODE((SELECT COUNT(*)
                 FROM XSR_XZ_PM_ORG_STRUT_L SL
                WHERE L.ORG_STRUT_L_ID = SL.ORG_STRUT_FAR_ID),
              0,
              'true',
              'false') AS "leaf" --�Ƿ�Ҷ�ӽڵ�    --18
  FROM XSR_XZ_PM_ORG_STRUT_L L,XZR_XZ_ORG_STRUT_MRO M
 WHERE 
   L.ORG_STRUT_L_ID=M.ORG_STRUT_L_ID
   AND L.IS_USE='Y'
   AND M.USER_ID={?XIP.userId?}
   AND L.ORG_STRUT_H_ID IN (SELECT ORG_STRUT_H_ID FROM XSR_XZ_PM_ORG_STRUT_H H WHERE H.IS_CONTROL = 'Y')
   AND (L.COM_ID = DECODE({?isQueryOrg?}, 'Y', DECODE({?isQueryPrj?}, 'Y', '-2', {?parentID?}), '-2')
    OR (L.ORG_STRUT_L_NAME LIKE '%' || NVL({?PRJ_NAME?}, '-NULL-') || '%' AND L.ORG_STRUT_FAR_ID IN(SELECT ORG_STRUT_L_ID FROM XSR_XZ_PM_ORG_STRUT_L WHERE ORG_STRUT_FAR_ID = {?parentID?}))
    OR L.ORG_STRUT_FAR_ID = DECODE({?isQueryOrg?}, 'Y', '-2',  DECODE({?isQueryPrj?}, 'Y', '-2', {?parentID?})))
   ORDER BY L.NO_DIRECTORY,L.IS_PROJECT,L.IS_COMPANY,L.NO_LEAF

   
---2�����Բ鿴��Ŀ����
SELECT L.ORG_STRUT_L_ID AS ID,
       L.ORG_STRUT_FAR_ID,
	   L.ORG_STRUT_FAR_ID AS "parent_id",
       L.ORG_STRUT_L_NAME AS "text",
       L.ORG_STRUT_L_CODE AS "ICONCLS",
       L.ORG_STRUT_FAR_ID AS UP_ID,
	   L.IS_DIRECTORY,--�Ƿ�Ŀ¼
	   L.NO_DIRECTORY,--Ŀ¼���
	   L.IS_COMPANY, --�Ƿ�˾
	   L.COM_ID, --��˾ID
	   L.COM_NAME, --��˾����
	   L.IS_PROJECT, --�Ƿ���Ŀ Y--�� N--��
	   L.PRO_ID, --��ĿID
	   L.PRO_NAME, --��Ŀ����
       L.NO_LEAF,--ĩ�����
	   L.ORG_STRUT_COLOR, --��ɫ
	   L.IS_USE, --�Ƿ����� Y--��  N--��
       DECODE((SELECT COUNT(*)
                 FROM XSR_XZ_PM_ORG_STRUT_L SL
                WHERE L.ORG_STRUT_L_ID = SL.ORG_STRUT_FAR_ID),
              0,
              'true',
              'false') AS "leaf" --�Ƿ�Ҷ�ӽڵ� 
  FROM XSR_XZ_PM_ORG_STRUT_L L
 WHERE L.ORG_STRUT_H_ID IN (SELECT ORG_STRUT_H_ID FROM XSR_XZ_PM_ORG_STRUT_H H WHERE H.IS_CONTROL = 'Y')
   AND (L.COM_ID = DECODE({?isQueryOrg?}, 'Y', DECODE({?isQueryPrj?}, 'Y', '-2', {?parentID?}), '-2')
    OR (L.ORG_STRUT_L_NAME LIKE '%' || NVL({?PRJ_NAME?}, '-NULL-') || '%' AND L.ORG_STRUT_FAR_ID IN(SELECT ORG_STRUT_L_ID FROM XSR_XZ_PM_ORG_STRUT_L WHERE ORG_STRUT_FAR_ID = {?parentID?}))
    OR L.ORG_STRUT_FAR_ID = DECODE({?isQueryOrg?}, 'Y', '-2',  DECODE({?isQueryPrj?}, 'Y', '-2', {?parentID?})))

	
---����ϵͼ	
SELECT L.ORG_STRUT_L_ID AS id,
       (SELECT CASE  WHEN ORG_STRUT_FAR_ID='-1' THEN   '���ڵ�' ELSE PRJ_PROGRESS_STATUS END
          FROM XSR_XZ_PM_PRJ_ALL A
         WHERE A.PRJ_ID = L.PRO_ID) as state,
       L.ORG_STRUT_FAR_ID AS parent_id,
       (SELECT ORG_STRUT_L_NAME
          FROM XSR_XZ_PM_ORG_STRUT_L ML
         WHERE ML.ORG_STRUT_L_ID = L.ORG_STRUT_FAR_ID) as parent,
       L.ORG_STRUT_L_NAME AS name
  FROM XSR_XZ_PM_ORG_STRUT_L L
 WHERE L.ORG_STRUT_H_ID IN (SELECT ORG_STRUT_H_ID
                              FROM XSR_XZ_PM_ORG_STRUT_H H
                             WHERE H.IS_CONTROL = 'Y')
							 
							

SELECT L.ORG_STRUT_L_ID AS id,
       DECODE(L.ORG_STRUT_FAR_ID,'-1','root',(SELECT PRJ_PROGRESS_STATUS FROM XSR_XZ_PM_PRJ_ALL A
         WHERE A.PRJ_ID = L.PRO_ID))state,
/*       (SELECT CASE  WHEN ORG_STRUT_FAR_ID='-1' THEN   'root' ELSE PRJ_PROGRESS_STATUS END
          FROM XSR_XZ_PM_PRJ_ALL A
         WHERE A.PRJ_ID = L.PRO_ID) as state,*/
       L.ORG_STRUT_FAR_ID AS parent_id,
       (SELECT ORG_STRUT_L_NAME
          FROM XSR_XZ_PM_ORG_STRUT_L ML
         WHERE ML.ORG_STRUT_L_ID = L.ORG_STRUT_FAR_ID) as parent,
       L.ORG_STRUT_L_NAME AS name
  FROM XSR_XZ_PM_ORG_STRUT_L L
 WHERE L.ORG_STRUT_H_ID IN (SELECT ORG_STRUT_H_ID
                              FROM XSR_XZ_PM_ORG_STRUT_H H
                             WHERE H.IS_CONTROL = 'Y')							
	
--���̼�	
http://pm.zhenergy.com.cn:7780/TTABS/faces/projectPresendtation/presendMainNew.jsp?DOC_CODE=PTS_PM_EB_KB1

http://pm.zhenergy.com.cn:7780/WebRaq45/showRaq/showRaqPageTab.jsp?raq_url=PTS_PM_ENGBRIEF_ALLONE.raq&params=DOC_CODE,STRUT_ID&DOC_CODE=PTS_PM_EB_KB1&STRUT_ID=2628341

http://pm.zhenergy.com.cn:7780/WebRaq45/showRaq/showRaqPageTab.jsp?raq_url=PTS_PM_FILES_LIST.raq&params=DOC_CODE,STRUT_ID,project_id&DOC_CODE=PTS_PM_EB_KB1&STRUT_ID=1000124495&project_id=3491315&NkImage=null&ZZXXImage=null&ZPMBZImage=null




		   
		      
---Ͷ�ʼƻ����	��old��		  
SELECT M.PROJECT_ID,
       M.REPORT_YEAR,
       (select SL.org_strut_l_name
          from XSR_XZ_PM_ORG_STRUT_L SL
         where SL.org_strut_l_id IN
               (SELECT org_strut_far_id FROM XSR_XZ_PM_ORG_STRUT_L  WHERE
                pro_id = m.project_id)) ORG_STRUT_L_NAME,
       (SELECT A.PRJ_NAME
          FROM XSR_XZ_PM_PRJ_ALL A
         WHERE A.PRJ_ID = M.PROJECT_ID) PROJECT_NAME,
       SUM(TOTAL_INVEST) TOTAL_INVEST,
       SUM((SELECT NVL(SUM(E.PRE_MONTH_FINISH), 0)
             FROM XSR_XZ_BG_EXPECT_INVEST_MATH E
            WHERE E.PROJECT_ID = M.PROJECT_ID
              AND E.REPORT_YEAR = M.REPORT_YEAR
              AND to_number(E.REPORT_MONTH) <= to_number(M.REPORT_MONTH))) BEGINYEAR_SUM,
       SUM(M.THIS_YEAR_PLAN) THIS_YEAR_PLAN
  FROM XSR_XZ_BG_EXPECT_INVEST_MATH M, XSR_XZ_PM_ORG_STRUT_L L
 WHERE M.REPORT_YEAR = TO_CHAR(SYSDATE, 'yyyy')
 --AND M.PROJECT_ID=L.PRO_ID
/* AND l.org_strut_far_id = '-1'
   and l.org_strut_h_id =
       (select h.org_strut_h_id
          from xsr_xz_pm_org_strut_h h
         where h.org_strut_h_name = '���ܼ���')*/
 GROUP BY M.PROJECT_ID, M.REPORT_YEAR
 ---Ͷ�ʼƻ���ɣ���飩			  
SELECT INVEST_ID,
       m.ORG_ID,
       (SELECT O.ORG_NAME
          FROM XIP_PUB_ORGS O
         WHERE O.ORG_ID = M.ORG_ID) ORGANIZATION_NAME,
       m.PROJECT_ID,
       p.PRJ_NAME,
      /* (SELECT P.PRJ_NAME
          FROM XSR_XZ_PM_PRJ_ALL P
         WHERE P.PRJ_ID = M.PROJECT_ID) PROJECT_NAME, --��Ŀ����*/
       REPORT_YEAR, --������ڼ����(�ϱ����)
       REPORT_MONTH, --������ڼ��·�(�ϱ��·�)
       M.REPORT_YEAR || M.REPORT_MONTH REPORT_PROIED,--�ϱ�����
       REPORTER, --�ϱ���
     (SELECT E.EMP_NAME
          FROM XIP_PUB_EMPS E, XIP_PUB_USERS U
         WHERE M.REPORTER = U.USER_ID
           AND U.EMP_ID = E.EMP_ID) REPORTER_NAME,
       TOTAL_INVEST, --��Ͷ��
       BEFORE_YEAR_FINISH, --��������ۼ�Ͷ�����(�걨��)
       THIS_YEAR_PLAN, --����Ͷ�ʼƻ�(�걨��)
       PRE_MONTH_FINISH, --�ϱ��·�Ͷ�����(�±���)
       THIS_MONTH_PLAN, --����Ͷ�ʼƻ�(�±���)
               CREATE_DATE,
       (SELECT NVL(SUM(E.PRE_MONTH_FINISH), 0)
          FROM XSR_XZ_BG_EXPECT_INVEST_MATH E
         WHERE E.PROJECT_ID = M.PROJECT_ID
           AND E.REPORT_YEAR = M.REPORT_YEAR
           AND to_number(E.REPORT_MONTH) <= to_number(M.REPORT_MONTH)) BEGINYEAR_SUM --������ۼ����
  FROM XSR_XZ_BG_EXPECT_INVEST_MATH M left join XSR_XZ_PM_PRJ_ALL p on m.PROJECT_ID = p.prj_id
  where p.prj_name  LIKE  '%%'
    AND M.REPORT_YEAR || M.REPORT_MONTH LIKE '%%'
   and  M.PROJECT_ID in (select e.PRJ_ID 
     from xsr_xz_pm_prj_emp e where e.emp_id =(select u.emp_id from xip_pub_users u where u.user_id= '69169fc5-4746-4e87-a461-34e95aa2f72b'))
     ORDER BY M.CREATE_DATE DESC

--����������Ŀ
SELECT L.ORG_STRUT_L_ID,
       L.ORG_STRUT_FAR_ID,
       L.ORG_STRUT_FAR_ID PARENT_ID,
       L.ORG_STRUT_L_NAME AS "text",
       L.ORG_STRUT_L_CODE AS "ICONCLS",
       L.ORG_STRUT_L_ID AS id,
       L.IS_DIRECTORY,--�Ƿ�Ŀ¼
       L.NO_DIRECTORY,--Ŀ¼���
       L.IS_COMPANY, --�Ƿ�˾
       L.COM_ID, --��˾ID
       L.COM_NAME, --��˾����
       L.IS_PROJECT, --�Ƿ���Ŀ Y--�� N--��
       L.PRO_ID, --��ĿID
       L.PRO_NAME, --��Ŀ����
       L.NO_LEAF,--ĩ�����
       L.ORG_STRUT_COLOR, --��ɫ
       L.IS_USE, --�Ƿ����� Y--��  N--��
       decode((select count(*)
                from XSR_XZ_PM_ORG_STRUT_L SL
               WHERE L.ORG_STRUT_L_ID = SL.ORG_STRUT_FAR_ID),
              0,
              'true',
              'false') as "leaf" --�Ƿ�Ҷ�ӽڵ� 
  FROM XSR_XZ_PM_ORG_STRUT_L L,XSR_XZ_PM_PRJ_ALL a
 WHERE ORG_STRUT_H_ID='0da1fe20-0917-4dca-acf8-bfef189ac45b'
   and l.pro_id=a.prj_id(+)
   AND (ORG_STRUT_FAR_ID = '88ae890f-f2fa-462e-9b94-93cb4f07ed2c'
    OR ('88ae890f-f2fa-462e-9b94-93cb4f07ed2c' IS NULL AND ORG_STRUT_FAR_ID = '-1'))

 ORDER BY decode(L.IS_DIRECTORY,'N','A','B'),
 decode(a.prj_progress_status,'ZJ', 'A', 'JHZ', 'B', 'JG', 'C', ''),
L.IS_PROJECT,L.IS_COMPANY,L.NO_LEAF,L.NO_DIRECTORY

	 
SELECT ORGANIZATION_NAME,
       INVEST_ID,
       PROJECT_ID,
       PRJ_NAME,
       REPORT_YEAR,
       REPORT_MONTH,
       REPORT_PROIED,
       TOTAL_INVEST,
       BEFORE_YEAR_FINISH,
       THIS_YEAR_PLAN,
       PRE_MONTH_FINISH,
       THIS_MONTH_PLAN,
       CREATE_DATE,
       BEGINYEAR_SUM
  FROM (SELECT INVEST_ID,
               m.ORG_ID,
               (SELECT O.ORG_NAME
                  FROM XIP_PUB_ORGS O
                 WHERE O.ORG_ID = M.ORG_ID) ORGANIZATION_NAME,
               m.PROJECT_ID,
               p.PRJ_NAME,
               /* (SELECT P.PRJ_NAME
                FROM XSR_XZ_PM_PRJ_ALL P
               WHERE P.PRJ_ID = M.PROJECT_ID) PROJECT_NAME, --��Ŀ����*/
               REPORT_YEAR, --������ڼ����(�ϱ����)
               REPORT_MONTH, --������ڼ��·�(�ϱ��·�)
               M.REPORT_YEAR || M.REPORT_MONTH REPORT_PROIED, --�ϱ�����
               REPORTER, --�ϱ���
               (SELECT E.EMP_NAME
                  FROM XIP_PUB_EMPS E, XIP_PUB_USERS U
                 WHERE M.REPORTER = U.USER_ID
                   AND U.EMP_ID = E.EMP_ID) REPORTER_NAME,
               TOTAL_INVEST, --��Ͷ��
               BEFORE_YEAR_FINISH, --��������ۼ�Ͷ�����(�걨��)
               THIS_YEAR_PLAN, --����Ͷ�ʼƻ�(�걨��)
               PRE_MONTH_FINISH, --�ϱ��·�Ͷ�����(�±���)
               THIS_MONTH_PLAN, --����Ͷ�ʼƻ�(�±���)
               CREATE_DATE,
               (SELECT NVL(SUM(E.PRE_MONTH_FINISH), 0)
                  FROM XSR_XZ_BG_EXPECT_INVEST_MATH E
                 WHERE E.PROJECT_ID = M.PROJECT_ID
                   AND E.REPORT_YEAR = M.REPORT_YEAR
                   AND to_number(E.REPORT_MONTH) <= to_number(M.REPORT_MONTH)) BEGINYEAR_SUM --������ۼ����
          FROM XSR_XZ_BG_EXPECT_INVEST_MATH M
          left join XSR_XZ_PM_PRJ_ALL p
            on m.PROJECT_ID = p.prj_id
         where p.prj_name LIKE '%%'
           AND M.REPORT_YEAR || M.REPORT_MONTH LIKE '%%'
           and M.PROJECT_ID in
               (select e.PRJ_ID
                  from xsr_xz_pm_prj_emp e
                 where e.emp_id =
                       (select u.emp_id
                          from xip_pub_users u
                         where u.user_id =
                               '69169fc5-4746-4e87-a461-34e95aa2f72b'))
         ORDER BY M.CREATE_DATE DESC) A,
       XSR_XZ_PM_ORG_STRUT_L L
/*WHERE L.org_strut_l_id = A.PROJECT_ID(+)*/
 START WITH l.org_strut_far_id = '-1'
CONNECT BY PRIOR l.org_strut_far_id = l.org_strut_l_id





nvl(f.TOTAL_INVEST/10000,0)           TOTAL_INVEST,                    --��Ͷ��
       nvl(f.BEFOREYEARFINISH/10000,0)       BEFOREYEARFINISH,                 --��������ۼ����Ͷ��
       nvl(f.THEYEARPLAN/10000,0)            THEYEARPLAN,                      --����Ͷ�ʼƻ�
       NVL(f.PRE_MONTH_FINISH/10000,0)       PRE_MONTH_FINISH,          --����Ͷ�����
       nvl(f.THIS_MONTH_PLAN/10000,0)        THIS_MONTH_PLAN,                  --����Ͷ�ʼƻ�
       nvl(f.YEAR_PRE_MONTH_FINISH/10000,0)  YEAR_PRE_MONTH_FINISH,            --���굽���µ��ۼ�Ͷ�����
       TO_CHAR(f.TOTAL_INVEST/10000, 'FM999,999,990.00') inv_all,        --�ƻ���Ͷ��
       TO_CHAR(round((f.BEFOREYEARFINISH+f.YEAR_PRE_MONTH_FINISH)/10000), 'FM999,999,990.00') inv, --Ͷ�������
       TO_CHAR(f.THEYEARPLAN/10000, 'FM999,999,990.00') THEYEAR_PLAN,        --����Ͷ�ʼƻ�
       TO_CHAR(f.YEAR_PRE_MONTH_FINISH/10000, 'FM999,999,990.00') YEARPREMONTH_FINISH       --����Ͷ�����	 
			  
FROM XSR_XZ_PM_ORG_STRUT_L		


----����ϵͼ(����)
SELECT L.ORG_STRUT_L_ID AS id,
       DECODE(L.ORG_STRUT_FAR_ID,'-1','root',(SELECT PRJ_PROGRESS_STATUS FROM XSR_XZ_PM_PRJ_ALL A
         WHERE A.PRJ_ID = L.PRO_ID))state,
/*       (SELECT CASE  WHEN ORG_STRUT_FAR_ID='-1' THEN   'root' ELSE PRJ_PROGRESS_STATUS END
          FROM XSR_XZ_PM_PRJ_ALL A
         WHERE A.PRJ_ID = L.PRO_ID) as state,*/
       L.ORG_STRUT_FAR_ID AS parent_id,
       (SELECT ORG_STRUT_L_NAME
          FROM XSR_XZ_PM_ORG_STRUT_L ML
         WHERE ML.ORG_STRUT_L_ID = L.ORG_STRUT_FAR_ID) as parent,
       L.ORG_STRUT_L_NAME AS name
  FROM XSR_XZ_PM_ORG_STRUT_L L
 WHERE L.ORG_STRUT_H_ID IN (SELECT ORG_STRUT_H_ID
                              FROM XSR_XZ_PM_ORG_STRUT_H H
                             WHERE H.IS_CONTROL = 'Y')	  
							 
							 
// alert(cellIndex);
// alert(record.get('ASK_DOCUMENT'));
var MAIN_ID = record.get('MAIN_ID');
var vSql1="SELECT IS_PBULISH FROM XSR_XZ_PM_QUALITY_SUPERVISE_H  WHERE MAIN_ID='"+MAIN_ID+"'";
var t_rowInfo=xzDbSqlQuery(vSql1);
var vIs_pbulish=t_rowInfo.IS_PBULISH;

if(cellIndex=='7' && record.get('ASK_DOCUMENT')== 1)
{

    var vUserID='{#XIP.userId#}';
    var vSrc_id=record.get('LINE_ID');
    var vOrg_id='000';
    var vAtt_cat='ZNKJFW/PM/ZJJH';
    var vBus_no='ASK_DOCUMENT';
  	var vUrl='main?xwl=23ZKHQXN1OB4&userId='+vUserID+'&src_id='+vSrc_id+'&org_id='+vOrg_id+'&att_cat='+vAtt_cat+'&bus_no='+vBus_no+'&canUp=Y&canDown=Y&canDel=Y';
	
  attaWin.show();
    document.getElementById("iframe1").src = vUrl;
}
if(cellIndex=='8' && record.get('NOTICE')== 1)
{
    var vUserID='{#XIP.userId#}';
    var vSrc_id=record.get('LINE_ID');
    var vOrg_id='000';
    var vAtt_cat='ZNKJFW/PM/ZJJH';
    var vBus_no='NOTICE';
  	var vUrl='main?xwl=23ZKHQXN1OB4&userId='+vUserID+'&src_id='+vSrc_id+'&org_id='+vOrg_id+'&att_cat='+vAtt_cat+'&bus_no='+vBus_no+'&canUp=Y&canDown=Y&canDel=Y';
	attaWin.show();
    document.getElementById("iframe1").src = vUrl;
}
if(cellIndex=='9' && record.get('REPORT_DATA')== 1)
{
    var vUserID='{#XIP.userId#}';
    var vSrc_id=record.get('LINE_ID');
    var vOrg_id='000';
    var vAtt_cat='ZNKJFW/PM/ZJJH';
    var vBus_no='REPORT_DATA';
  	var vUrl='main?xwl=23ZKHQXN1OB4&userId='+vUserID+'&src_id='+vSrc_id+'&org_id='+vOrg_id+'&att_cat='+vAtt_cat+'&bus_no='+vBus_no+'&canUp=Y&canDown=Y&canDel=Y';
	attaWin.show();
    document.getElementById("iframe1").src = vUrl;
}
if(cellIndex=='10' && record.get('RECORD')== 1)
{
    var vUserID='{#XIP.userId#}';
    var vSrc_id=record.get('LINE_ID');
    var vOrg_id='000';
    var vAtt_cat='ZNKJFW/PM/ZJJH';
    var vBus_no='RECORD';
  	var vUrl='main?xwl=23ZKHQXN1OB4&userId='+vUserID+'&src_id='+vSrc_id+'&org_id='+vOrg_id+'&att_cat='+vAtt_cat+'&bus_no='+vBus_no+'&canUp=Y&canDown=Y&canDel=Y';
	attaWin.show();
    document.getElementById("iframe1").src = vUrl;
}
if(cellIndex=='11' && record.get('REPORT')== 1)
{
    var vUserID='{#XIP.userId#}';
    var vSrc_id=record.get('LINE_ID');
    var vOrg_id='000';
    var vAtt_cat='ZNKJFW/PM/ZJJH';
    var vBus_no='REPORT';
  	var vUrl='main?xwl=23ZKHQXN1OB4&userId='+vUserID+'&src_id='+vSrc_id+'&org_id='+vOrg_id+'&att_cat='+vAtt_cat+'&bus_no='+vBus_no+'&canUp=Y&canDown=Y&canDel=Y';
	attaWin.show();
    document.getElementById("iframe1").src = vUrl;
}
if(cellIndex=='12' && record.get('OFF_LOOP_DOCUMENT')== 1)
{
    var vUserID='{#XIP.userId#}';
    var vSrc_id=record.get('LINE_ID');
    var vOrg_id='000';
    var vAtt_cat='ZNKJFW/PM/ZJJH';
    var vBus_no='OFF_LOOP_DOCUMENT';
  	var vUrl='main?xwl=23ZKHQXN1OB4&userId='+vUserID+'&src_id='+vSrc_id+'&org_id='+vOrg_id+'&att_cat='+vAtt_cat+'&bus_no='+vBus_no+'&canUp=Y&canDown=Y&canDel=Y';
	attaWin.show();
    document.getElementById("iframe1").src = vUrl;
}

'main?xwl=23ZL62MXM8JU&userId=f92c688a-df48-d4e2-e040-a8c021824389&src_id='+O3+'&org_id=102&att_cat=XSR_XZ&bus_no=NOTICE
&canUp=N&canDown=Y&canDel=N'
'main?xwl=23ZL62MXM8JU&userId=f92c688a-df48-d4e2-e040-a8c021824389&src_id='+O3+'&org_id=102&att_cat=XSR_XZ&bus_no=ASK_DOCUMNENT&canUp=N&canDown=Y&canDel=N'


---���¹��̱�������
update XSR_XZ_CT_PLAN_D set 
CHECK_QTY='992.9', 
CHECK_AMT='788486.32' 
where PLAN_D_ID='52349A6347897CA8E050960A806A4EDE' AND AU_CODE= 'JHJY'

update XSR_XZ_CT_PLAN_L set 
L_AMOUNT='992.9', 
L_VAL_BEFORE='788486.32',
L_VAL_TAX = (to_number((SELECT to_number(L.L_PRICE)*to_number('992.9') a FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = '63171079-99f1-4e80-8eed-27fcafdf9886')) -to_number('788486.32')),
L_VAL = (SELECT to_number(L.L_PRICE)*to_number('992.9') FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = '63171079-99f1-4e80-8eed-27fcafdf9886')
where PLAN_L_ID='63171079-99f1-4e80-8eed-27fcafdf9886'


--��д���������Ĵ洢����
CREATE OR REPLACE PACKAGE BODY xsr_xz_ct_pkg IS
  /*ʩ������������д�������
    ����:
          p_ins_code                  ʵ������ ${e_instance_code}
          p_key_id                    ����ֵ  ${e_business_id}
          p_audit_status              ״̬��  ${e_current_biz_status_cat}
          p_audit_status_name         ״̬����  ${e_current_biz_status_desc}
          p_return_msg                ����XML
  
  */
  
  PROCEDURE wf_ct_h_callback(p_ins_code          in VARCHAR2,
                             p_key_id            in VARCHAR2,
                             p_audit_status      in VARCHAR2,
                             p_audit_status_name in VARCHAR2,
                             p_user_id           in VARCHAR2,
                             p_return_msg        out clob) IS
    t_uuid     varchar2(255);
    t_plan_l_id     varchar2(255);
    t_tmp_code varchar2(255);
    v_flag     number;
    v_msg      varchar2(2000);
    v_sql      varchar2(2000);
    CURSOR CT_PLAN_L IS
      SELECT L.PLAN_L_ID FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_H_ID = p_key_id;  
    CURSOR CT_PLAN_D IS
      SELECT * FROM XSR_XZ_CT_PLAN_D WHERE PLAN_L_ID =t_plan_l_id;  
  BEGIN  
      FOR PLAN_L IN CT_PLAN_L LOOP
        t_plan_l_id:=PLAN_L.PLAN_L_ID;             
      FOR PLAN_D IN CT_PLAN_D LOOP
        UPDATE XSR_XZ_CT_PLAN_L
             SET L_AMOUNT     = PLAN_D.CHECK_QTY,
                 L_VAL_BEFORE = PLAN_D.CHECK_AMT,
                 L_VAL_TAX=
                 to_number((SELECT to_number(L.L_PRICE)*to_number(PLAN_D.CHECK_QTY) a FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = PLAN_D.PLAN_L_ID)) -to_number(PLAN_D.CHECK_AMT),
                 L_VAL = 
                 (SELECT to_number(L.L_PRICE)*to_number(PLAN_D.CHECK_QTY) b FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = PLAN_D.PLAN_L_ID)
           WHERE PLAN_L_ID = PLAN_D.PLAN_L_ID;
          END LOOP;
          END LOOP;
    --���ɳɱ��鼯
    xsr_xz_pm_pkg.INSERT_COST_ACCUMULATION_BL(p_key_id,
                                              p_user_id,
                                              v_flag,
                                              v_msg);
    if v_flag = 0 then
      /* execute immediate v_sql;*/
      commit;
      p_return_msg := '<result><flag>0</flag><msg>ok!</msg></result>';
    else
      rollback;
      p_return_msg := '<result><flag>1</flag><msg>' || v_msg ||
                      '</msg></result>';
    end if;
  exception
    when others then
      rollback;
      p_return_msg := '<result><flag>1</flag><msg> updateWfAuditStatus pro error, bizStatus=' ||
                      p_audit_status || ' !</msg></result>';
	END wf_ct_h_callback;	
 END;


