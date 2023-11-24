SELECT P.PAY_PRE_H_ID,
       P.PAY_PRE_H_CODE, --付款申请编码
       P.PAY_PRE_H_NAME, --付款申请名称
       P.OPERATION_STATUS, --付款类型  'NOR'原始单据；'RED'红冲单据 
       P.PAY_PAR_PRE_H_ID, --付款申请父ID
       to_char(((select nvl(sum(req_l_val), 0)
                   from XSR_XZ_EX_PAY_PRE_L
                  where PAY_PRE_H_ID = P.PAY_PRE_H_ID) +
               (select nvl(sum(current_paid_sum), 0)
                   from xsr_xz_ex_others_h
                  where pay_req_h_id = P.PAY_PRE_H_ID) -
               (SELECT NVL(SUM(DH.CURRENT_DEDUCT_SUM), 0)
                   FROM XSR_XZ_EX_DEDUCTS_H DH
                  WHERE DH.PAY_PRE_H_ID = P.PAY_PRE_H_ID)),
               'FM999,999,999,999,990.00') AS SUM_PRE_L_VAL, --付款申请单已申请金额总和
       C.CT_H_ID,
       C.CT_H_CODE, --合同编码
       C.CT_H_NAME, --合同名称
       P.EMP_ID,
	   P.ORG_ID,
       (SELECT PE.EMP_NAME FROM XIP_PUB_EMPS PE WHERE P.EMP_ID = PE.EMP_ID) AS IN_OPEN_NAME, --制单人
       C.DEPT_ID,
       (select dept_name from xip_pub_depts where dept_id = P.DP_ID) IN_DEPT_NAME, --制单部门
	   TO_CHAR(P.CREATION_DATE, 'yyyy-mm-dd') IN_OPER_DATE, --制单日期
       P.INTERFACE_FINISH, --传接口状态
       P.VOUCHER_PERIOD_NAME, --制证期间(入账期间)
	   TO_CHAR(P.VOUCHER_DATE, 'yyyy-mm-dd') VOUCHER_DATE, --制证时间(入账日期)	
	   P.PRE_TMP_ID, --申请模板
       F.FRM_URL, --表单URL(或者功能ID)
	   (SELECT MSTYP FROM XSR_XZ_GL_SAP_INTERFACE_H WHERE BUS_H_ID = P.PAY_PRE_H_ID) MSTYP, --稽核上传SAP状态
       (SELECT TO_CHAR(BUDAT,'yyyy-mm-dd') FROM XSR_XZ_GL_SAP_INTERFACE_H WHERE BUS_H_ID = P.PAY_PRE_H_ID) BUDAT, --会计凭证过账日期
       (select h.att_count from XSR_XZ_GL_SAP_INTERFACE_H h where h.bus_h_id=p.PAY_PRE_H_ID)ATT_COUNT,
       (SELECT EMP_NAME FROM XIP_PUB_EMPS E WHERE E.EMP_ID = 
           (SELECT EMP_ID FROM XIP_PUB_USERS WHERE USER_NAME =
                   (SELECT USNAM FROM XSR_XZ_GL_SAP_INTERFACE_H WHERE BUS_H_ID = P.PAY_PRE_H_ID))) EMPNAME, --用户名(稽核人)
	   (SELECT BLDAT FROM XSR_XZ_GL_SAP_INTERFACE_H WHERE BUS_H_ID = P.PAY_PRE_H_ID) BLDAT --凭证中的凭证日期(稽核日期)
       /*(SELECT L.HKONT
          FROM XSR_XZ_GL_SAP_INTERFACE_L L, XSR_XZ_GL_SAP_INTERFACE_H H
         WHERE L.ZXH = H.ZXH
           AND H.BUS_H_ID = P.PAY_PRE_H_ID
           AND 
           (SELECT C.CONCATENATED_SEGMENTS
          FROM XSR_XZ_BA_SAP_CODE_COMB C
         WHERE C.COMBINATION_CODE = L.HKONT) LIKE '银行存款%') HKONT_CODE, --银行存款科目编码
	   (SELECT C.CONCATENATED_SEGMENTS
          FROM XSR_XZ_BA_SAP_CODE_COMB C
         WHERE C.COMBINATION_CODE IN
               (SELECT L.HKONT
                  FROM XSR_XZ_GL_SAP_INTERFACE_L L, XSR_XZ_GL_SAP_INTERFACE_H H
                 WHERE L.ZXH = H.ZXH
                   AND H.BUS_H_ID = P.PAY_PRE_H_ID)
           AND C.CONCATENATED_SEGMENTS LIKE '银行存款%') HKONT_NAME, --银行存款科目名称
       (SELECT L.ZZRESGR FROM XSR_XZ_GL_SAP_INTERFACE_L L,XSR_XZ_GL_SAP_INTERFACE_H H WHERE L.ZXH = H.ZXH AND H.BUS_H_ID = P.PAY_PRE_H_ID AND L.ZZRESGR IS NOT NULL) ZZRESGR,--资金用途
       (SELECT V.VALUE_NAME FROM XSR_XZ_BA_LKP_VALUE V WHERE V.LOOKUP_TYPE = 'FUND_USE' AND V.ENABLED_FLAG = '1' AND V.LOOKUP_CODE = (SELECT L.ZZRESGR FROM XSR_XZ_GL_SAP_INTERFACE_L L,XSR_XZ_GL_SAP_INTERFACE_H H WHERE L.ZXH = H.ZXH AND H.BUS_H_ID = P.PAY_PRE_H_ID AND L.ZZRESGR IS NOT NULL)) ZZRESGR_NAME --资金用途名称*/
  FROM XSR_XZ_EX_PAY_PRE_H P, XSR_XZ_CT_H C,XSR_XZ_EX_PRE_TMP T,XSR_XZ_BA_FRM F
 WHERE P.CT_H_ID = C.CT_H_ID(+)
   AND P.PRE_TMP_ID = T.PRE_TMP_ID(+)
   AND T.FRM_ID = F.FRM_ID(+)
   AND P.AUDIT_STATUS = 'E'
   AND NVL(P.PAY_PRE_H_CODE, ' ') LIKE '%{#pay_req_h_code#}%'
   AND NVL(P.PAY_PRE_H_NAME, ' ') LIKE '%{#pay_req_h_name#}%'
   --AND P.INTERFACE_FINISH IN ('{#interface_finish#}')
   AND NVL((SELECT MSTYP FROM XSR_XZ_GL_SAP_INTERFACE_H WHERE BUS_H_ID = P.PAY_PRE_H_ID),'A') IN ('{#interface_finish#}')
   AND NVL(C.CT_H_CODE, ' ') LIKE '%{#ct_h_code#}%' 
   AND NVL(C.CT_H_NAME, ' ') LIKE '%{#ct_h_name#}%'
   --AND NVL(P.VOUCHER_PERIOD_NAME,' ') LIKE  '%{#voucher_period_name#}%'
   AND NVL((SELECT BUDAT FROM XSR_XZ_GL_SAP_INTERFACE_H WHERE BUS_H_ID = P.PAY_PRE_H_ID),to_date('9999-12-30','yyyy-mm-dd')) >= NVL({?timestamp.q_varcher_date_s?},to_date('1001-1-1','yyyy-mm-dd'))
   AND NVL((SELECT BUDAT FROM XSR_XZ_GL_SAP_INTERFACE_H WHERE BUS_H_ID = P.PAY_PRE_H_ID),to_date('1001-1-1','yyyy-mm-dd')) <= nvl({?timestamp.q_varcher_date_e?},to_date('9999-12-30','yyyy-mm-dd'))          
   AND P.OPERATION_STATUS LIKE '%{#operation_status#}%'
   AND (SELECT E.EMP_NAME
          FROM XIP_PUB_USERS U, XIP_PUB_EMPS E
         WHERE U.EMP_ID = E.EMP_ID
           AND U.USER_ID = P.CREATED_BY) LIKE '%{#in_open_name#}%'
   AND P.PRJ_ID IN (SELECT E.PRJ_ID
                      FROM XSR_XZ_PM_PRJ_EMP E, XIP_PUB_USERS U
                     WHERE E.EMP_ID = U.EMP_ID
                       AND U.USER_ID = {?XIP.userId?})
   ORDER BY P.CREATION_DATE DESC
   
   