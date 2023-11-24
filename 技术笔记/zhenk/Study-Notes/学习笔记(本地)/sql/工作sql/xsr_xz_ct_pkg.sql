CREATE OR REPLACE PACKAGE BODY xsr_xz_ct_pkg IS
  /*施工报量审批回调金额数量
    参数:
          p_ins_code                  实例代码 ${e_instance_code}
          p_key_id                    主键值  ${e_business_id}
          p_audit_status              状态码  ${e_current_biz_status_cat}
          p_audit_status_name         状态名称  ${e_current_biz_status_desc}
          p_return_msg                返回XML
  
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
                 L_VAL = PLAN_D.CHECK_AMT,
								 L_VAL_TAX=
								 to_number((SELECT to_number(L.L_PRICE)*to_number(PLAN_D.CHECK_QTY) a FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = PLAN_D.PLAN_L_ID)) -to_number(PLAN_D.CHECK_AMT),
                 L_VAL_BEFORE = 
								 (SELECT to_number(L.L_PRICE)*to_number(PLAN_D.CHECK_QTY) b FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = PLAN_D.PLAN_L_ID)
           WHERE PLAN_L_ID = PLAN_D.PLAN_L_ID;
					END LOOP;
          END LOOP;
		--生成成本归集
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
  /*启动合同审批流程*/
  PROCEDURE wf_ct_h(p_ct_h_id IN VARCHAR2,
                    flag      OUT NUMBER,
                    msg       OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    v_inv_h_code   varchar2(1000);
    v_inv_h_name   varchar2(1000);
    v_flag         number;
    v_msg          varchar2(1000);
    h_flag         number;
    B_FLAG         varchar2(2);
    h_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from xsr_xz_ct_h h
     where h.ct_h_id = p_ct_h_id;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
    /*2.检查单据预算*/
    -- vld_inv(p_inv_h_id,'Y',v_flag,v_msg);
    flag := 1;
    if v_flag = 0 then
      flag := v_flag;
      msg  := v_msg;
    else
      flag := 1;
      xsr_xz_ba_pkg.gen_wf_para_bh('XSR_XZ_CT_H_V',
                                   'CT_H_ID',
                                   p_ct_h_id,
                                   'CT_H_ID',
                                   'CT_H_CODE',
                                   'ORG_ID',
                                   'DEPT_ID',
                                   'CT_MONEY',
                                   v_flag,
                                   v_msg);
      /*      xsr_xz_ba_pkg.gen_wf_para_test('XSR_XZ_CT_H_V',
      'CT_H_ID',
      p_ct_h_id,
      'CT_H_ID',
      'CT_H_CODE',
      'ORG_ID',
      'DEPT_ID',
      'CT_MONEY',
      'ATT_PERSON_ONE',
      'ATT_PERSON_TWO',
      'ATT_PERSON_THREE',
      v_flag,
      v_msg);*/
      if v_flag = 0 then
        --合成失败--
        flag := v_flag;
        msg  := v_msg;
      else
        --调用概算归集程序包
        --查询对应的模板是否占概
        -- SELECT HH.BUDGET_FLAG into B_FLAG FROM XSR_XZ_CT_TYPE_H  HH 
        -- WHERE  HH.TYPE_H_ID=(SELECT M.TYPE_H_ID FROM XSR_XZ_CT_H M WHERE M.CT_H_ID=p_ct_h_id);
        -- if B_FLAG = 'Y' then
        -- xsr_xz_pm_pkg.INSERT_BUDGET_BUS(p_ct_h_id, h_flag, h_msg);
        --if h_flag = 0 then
        --概算归集失败--
        -- flag := h_flag;
        --msg  := h_msg;
        --else
        -- flag := 1;
        --  msg  := v_msg;
        -- end if;
        --else
        flag := 1;
        msg  := v_msg;
        -- end if;
      end if;
    end if;
  exception
    when others then
      flag := 0;
      msg  := p_ct_h_id || ':流程启动错误：' || SQLERRM;
  end;
	 /*启动合同三方协议审批流程*/
  PROCEDURE wf_ct_three_h(p_ct_three_h_id IN VARCHAR2,
                    flag      OUT NUMBER,
                    msg       OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    v_inv_h_code   varchar2(1000);
    v_inv_h_name   varchar2(1000);
    v_flag         number;
    v_msg          varchar2(1000);
    h_flag         number;
    B_FLAG         varchar2(2);
    h_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from xsr_xz_ct_three_h h
     where h.ct_three_h_id = p_ct_three_h_id;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
    /*2.检查单据预算*/
    -- vld_inv(p_inv_h_id,'Y',v_flag,v_msg);
    flag := 1;
    if v_flag = 0 then
      flag := v_flag;
      msg  := v_msg;
    else
      flag := 1;
      xsr_xz_ba_pkg.gen_wf_para_bh('XSR_XZ_CT_THREE_H',
                                   'CT_THREE_H_ID',
                                   p_ct_three_h_id,
                                   'CT_THREE_H_ID',
                                   'CT_THREE_H_CODE',
                                   'ORG_ID',
                                   'DEPT_ID',
                                   'CT_MONEY',
                                   v_flag,
                                   v_msg);
      if v_flag = 0 then
        --合成失败--
        flag := v_flag;
        msg  := v_msg;
      else
        flag := 1;
        msg  := v_msg;
      end if;
    end if;
  exception
    when others then
      flag := 0;
      msg  := p_ct_three_h_id || ':流程启动错误：' || SQLERRM;
  end;
  /*启动合同发票流程*/
  PROCEDURE wf_ct_trx(p_trx_h_id IN VARCHAR2,
                      flag       OUT NUMBER,
                      msg        OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    v_inv_h_code   varchar2(1000);
    v_inv_h_name   varchar2(1000);
    v_flag         number;
    v_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from xsr_xz_ct_trx_h h
     where h.trx_h_id = p_trx_h_id;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
    /*2.检查单据预算*/
    -- vld_inv(p_inv_h_id,'Y',v_flag,v_msg);
    flag := 1;
    if v_flag = 0 then
      flag := v_flag;
      msg  := v_msg;
    else
      flag := 1;
      xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_CT_TRX_H_V',
                                'TRX_H_ID',
                                p_trx_h_id,
                                'TRX_H_ID',
                                'TRX_H_CODE',
                                'ORG_ID',
                                'DEPT_ID',
                                v_flag,
                                v_msg);
      if v_flag = 0 then
        --合成失败--
        flag := v_flag;
        msg  := v_msg;
      else
        flag := 1;
        msg  := v_msg;
      end if;
    end if;
  exception
    when others then
      flag := 0;
      msg  := p_trx_h_id || ':流程启动错误：' || SQLERRM;
  end;

  /**
  * 工程报量审批启动前测试
  */
  PROCEDURE wf_ct_plan_start_check(P_PLAN_H_ID IN VARCHAR2,
                                   R_FLAG      OUT NUMBER,
                                   R_MSG       OUT VARCHAR2) IS
    CURSOR plan_l_cur IS
      SELECT L.PLAN_L_ID,
             L.PRJ_ID,
             L.TSK_ID,
             L.BG_ITEM_ID,
             L.BG_FARE_ID,
             L.CNY_CODE,
             L.L_VAL
        FROM XSR_XZ_CT_PLAN_L L
       WHERE L.PLAN_H_ID = P_PLAN_H_ID;
    plan_l_row plan_l_cur%rowtype;
    t_flag     number;
    t_msg      varchar2(3000);
  BEGIN
    --循环报量行信息
    FOR plan_l_row IN plan_l_cur LOOP
      XSR_XZ_PM_PKG.CheckTaskBudgetCost_Control(plan_l_row.Prj_Id,
                                                plan_l_row.Tsk_Id,
                                                plan_l_row.Bg_Item_Id,
                                                plan_l_row.Bg_Fare_Id,
                                                plan_l_row.Cny_Code,
                                                P_PLAN_H_ID,
                                                plan_l_row.PLAN_L_ID,
                                                TO_CHAR(plan_l_row.L_VAL),
                                                t_flag,
                                                t_msg);
      IF t_flag = 1 THEN
        R_FLAG := 1;
        R_MSG  := R_MSG || t_msg;
      ELSIF t_flag = 2 THEN
        R_FLAG := 2;
        R_MSG  := t_msg;
        RETURN;
      ELSIF t_flag = -1 THEN
        R_FLAG := -1;
        R_MSG  := t_msg;
        RETURN;
      ELSE
        R_FLAG := 0;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      R_FLAG := -1;
      R_MSG  := P_PLAN_H_ID || ':流程启动检测错误：' || SQLERRM;
  END;

  /**
  * 工程报量审批启动调用
  */
  PROCEDURE wf_ct_plan_start(P_PLAN_H_ID IN VARCHAR2,
                             R_FLAG      OUT NUMBER,
                             R_MSG       OUT VARCHAR2) IS
    v_audit_status varchar2(1000);
  BEGIN
    --检查单据状态
    SELECT H.AUDIT_STATUS
      INTO v_audit_status
      FROM XSR_XZ_CT_PLAN_H H
     WHERE H.PLAN_H_ID = P_PLAN_H_ID;
    IF v_audit_status NOT IN ('A', 'D', 'R') THEN
      R_FLAG := 0;
      R_MSG  := '只有起草、撤回、驳回的单据才能启动流程！';
      RETURN;
    END IF;
  
    xsr_xz_ba_pkg.gen_wf_para_bh('XSR_XZ_CT_PLAN_H_V',
                              'PLAN_H_ID',
                              P_PLAN_H_ID,
                              'PLAN_H_ID',
                              'PLAN_H_CODE',
                              'ORG_ID',
                              'DEPT_ID',
                              'ATTRIBUTE1',
                              R_FLAG,
                              R_MSG);
  
  EXCEPTION
    WHEN OTHERS THEN
      R_FLAG := 0;
      R_MSG  := P_PLAN_H_ID || ':流程启动错误：' || SQLERRM;
  END wf_ct_plan_start;

  /*
     工程报量审批通过(成本归集)
     参数:
          p_ins_code                  实例代码 ${e_instance_code}
          p_key_id                    主键值  ${e_business_id}
          p_audit_status              状态码  ${e_current_biz_status_cat}
          p_audit_status_name         状态名称  ${e_current_biz_status_desc}
          p_return_msg                返回XML
  
  */
  PROCEDURE wf_ct_plan_accept(p_ins_code          in VARCHAR2,
                              p_key_id            in VARCHAR2,
                              p_audit_status      in VARCHAR2,
                              p_audit_status_name in VARCHAR2,
                              p_user_id           in VARCHAR2,
                              p_return_msg        out clob) IS
    t_uuid     varchar2(255);
    t_tmp_code varchar2(255);
    v_flag     number;
    v_msg      varchar2(2000);
    v_sql      varchar2(2000);
		t_plan_l_id     varchar2(255);
    
/*    CURSOR CT_PLAN_L IS
      SELECT * FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_H_ID = p_key_id;  */
    CURSOR CT_PLAN_L IS
      SELECT L.PLAN_L_ID FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_H_ID = p_key_id;  
    CURSOR CT_PLAN_D IS
      SELECT * FROM XSR_XZ_CT_PLAN_D WHERE PLAN_L_ID =t_plan_l_id;  			
  BEGIN
    /* v_sql := 'update XSR_XZ_CT_PLAN_H
    set ins_code=''' || p_ins_code || ''', 
        audit_status=''' || p_audit_status || ''',
        audit_status_name=''' || p_audit_status_name || '''
    where PLAN_H_ID = ''' || p_key_id || '''';
    INSERT INTO  TST (T1) VALUES (v_sql);
    COMMIT;*/
/*    CUX_PO_PKG.INSERT_PO_ERROR_T('wangxf', -1, '', '');*/
  
    SELECT T.PLAN_TMP_CODE
      INTO t_tmp_code
      FROM XSR_XZ_CT_PLAN_H H, XSR_XZ_CT_PLAN_TMP T
     WHERE H.PLAN_TMP_ID = T.PLAN_TMP_ID
       AND H.PLAN_H_ID = p_key_id;
			 
    --如果报量模板类型为 施工报量  
     IF t_tmp_code = 'XZCTPLAN013' then
        
/*       FOR PLAN_L IN CT_PLAN_L LOOP
        UPDATE XSR_XZ_CT_PLAN_L
             SET L_AMOUNT     = PLAN_L.ATTRIBUTE4,
                 L_VAL_BEFORE = PLAN_L.ATTRIBUTE4 * PLAN_L.L_PRICE_BEFORE,
                 L_VAL        = PLAN_L.ATTRIBUTE4 * PLAN_L.L_PRICE,
                 L_VAL_TAX   =
                 (PLAN_L.L_PRICE_BEFORE - PLAN_L.L_PRICE) * PLAN_L.ATTRIBUTE4
           WHERE PLAN_L_ID = PLAN_L.PLAN_L_ID;
          END LOOP;*/
/*从D表的金额和数量回写到L表中*/
      FOR PLAN_L IN CT_PLAN_L LOOP
        t_plan_l_id:=PLAN_L.PLAN_L_ID;             
      FOR PLAN_D IN CT_PLAN_D LOOP
        UPDATE XSR_XZ_CT_PLAN_L
             SET L_AMOUNT     = PLAN_D.CHECK_QTY,---本次报量数
                 L_VAL = PLAN_D.CHECK_AMT,---含税金额
								 /*税额=含税金额-不含税金额*/
                 L_VAL_TAX=
                 to_number(PLAN_D.CHECK_AMT)-to_number((SELECT to_number(L.L_PRICE_BEFORE)*to_number(PLAN_D.CHECK_QTY) a FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = PLAN_D.PLAN_L_ID)),---税额
								 /*不含税金额=本次报量数*不含税单价*/
                 L_VAL_BEFORE = 
                 (SELECT to_number(L.L_PRICE_BEFORE)*to_number(PLAN_D.CHECK_QTY) b FROM XSR_XZ_CT_PLAN_L L WHERE L.PLAN_L_ID = PLAN_D.PLAN_L_ID)---不含税金额
           WHERE PLAN_L_ID = PLAN_D.PLAN_L_ID;
          END LOOP;
          END LOOP;
       END IF;
    --如果报量模板类型为 工程报量与发票
    if t_tmp_code = 'XZCTPLAN012' then
      SELECT SYS_GUID() INTO t_uuid FROM DUAL;
    
      --生成报量发票主信息     
      INSERT INTO XSR_XZ_EX_INV_H
        (INV_H_ID, --1
         INV_H_CODE, --2
         INV_H_NAME, --3
         ORG_ID, --4
         DEPT_ID, --5
         EMP_ID, --6
         BG_MONTH, --7
         BG_YEAR, --8
         PRJ_ID, --9
         CNY_CODE, --10
         CNY_RATE, --11
         H_VAL, --12 金额(不含税)
         H_TAX_VAL, --13 税款（原币）
         CNY_VAL, --14
         CNY_TAX_VAL, --15
         ERP_MOD, --16
         IS_SINGLE, --17
         TMP_TYPE, --18
         IS_BUS, --19
         IS_BG_CTRL, --20
         COM_TYPE, --21
         PAY_TYPE, --22
         INV_TYPE, --23
         EX_TMP_ID, --24
         OPERATION_STATUS, --25
         POST_ID, --26
         CREATION_DATE, --27
         CREATED_BY, --28
         AUDIT_STATUS, --29
         AUDIT_STATUS_NAME, --30
         CT_H_ID, --31
         COM_SEC_ID, --32乙方单位
         TAX_ITEM_ID, --33税码
         TAX_RATE) --34税率
        SELECT t_uuid, --1
               'FP-' || P.PLAN_H_CODE, --2
               'FP-' || P.PLAN_H_NAME, --3
               P.ORG_ID, --4
               P.DEPT_ID, --5
               (SELECT U.EMP_ID
                  FROM XIP_PUB_USERS U
                 WHERE U.USER_ID = P.CREATED_BY), --6
               to_char(sysdate, 'yyyy'), --7
               to_char(sysdate, 'mm'), --8
               P.PRJ_ID, --9
               NVL(P.CNY_CODE, 'CNY'), --10
               NVL(P.CNY_RATE, '1'), --11
               (SELECT NVL(SUM(L.L_VAL_BEFORE), 0)
                  FROM XSR_XZ_CT_PLAN_L L
                 WHERE L.PLAN_H_ID = P.PLAN_H_ID), --12 含税金额
               (SELECT NVL(SUM(L.L_VAL), 0) - NVL(SUM(L.L_VAL_BEFORE), 0)
                  FROM XSR_XZ_CT_PLAN_L L
                 WHERE L.PLAN_H_ID = P.PLAN_H_ID), --13 税额                
               (SELECT NVL(SUM(L.L_VAL), 0)
                  FROM XSR_XZ_CT_PLAN_L L
                 WHERE L.PLAN_H_ID = P.PLAN_H_ID), --14 含税金额
               (SELECT NVL(SUM(L.L_VAL), 0) - NVL(SUM(L.L_VAL_BEFORE), 0)
                  FROM XSR_XZ_CT_PLAN_L L
                 WHERE L.PLAN_H_ID = P.PLAN_H_ID), --15 税额
               'NO', --16
               'Y', --17
               'E', --18
               'Y', --19
               'Y', --20
               'V', --21
               'A', --22
               'STD', --23       
               '5f2607c2-91a2-40f3-bf6a-f961330c2c83', --24(标准报量发票模板ID)
               'NOR', --25
               P.POST_ID, --26
               sysdate, --27
               p_user_id, --28
               'E', --29
               '审批通过', --30
               P.CT_H_ID, --31
               (SELECT C.COM_SEC_ID
                  FROM XSR_XZ_CT_H C
                 WHERE C.CT_H_ID = P.CT_H_ID), --32乙方单位
               TAX_ITEM_ID, --33税码
               TAX_RATE --34税率
          FROM XSR_XZ_CT_PLAN_H P
         WHERE P.PLAN_H_ID = p_key_id;
    
      --生成报量发票行信息
      INSERT INTO XSR_XZ_EX_INV_L
        (INV_L_ID, --1
         INV_H_ID, --2
         L_DATE, --3
         L_VAL, --4 不含税金额
         L_AMT, --5
         L_PRICE, --6
         CNY_VAL, --7 折后金额
         L_TAX_VAL, --8 税额
         TAX_ID, --9
         TAX_RATE, --10
         BG_FARE_ID, --11
         ORG_ID, --12
         PRJ_ID, --13
         BG_ITEM_ID, --14
         CNY_CODE, --15
         CNY_RATE, --16
         ACCEPT_LINE_ID, --17 报量行ID
         CT_H_ID, --18
         CT_L_ID, --19
         CT_D_ID, --20
         INV_L_TYPE, --21
         CREATION_DATE, --22
         CREATED_BY, /*,    --23
                                                                 L_VAL_NOTAX,
                                                                 CNY_L_VAL_NOTAX*/
         L_VAL_SUM,
         CNY_L_VAL_SUM)
        SELECT SYS_GUID(), --1
               t_uuid, --2
               sysdate, --3
               L.L_VAL_BEFORE, --4 不含税金额
               L.L_AMOUNT, --5
               L.L_PRICE, --6
               L.L_VAL, --7
               L.l_Val_Tax, --8
               L.TAX_ITEM_ID, --9
               L.TAX_RATE, --10
               L.BG_FARE_ID, --11
               L.ORG_ID, --12
               L.PRJ_ID, --13
               L.BG_ITEM_ID, --14
               NVL(L.CNY_CODE, 'CNY'), --15
               NVL(L.CNY_RATE, '1'), --16
               L.PLAN_L_ID, --17
               L.CT_H_ID, --18
               L.CT_L_ID, --19
               L.CT_D_ID, --20
               'NOR', --21
               sysdate, --22
               p_user_id, /*,        --23
                                                                                                         l.l_val_before,
                                                                                                         l.l_val_before*/
               L.L_VAL,
               L.L_VAL * NVL(L.TAX_RATE, 0)
          FROM XSR_XZ_CT_PLAN_L L
         WHERE L.PLAN_H_ID = p_key_id;
      --生成付款依据
      INSERT INTO XSR_XZ_EX_PAY_SCHEDULE
        (PAY_SCHEDULE_ID, --1
         INV_H_ID, --2
         PAY_DATE, --3
         PAY_VAL, --4
         PAYMENT_NUM, --5
         CREATION_DATE, --6
         CREATED_BY) --7
      VALUES
        (SYS_GUID(), --1
         t_uuid, --2
         sysdate, --3
         (SELECT NVL(SUM(L.L_VAL), 0)
            FROM XSR_XZ_EX_INV_L L
           WHERE L.INV_H_ID = t_uuid), --4
         (SELECT COUNT(1) + 1
            FROM XSR_XZ_EX_PAY_SCHEDULE S
           WHERE S.INV_H_ID = t_uuid), --5
         sysdate, --6
         p_user_id --7
         );
    end if;
    --生成成本归集
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
  END wf_ct_plan_accept;

  /*启动合同收款流程*/
  PROCEDURE wf_ct_rev(p_rev_h_id IN VARCHAR2,
                      flag       OUT NUMBER,
                      msg        OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    v_inv_h_code   varchar2(1000);
    v_inv_h_name   varchar2(1000);
    v_flag         number;
    v_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from xsr_xz_ct_rev_h h
     where h.rev_h_id = p_rev_h_id;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
    /*2.检查单据预算*/
    -- vld_inv(p_inv_h_id,'Y',v_flag,v_msg);
    flag := 1;
    if v_flag = 0 then
      flag := v_flag;
      msg  := v_msg;
    else
      flag := 1;
      xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_CT_REV_H_V',
                                'REV_H_ID',
                                p_rev_h_id,
                                'REV_H_ID',
                                'REV_H_CODE',
                                'ORG_ID',
                                'DEPT_ID',
                                v_flag,
                                v_msg);
      if v_flag = 0 then
        --合成失败--
        flag := v_flag;
        msg  := v_msg;
      else
        flag := 1;
        msg  := v_msg;
      end if;
    end if;
  exception
    when others then
      flag := 0;
      msg  := p_rev_h_id || ':流程启动错误：' || SQLERRM;
  end;
  /*整理发票财务信息
  */
  PROCEDURE vld_trx_fin(p_trx_h_id IN VARCHAR2,
                        p_user_id  in varchar2,
                        flag       OUT NUMBER,
                        msg        OUT VARCHAR2) is
    v_acc_code varchar2(1000);
    v_acc_name varchar2(1000);
    v_flag     number;
    v_msg      varchar2(1000);
  begin
    /*1.更新供应商、地点信息*/
    for ch in (select h.trx_h_id,
                      h.dept_id,
                      h.je_header_id,
                      s.icp_ccid,
                      s.pre_ccid
                 from xsr_xz_ct_trx_h h, xsr_xz_ct_h c, xsr_xz_ba_com_sec s
                where h.ct_h_id = c.ct_h_id
                  and c.com_sec_id = s.com_sec_id
                  and h.trx_h_id = p_trx_h_id) loop
      if (ch.je_header_id is not null) then
        flag := 1;
        msg  := '已入账！';
        return;
      end if;
      if (ch.icp_ccid is null or ch.pre_ccid is null) then
        flag := 0;
        msg  := '客户需要设置往来科目及预收科目！';
        return;
      end if;
    
      update xsr_xz_ct_trx_h h
         set h.ICP_CCID = ch.icp_ccid, h.PRE_CCID = ch.pre_ccid
       where h.trx_h_id = p_trx_h_id;
      commit;
    end loop;
    flag := 1;
    msg  := 'ok';
  end;
  --导入GL--发票--
  PROCEDURE ins_trx_gl_int(p_trx_h_id IN VARCHAR2,
                           p_user_id  IN VARCHAR2,
                           p_gl_date  IN date) is
    v_server_id     VARCHAR2(50);
    v_sob_id        NUMBER;
    v_db_link       VARCHAR2(50);
    v_org_id        VARCHAR2(50);
    v_resp_id       NUMBER;
    v_org_code      VARCHAR2(500);
    v_gl_date       DATE;
    v_dr_ccid       NUMBER;
    v_req_id        NUMBER;
    v_je_header_id  NUMBER;
    v_cnt           NUMBER;
    v_req_status    VARCHAR2(10);
    v_period_name   VARCHAR2(50);
    v_imp_gl_src    VARCHAR2(100);
    v_imp_gl_ctg    VARCHAR2(100);
    v_imp_gl_src_id VARCHAR2(100);
    v_ref10         VARCHAR2(1000);
    v_int_id        varchar2(36);
    v_flag          number;
    v_msg           varchar2(100);
    v_ebs_user_id   number;
  begin
    v_ebs_user_id := xsr_xz_ba_ebs_d_pkg.get_ebs_user_id(p_user_id);
    FOR c_h IN (SELECT h.*
                  FROM xsr_xz_ct_trx_h h
                 WHERE trx_h_id = p_trx_h_id
                   and h.je_header_id is null) LOOP
      SELECT oa.server_id,
             oa.fmis_sob_id,
             bs.db_lnk,
             oa.fmis_org_id,
             oa.resp_gl_id,
             org.org_code,
             bs.imp_gl_src,
             bs.imp_gl_ctg,
             bs.imp_gl_src_id
        INTO v_server_id,
             v_sob_id,
             v_db_link,
             v_org_id,
             v_resp_id,
             v_org_code,
             v_imp_gl_src,
             v_imp_gl_ctg,
             v_imp_gl_src_id
        FROM xsr_xz_ba_org_all oa, xsr_xz_ba_server bs, xip_pub_orgs org
       WHERE bs.server_id = oa.server_id
         and oa.org_id = org.org_id
         AND oa.org_id = c_h.org_id;
      ---更新请求ID--
      begin
        select request_id, accounting_date
          into v_req_id, v_gl_date
          from xsr_xz_ba_gl_interface
         where src_id = c_h.trx_h_id
           and rownum < 2;
        update xsr_xz_ct_trx_h
           set request_id = v_req_id, gl_date = v_gl_date
         where trx_h_id = c_h.trx_h_id;
      exception
        when others then
          null;
      end;
      IF v_req_id IS NOT NULL and c_h.je_header_id is null THEN
        /*1.如果有请求号，等待并检查导入状态*/
        v_req_status := xsr_xz_ba_ebs_d_pkg.get_reqeust_status(v_db_link,
                                                               v_req_id);
        IF v_req_status IN ('P', 'R') THEN
          xsr_xz_ba_ebs_p_pkg.wait_for_request(v_req_id,
                                               v_db_link,
                                               v_flag,
                                               v_msg);
        END IF;
      END IF;
      /*2.更新单据导入状态*/
      v_je_header_id := xsr_xz_ba_ebs_p_pkg.get_ebs_je_header_id(v_db_link,
                                                                 c_h.trx_h_id);
      if v_je_header_id is not null then
        update xsr_xz_ct_trx_h h
           set h.je_header_id = v_je_header_id
         where h.trx_h_id = c_h.trx_h_id;
        update xsr_xz_ba_gl_interface h
           set h.je_header_id = v_je_header_id
         where h.src_id = c_h.trx_h_id
           and h.src_table = 'xsr_xz_ct_trx_h';
        insert into xsr_xz_ba_imp_log
          (doc_id, user_id, log_msg, creation_date)
        values
          ('-1',
           p_user_id,
           '单据号:' || c_h.trx_h_code || ',已导入!',
           sysdate);
        commit;
        return;
      end if;
      v_gl_date := p_gl_date;
      /*3.写入本地接口*/
      DELETE FROM xsr_xz_ba_gl_interface a WHERE a.src_id = c_h.trx_h_id;
      /*3.1写入借方分录*/
      v_int_id := sys_guid();
      INSERT INTO xsr_xz_ba_gl_interface
        (src_batch_id,
         server_id,
         src_id,
         src_mod,
         src_table,
         src_fld,
         ou_id,
         gl_int_id,
         status,
         ledger_id,
         accounting_date,
         currency_code,
         date_created,
         created_by,
         actual_flag,
         user_je_category_name,
         user_je_source_name,
         code_combination_id, --
         entered_dr,
         entered_cr,
         --period_name,
         reference1,
         reference4,
         reference5,
         reference10,
         reference30 /*,
                                                                               --reference29,
                                                                               group_id */)
      VALUES
        (c_h.batch_name,
         v_server_id,
         c_h.trx_h_id,
         'CT',
         'xsr_xz_ct_trx_h',
         'trx_h_id',
         c_h.org_id,
         v_int_id, --c_h.inv_h_id,
         'NEW',
         v_sob_id,
         v_gl_date, --trunc(sysdate),
         'CNY', --'CNY'币种代码
         SYSDATE,
         v_ebs_user_id,
         'A',
         v_imp_gl_src,
         v_imp_gl_ctg, --'XL费用中心',
         c_h.icp_ccid, --往来科目--
         c_h.trx_amount, --借方金额
         0, --贷方金额
         --v_gl_period,
         c_h.batch_name, --批名称--
         c_h.trx_h_code || '|', --凭证名称--
         c_h.trx_h_code || '|' || c_h.trx_h_name, --凭证摘要--
         c_h.trx_h_name, --v_ref10,--行摘要--
         c_h.trx_h_id /*,
                                                                               --c_1.cash_code,
                                                                               c_h.batch_name--p_doc_id -批ID--*/);
      /*3.2写入贷方分录--TRX_GL--*/
      FOR c_l IN (SELECT il.*
                    FROM xsr_xz_ct_trx_gl il
                   WHERE il.trx_h_id = c_h.trx_h_id) LOOP
        v_int_id := sys_guid();
        INSERT INTO xsr_xz_ba_gl_interface
          (src_batch_id,
           server_id,
           src_id,
           src_mod,
           src_table,
           src_fld,
           ou_id,
           gl_int_id,
           status,
           ledger_id,
           accounting_date,
           currency_code,
           date_created,
           created_by,
           actual_flag,
           user_je_category_name,
           user_je_source_name,
           code_combination_id, --
           entered_dr,
           entered_cr,
           --period_name,
           reference1,
           reference4,
           reference5,
           reference10,
           reference30 /*,
                                                                                           --reference29,
                                                                                           group_id */)
        VALUES
          (c_h.batch_name,
           v_server_id,
           c_h.trx_h_id,
           'CT',
           'xsr_xz_ct_trx_h',
           'trx_h_id',
           c_h.org_id,
           v_int_id, --c_h.inv_h_id,
           'NEW',
           v_sob_id,
           v_gl_date, --trunc(sysdate),
           'CNY', --'CNY'币种代码
           SYSDATE,
           v_ebs_user_id,
           'A',
           v_imp_gl_src,
           v_imp_gl_ctg, --'XL费用中心',
           c_l.gl_ccid, --否则费用科目--
           0, --借方金额
           c_l.gl_val, --贷方金额
           --v_gl_period,
           c_h.batch_name, --批名称--
           c_h.trx_h_code || '|', --凭证名称--
           c_h.trx_h_code || '|' || c_h.trx_h_name, --凭证摘要--
           c_l.description, --v_ref10,--行摘要--
           c_h.trx_h_id /*,
                                                                                           --c_1.cash_code,
                                                                                           c_h.batch_name--p_doc_id -批ID--*/);
      END LOOP;
      COMMIT;
      v_flag := 1;
      v_msg  := '单据' || c_h.trx_h_code || '导入本地接口表！';
      insert into xsr_xz_ba_imp_log
        (doc_id, user_id, log_msg, creation_date)
      values
        (c_h.trx_h_id, p_user_id, v_msg, sysdate);
      commit;
    END LOOP;
  end;
  --导入GL--核销--
  PROCEDURE ins_trx_rev_gl_int(p_trx_rev_id IN VARCHAR2,
                               p_user_id    IN VARCHAR2,
                               p_gl_date    IN date) is
    v_server_id     VARCHAR2(50);
    v_sob_id        NUMBER;
    v_db_link       VARCHAR2(50);
    v_org_id        VARCHAR2(50);
    v_resp_id       NUMBER;
    v_org_code      VARCHAR2(500);
    v_gl_date       DATE;
    v_dr_ccid       NUMBER;
    v_req_id        NUMBER;
    v_je_header_id  NUMBER;
    v_cnt           NUMBER;
    v_req_status    VARCHAR2(10);
    v_period_name   VARCHAR2(50);
    v_imp_gl_src    VARCHAR2(100);
    v_imp_gl_ctg    VARCHAR2(100);
    v_imp_gl_src_id VARCHAR2(100);
    v_ref10         VARCHAR2(1000);
    v_int_id        varchar2(36);
    v_flag          number;
    v_msg           varchar2(100);
    v_ebs_user_id   number;
  begin
    v_ebs_user_id := xsr_xz_ba_ebs_d_pkg.get_ebs_user_id(p_user_id);
    FOR c_h IN (SELECT h.*,
                       a.org_id,
                       a.trx_h_code,
                       a.trx_h_name,
                       s.icp_ccid,
                       s.pre_ccid
                  FROM xsr_xz_ct_trx_rev h,
                       xsr_xz_ct_trx_h   a,
                       xsr_xz_ct_h       b,
                       xsr_xz_ba_com_sec s
                 WHERE h.trx_rev_id = p_trx_rev_id
                   and h.trx_h_id = a.trx_h_id
                   and a.ct_h_id = b.ct_h_id
                   and b.com_sec_id = s.com_sec_id
                   and h.je_header_id is null) LOOP
    
      if c_h.icp_ccid is null or c_h.pre_ccid is null then
        insert into xsr_xz_ba_imp_log
          (doc_id, user_id, log_msg, creation_date)
        values
          ('-1',
           p_user_id,
           '单据号:' || c_h.trx_h_code || ',对应客户需要设置应收及预收科目!',
           sysdate);
        commit;
        return;
      end if;
      SELECT oa.server_id,
             oa.fmis_sob_id,
             bs.db_lnk,
             oa.fmis_org_id,
             oa.resp_gl_id,
             org.org_code,
             bs.imp_gl_src,
             bs.imp_gl_ctg,
             bs.imp_gl_src_id
        INTO v_server_id,
             v_sob_id,
             v_db_link,
             v_org_id,
             v_resp_id,
             v_org_code,
             v_imp_gl_src,
             v_imp_gl_ctg,
             v_imp_gl_src_id
        FROM xsr_xz_ba_org_all oa, xsr_xz_ba_server bs, xip_pub_orgs org
       WHERE bs.server_id = oa.server_id
         and oa.org_id = org.org_id
         AND oa.org_id = c_h.org_id;
      ---更新请求ID--
      begin
        select request_id, accounting_date
          into v_req_id, v_gl_date
          from xsr_xz_ba_gl_interface
         where src_id = c_h.trx_rev_id
           and rownum < 2;
        update xsr_xz_ct_trx_rev
           set request_id = v_req_id, gl_date = v_gl_date
         where trx_rev_id = c_h.trx_rev_id;
      exception
        when others then
          null;
      end;
      IF v_req_id IS NOT NULL and c_h.je_header_id is null THEN
        /*1.如果有请求号，等待并检查导入状态*/
        v_req_status := xsr_xz_ba_ebs_d_pkg.get_reqeust_status(v_db_link,
                                                               v_req_id);
        IF v_req_status IN ('P', 'R') THEN
          xsr_xz_ba_ebs_p_pkg.wait_for_request(v_req_id,
                                               v_db_link,
                                               v_flag,
                                               v_msg);
        END IF;
      END IF;
      /*2.更新单据导入状态*/
      v_je_header_id := xsr_xz_ba_ebs_p_pkg.get_ebs_je_header_id(v_db_link,
                                                                 c_h.trx_rev_id);
      if v_je_header_id is not null then
        update xsr_xz_ct_trx_rev h
           set h.je_header_id = v_je_header_id
         where h.trx_rev_id = c_h.trx_rev_id;
        update xsr_xz_ba_gl_interface h
           set h.je_header_id = v_je_header_id
         where h.src_id = c_h.trx_rev_id
           and h.src_table = 'xsr_xz_ct_trx_rev';
        insert into xsr_xz_ba_imp_log
          (doc_id, user_id, log_msg, creation_date)
        values
          ('-1',
           p_user_id,
           '单据号:' || c_h.trx_h_code || ',已导入!',
           sysdate);
        commit;
        return;
      end if;
      v_gl_date := p_gl_date;
      /*3.写入本地接口*/
      DELETE FROM xsr_xz_ba_gl_interface a WHERE a.src_id = c_h.trx_rev_id;
      /*3.1写入借方分录--预收科目*/
      v_int_id := sys_guid();
      INSERT INTO xsr_xz_ba_gl_interface
        (src_batch_id,
         server_id,
         src_id,
         src_mod,
         src_table,
         src_fld,
         ou_id,
         gl_int_id,
         status,
         ledger_id,
         accounting_date,
         currency_code,
         date_created,
         created_by,
         actual_flag,
         user_je_category_name,
         user_je_source_name,
         code_combination_id, --
         entered_dr,
         entered_cr,
         --period_name,
         reference1,
         reference4,
         reference5,
         reference10,
         reference30 /*,
                                                                               --reference29,
                                                                               group_id */)
      VALUES
        (c_h.batch_name,
         v_server_id,
         c_h.trx_rev_id,
         'CT',
         'xsr_xz_ct_trx_rev',
         'trx_rev_id',
         c_h.org_id,
         v_int_id, --c_h.inv_h_id,
         'NEW',
         v_sob_id,
         v_gl_date, --trunc(sysdate),
         'CNY', --'CNY'币种代码
         SYSDATE,
         v_ebs_user_id,
         'A',
         v_imp_gl_src,
         v_imp_gl_ctg, --'XL费用中心',
         c_h.pre_ccid, --往来科目--
         c_h.trx_rev_val, --借方金额
         0, --贷方金额
         --v_gl_period,
         c_h.batch_name, --批名称--
         c_h.trx_h_code || '|', --凭证名称--
         '核销:' || c_h.trx_h_code || '|' || c_h.trx_h_name, --凭证摘要--
         '核销:' || c_h.trx_h_name, --v_ref10,--行摘要--
         c_h.trx_rev_id /*,
                                                                               --c_1.cash_code,
                                                                               c_h.batch_name--p_doc_id -批ID--*/);
      /*3.2写入贷方分录--TRX_GL--*/
      v_int_id := sys_guid();
      INSERT INTO xsr_xz_ba_gl_interface
        (src_batch_id,
         server_id,
         src_id,
         src_mod,
         src_table,
         src_fld,
         ou_id,
         gl_int_id,
         status,
         ledger_id,
         accounting_date,
         currency_code,
         date_created,
         created_by,
         actual_flag,
         user_je_category_name,
         user_je_source_name,
         code_combination_id, --
         entered_dr,
         entered_cr,
         --period_name,
         reference1,
         reference4,
         reference5,
         reference10,
         reference30 /*,
                                                                               --reference29,
                                                                               group_id */)
      VALUES
        (c_h.batch_name,
         v_server_id,
         c_h.trx_rev_id,
         'CT',
         'xsr_xz_ct_trx_rev',
         'trx_rev_id',
         c_h.org_id,
         v_int_id, --c_h.inv_h_id,
         'NEW',
         v_sob_id,
         v_gl_date, --trunc(sysdate),
         'CNY', --'CNY'币种代码
         SYSDATE,
         v_ebs_user_id,
         'A',
         v_imp_gl_src,
         v_imp_gl_ctg, --'XL费用中心',
         c_h.icp_ccid, --往来科目--
         0, --借方金额
         c_h.trx_rev_val, --贷方金额
         --v_gl_period,
         c_h.batch_name, --批名称--
         c_h.trx_h_code || '|', --凭证名称--
         '核销:' || c_h.trx_h_code || '|' || c_h.trx_h_name, --凭证摘要--
         '核销:' || c_h.trx_h_name, --v_ref10,--行摘要--
         c_h.trx_rev_id /*,
                                                                               --c_1.cash_code,
                                                                               c_h.batch_name--p_doc_id -批ID--*/);
      COMMIT;
      v_flag := 1;
      v_msg  := '单据' || c_h.trx_h_code || '导入本地接口表！';
      insert into xsr_xz_ba_imp_log
        (doc_id, user_id, log_msg, creation_date)
      values
        (c_h.trx_rev_id, p_user_id, v_msg, sysdate);
      commit;
    END LOOP;
  end;
  /*整理收款财务信息
  */
  PROCEDURE vld_rev_fin(p_rev_h_id IN VARCHAR2,
                        p_user_id  in varchar2,
                        flag       OUT NUMBER,
                        msg        OUT VARCHAR2) is
    v_acc_code varchar2(1000);
    v_acc_name varchar2(1000);
    v_flag     number;
    v_msg      varchar2(1000);
  begin
    /*1.更新供应商、地点信息*/
    for ch in (select h.rev_h_id,
                      h.dept_id,
                      h.je_header_id,
                      s.icp_ccid,
                      s.pre_ccid,
                      d.bank_ccid
                 from xsr_xz_ct_rev_h   h,
                      xsr_xz_ct_h       c,
                      xsr_xz_ba_com_sec s,
                      xsr_xz_ba_bank    d
                where h.ct_h_id = c.ct_h_id
                  and c.com_sec_id = s.com_sec_id
                  and h.rev_h_id = p_rev_h_id
                  and h.org_bank_id = d.org_bank_id(+)) loop
      if (ch.je_header_id is not null) then
        flag := 1;
        msg  := '已入账！';
        return;
      end if;
      if (ch.icp_ccid is null or ch.pre_ccid is null) then
        flag := 0;
        msg  := '客户需要设置往来科目及预收科目！';
        return;
      end if;
      if (ch.bank_ccid is null) then
        flag := 0;
        msg  := '需要设置银行及银行科目！';
        return;
      end if;
      update xsr_xz_ct_rev_h h
         set h.ICP_CCID  = ch.icp_ccid,
             h.PRE_CCID  = ch.pre_ccid,
             h.bank_ccid = ch.bank_ccid
       where h.rev_h_id = p_rev_h_id;
      commit;
    end loop;
    flag := 1;
    msg  := 'ok';
  end;
  --导入GL--收款--
  PROCEDURE ins_rev_gl_int(p_rev_h_id IN VARCHAR2,
                           p_user_id  IN VARCHAR2,
                           p_gl_date  IN date) is
    v_server_id     VARCHAR2(50);
    v_sob_id        NUMBER;
    v_db_link       VARCHAR2(50);
    v_org_id        VARCHAR2(50);
    v_resp_id       NUMBER;
    v_org_code      VARCHAR2(500);
    v_gl_date       DATE;
    v_dr_ccid       NUMBER;
    v_req_id        NUMBER;
    v_je_header_id  NUMBER;
    v_cnt           NUMBER;
    v_req_status    VARCHAR2(10);
    v_period_name   VARCHAR2(50);
    v_imp_gl_src    VARCHAR2(100);
    v_imp_gl_ctg    VARCHAR2(100);
    v_imp_gl_src_id VARCHAR2(100);
    v_ref10         VARCHAR2(1000);
    v_int_id        varchar2(36);
    v_flag          number;
    v_msg           varchar2(100);
    v_ebs_user_id   number;
  begin
    v_ebs_user_id := xsr_xz_ba_ebs_d_pkg.get_ebs_user_id(p_user_id);
    FOR c_h IN (SELECT h.*
                  FROM xsr_xz_ct_rev_h h
                 WHERE h.rev_h_id = p_rev_h_id
                   and h.je_header_id is null) LOOP
      SELECT oa.server_id,
             oa.fmis_sob_id,
             bs.db_lnk,
             oa.fmis_org_id,
             oa.resp_gl_id,
             org.org_code,
             bs.imp_gl_src,
             bs.imp_gl_ctg,
             bs.imp_gl_src_id
        INTO v_server_id,
             v_sob_id,
             v_db_link,
             v_org_id,
             v_resp_id,
             v_org_code,
             v_imp_gl_src,
             v_imp_gl_ctg,
             v_imp_gl_src_id
        FROM xsr_xz_ba_org_all oa, xsr_xz_ba_server bs, xip_pub_orgs org
       WHERE bs.server_id = oa.server_id
         and oa.org_id = org.org_id
         AND oa.org_id = c_h.org_id;
      ---更新请求ID--
      begin
        select request_id, accounting_date
          into v_req_id, v_gl_date
          from xsr_xz_ba_gl_interface
         where src_id = c_h.rev_h_id
           and rownum < 2;
        update xsr_xz_ct_rev_h
           set request_id = v_req_id, gl_date = v_gl_date
         where rev_h_id = c_h.rev_h_id;
      exception
        when others then
          null;
      end;
      IF v_req_id IS NOT NULL and c_h.je_header_id is null THEN
        /*1.如果有请求号，等待并检查导入状态*/
        v_req_status := xsr_xz_ba_ebs_d_pkg.get_reqeust_status(v_db_link,
                                                               v_req_id);
        IF v_req_status IN ('P', 'R') THEN
          xsr_xz_ba_ebs_p_pkg.wait_for_request(v_req_id,
                                               v_db_link,
                                               v_flag,
                                               v_msg);
        END IF;
      END IF;
      /*2.更新单据导入状态*/
      v_je_header_id := xsr_xz_ba_ebs_p_pkg.get_ebs_je_header_id(v_db_link,
                                                                 c_h.rev_h_id);
      if v_je_header_id is not null then
        update xsr_xz_ct_rev_h h
           set h.je_header_id = v_je_header_id
         where h.rev_h_id = c_h.rev_h_id;
        update xsr_xz_ba_gl_interface h
           set h.je_header_id = v_je_header_id
         where h.src_id = c_h.rev_h_id
           and h.src_table = 'xsr_xz_ct_rev_h';
        insert into xsr_xz_ba_imp_log
          (doc_id, user_id, log_msg, creation_date)
        values
          ('-1',
           p_user_id,
           '单据号:' || c_h.rev_h_code || ',已导入!',
           sysdate);
        commit;
        return;
      end if;
      v_gl_date := p_gl_date;
      /*3.写入本地接口*/
      DELETE FROM xsr_xz_ba_gl_interface a WHERE a.src_id = c_h.rev_h_id;
      /*3.1写入借方分录--预收科目*/
      v_int_id := sys_guid();
      INSERT INTO xsr_xz_ba_gl_interface
        (src_batch_id,
         server_id,
         src_id,
         src_mod,
         src_table,
         src_fld,
         ou_id,
         gl_int_id,
         status,
         ledger_id,
         accounting_date,
         currency_code,
         date_created,
         created_by,
         actual_flag,
         user_je_category_name,
         user_je_source_name,
         code_combination_id, --
         entered_dr,
         entered_cr,
         --period_name,
         reference1,
         reference4,
         reference5,
         reference10,
         reference30,
         reference29 /*,
                                                                               group_id */)
      VALUES
        (c_h.batch_name,
         v_server_id,
         c_h.rev_h_id,
         'CT',
         'xsr_xz_ct_rev_h',
         'rev_h_id',
         c_h.org_id,
         v_int_id, --c_h.inv_h_id,
         'NEW',
         v_sob_id,
         v_gl_date, --trunc(sysdate),
         'CNY', --'CNY'币种代码
         SYSDATE,
         v_ebs_user_id,
         'A',
         v_imp_gl_src,
         v_imp_gl_ctg, --'XL费用中心',
         c_h.bank_ccid, --往来科目--
         c_h.rev_val, --借方金额
         0, --贷方金额
         --v_gl_period,
         c_h.batch_name, --批名称--
         c_h.rev_h_code || '|', --凭证名称--
         c_h.rev_h_code || '|' || c_h.rev_h_name, --凭证摘要--
         c_h.rev_h_name, --v_ref10,--行摘要--
         c_h.rev_h_id,
         c_h.cash_code /*,
                                                                               c_h.batch_name--p_doc_id -批ID--*/);
      /*3.2写入贷方分录--TRX_GL--*/
      v_int_id := sys_guid();
      INSERT INTO xsr_xz_ba_gl_interface
        (src_batch_id,
         server_id,
         src_id,
         src_mod,
         src_table,
         src_fld,
         ou_id,
         gl_int_id,
         status,
         ledger_id,
         accounting_date,
         currency_code,
         date_created,
         created_by,
         actual_flag,
         user_je_category_name,
         user_je_source_name,
         code_combination_id, --
         entered_dr,
         entered_cr,
         --period_name,
         reference1,
         reference4,
         reference5,
         reference10,
         reference30,
         reference29 /*,
                                                                               group_id */)
      VALUES
        (c_h.batch_name,
         v_server_id,
         c_h.rev_h_id,
         'CT',
         'xsr_xz_ct_rev_h',
         'rev_h_id',
         c_h.org_id,
         v_int_id, --c_h.inv_h_id,
         'NEW',
         v_sob_id,
         v_gl_date, --trunc(sysdate),
         'CNY', --'CNY'币种代码
         SYSDATE,
         v_ebs_user_id,
         'A',
         v_imp_gl_src,
         v_imp_gl_ctg, --'XL费用中心',
         c_h.pre_ccid, --预收科目--
         0, --借方金额
         c_h.rev_val, --贷方金额
         --v_gl_period,
         c_h.batch_name, --批名称--
         c_h.rev_h_code || '|', --凭证名称--
         c_h.rev_h_code || '|' || c_h.rev_h_name, --凭证摘要--
         c_h.rev_h_name, --v_ref10,--行摘要--
         c_h.rev_h_id,
         c_h.cash_code /*,
                                                                               c_h.batch_name--p_doc_id -批ID--*/);
      COMMIT;
      v_flag := 1;
      v_msg  := '单据' || c_h.rev_h_code || '导入本地接口表！';
      insert into xsr_xz_ba_imp_log
        (doc_id, user_id, log_msg, creation_date)
      values
        (c_h.rev_h_id, p_user_id, v_msg, sysdate);
      commit;
    END LOOP;
  end;
  /*合同审批通过写入历史表
   add by yaozhp
  */
  PROCEDURE wf_ct_h_end(p_ins_code          in VARCHAR2,
                        p_key_id            in VARCHAR2,
                        p_audit_status      in VARCHAR2,
                        p_audit_status_name in VARCHAR2,
                        p_user_id           in VARCHAR2,
                        p_return_msg        out clob)
  
   is
    t_uuid  varchar2(36);
    p_uuid  varchar2(36);
    v_flag  number;
    v_msg   varchar2(1000);
    version number := 0;
    --   P_RAISE EXCEPTION;
    --  v_count     number;
    --  P_SQLCODE   varchar2(2000);
    --  P_SQLERRM   varchar2(2000);
    --  P_MSG       varchar2(2000);
  
    CURSOR CT_L_L IS
      SELECT * FROM XSR_XZ_CT_L L WHERE L.CT_H_ID = p_key_id;
    CURSOR CT_D_D IS
      SELECT * FROM XSR_XZ_CT_D D WHERE D.CT_H_ID = p_key_id;
  begin
    /*获取版本号*/
    SELECT NVL(MAX(CUR_VERSION_ID), 0) + 1
      INTO version
      FROM XSR_XZ_CT_H_HIS
     WHERE CT_H_ID = p_key_id;
    /*1.获取主表数据,写入历史主表*/
  
    INSERT INTO XSR_XZ_CT_H_HIS
      (CT_H_HIS_ID, --历史表合同主ID
       CT_H_ID, --主键
       ORG_ID, --组织ID
       PRJ_ID, --项目ID
       TYPE_CLS,
       TYPE_H_ID, --合同模板
       CT_H_CODE, --合同编码
       DEPT_ID, --部门
       CT_H_NAME, --合同名称
       TAX_ITEM_ID, --税码
       COM_SEC_ID, --合同乙方
       TAX_RATE, --税率
       PROVIDE_COM_ID, --供货商
       ENDORSE_DATE, --签订日期
       PRUDUCT_COM_ID, --制造商
       IS_ADD, --补充合同
       PREPAY_RATE, --预付款比例
       PLEDGE_RATE, --质保金比例
       SUBSCRIBERA, --甲方签字人
       OPERATORA, --甲方经办人
       SUBSCRIBERB, --乙方签字人
       OPERATORB, --乙方经办人
       COMMENTS, --备注
       CHANGE_COMMENTS, --变更说明
       CHANGE_MODE, --变更类型
       IS_DEDUCT, --是否抵扣
       MAIN_CT_ID, --主合同编码
       TYPE_D_ID, --明细类型
       CT_PAY_TYPE, --付款方式
       AUDIT_STATUS, --审批状态
       AUDIT_STATUS_NAME, --审批流状态
       CUR_VERSION_ID, --版本
       CREATION_DATE,
       CREATED_BY,
       LAST_UPDATE_DATE,
       LAST_UPDATED_BY,
       CT_MONEY,
       CHANGE_DATE --变更日期      
       )
      SELECT SYS_GUID(),
             CT_H_ID, --主键
             ORG_ID, --组织ID
             PRJ_ID, --项目ID
             TYPE_CLS,
             TYPE_H_ID, --合同模板
             CT_H_CODE, --合同编码
             DEPT_ID, --部门
             CT_H_NAME, --合同名称
             TAX_ITEM_ID, --税码
             COM_SEC_ID, --合同乙方
             TAX_RATE, --税率
             PROVIDE_COM_ID, --供货商
             ENDORSE_DATE, --签订日期
             PRUDUCT_COM_ID, --制造商
             IS_ADD, --补充合同
             PREPAY_RATE, --预付款比例
             PLEDGE_RATE, --质保金比例
             SUBSCRIBERA, --甲方签字人
             OPERATORA, --甲方经办人
             SUBSCRIBERB, --乙方签字人
             OPERATORB, --乙方经办人
             COMMENTS, --备注
             CHANGE_COMMENTS, --变更说明
             CHANGE_MODE, --变更类型
             IS_DEDUCT, --是否抵扣
             MAIN_CT_ID, --主合同编码
             TYPE_D_ID, --明细类型
             CT_PAY_TYPE, --付款方式
             'E', --审批状态
             '审批通过', --审批流状态
             version, --历史版本
             SYSDATE,
             CREATED_BY,
             LAST_UPDATE_DATE,
             LAST_UPDATED_BY,
             CT_MONEY,
             CHANGE_DATE --变更日期
        FROM XSR_XZ_CT_H H
       WHERE H.CT_H_ID = p_key_id;
  
    /*2、循环行表数据，写入历史表*/
    FOR CT_L IN CT_L_L LOOP
      SELECT SYS_GUID() INTO t_uuid FROM DUAL;
      INSERT INTO XSR_XZ_CT_L_HIS
        (CT_L_HIS_ID, --历史行表ID
         CT_L_ID, --主键id
         CT_H_ID, --合同id
         ORG_ID,
         PRJ_ID,
         DEPT_ID,
         CT_STRU_ID, --合同结构id
         TYPE_L_ID, --行类型
         L_CODE, --行编码
         L_NAME, --名称
         DIM_CODE, --单位
         AMOUNT, --数量
         PRICE_BEFORE, --税前单价
         PRICE, --税后单价
         MONEY_BEFORE, --税前金额
         MONEY, --税后金额
         TAX_MONEY, --税额
         CNY_MONEY, --折后金额
         TAX_ID, --税码
         TAX_RATE, --税率
         CNY_RATE, --汇率
         CNY_CODE, --币种
         IS_OPEN, --开口合同
         DATA_ID, --物资编码ID
         TSK_ID,
         BG_FARE_ID,
         BG_ITEM_ID,
         DESCRIPTION,
         S_DATE,
         E_DATE,
         CUR_VERSION_ID,
         CREATION_DATE,
         CREATED_BY)
      VALUES
        (t_uuid,
         CT_L.CT_L_ID,
         CT_L.CT_H_ID,
         CT_L.ORG_ID,
         CT_L.PRJ_ID,
         CT_L.DEPT_ID,
         CT_L.CT_STRU_ID,
         CT_L.TYPE_L_ID,
         CT_L.L_CODE,
         CT_L.L_NAME,
         CT_L.DIM_CODE,
         CT_L.AMOUNT,
         CT_L.PRICE_BEFORE,
         CT_L.PRICE,
         CT_L.MONEY_BEFORE,
         CT_L.MONEY,
         CT_L.TAX_MONEY,
         CT_L.CNY_MONEY,
         CT_L.TAX_ID,
         CT_L.TAX_RATE,
         CT_L.CNY_RATE,
         CT_L.CNY_CODE,
         CT_L.IS_OPEN,
         CT_L.DATA_ID,
         CT_L.TSK_ID,
         CT_L.BG_FARE_ID,
         CT_L.BG_ITEM_ID,
         CT_L.DESCRIPTION,
         CT_L.S_DATE,
         CT_L.E_DATE,
         version,
         SYSDATE,
         CT_L.CREATED_BY);
    END LOOP;
    /*3、循环发运行表数据，写入历史表*/
    FOR CT_D IN CT_D_D LOOP
      SELECT SYS_GUID() INTO p_uuid FROM DUAL;
      INSERT INTO XSR_XZ_CT_D_HIS
        (CT_D_HIS_ID, --历史行表ID
         CT_D_ID, --发运行主键ID
         CT_L_ID, --合同行主ID
         CT_H_ID, --合同ID
         ORG_ID,
         PRJ_ID,
         DEPT_ID,
         TYPE_L_ID, --行类型
         L_NAME, --名称
         DIM_CODE, --单位
         DATA_ID,
         AMOUNT, --数量
         PRICE, --税后单价
         MONEY, --税后金额
         TAX_MONEY, --税额
         CNY_MONEY, --折后金额
         TAX_ID, --税码
         TAX_RATE, --税率
         CNY_RATE, --汇率
         CNY_CODE, --币种
         TSK_ID,
         BG_FARE_ID,
         BG_ITEM_ID,
         DESCRIPTION,
         CREATION_DATE,
         CREATED_BY)
      VALUES
        (p_uuid,
         CT_D.CT_D_ID,
         CT_D.CT_L_ID,
         CT_D.CT_H_ID,
         CT_D.ORG_ID,
         CT_D.PRJ_ID,
         CT_D.DEPT_ID,
         CT_D.TYPE_L_ID,
         CT_D.L_NAME,
         CT_D.DIM_CODE,
         CT_D.DATA_ID,
         CT_D.AMOUNT,
         CT_D.PRICE,
         CT_D.MONEY,
         CT_D.TAX_MONEY,
         CT_D.CNY_MONEY,
         CT_D.TAX_ID,
         CT_D.TAX_RATE,
         CT_D.CNY_RATE,
         CT_D.CNY_CODE,
         CT_D.TSK_ID,
         CT_D.BG_FARE_ID,
         CT_D.BG_ITEM_ID,
         CT_D.DESCRIPTION,
         SYSDATE,
         CT_D.CREATED_BY);
    END LOOP;
    commit;
    p_return_msg := '<result><flag>0</flag><msg>ok!</msg></result>';
  END wf_ct_h_end;

  /*启动合同变更审批流程
  by yzh
  */
  PROCEDURE wf_ct_change(P_CT_H_ID IN VARCHAR2,
                         R_FLAG    OUT NUMBER,
                         R_MSG     OUT VARCHAR2) is
    v_audit_status varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from xsr_xz_ct_h h
     where h.ct_h_id = P_CT_H_ID;
    if v_audit_status not in ('CA', 'CD', 'CR') then
      R_FLAG := 0;
      R_MSG  := '只有重新起草、变更撤回、变更驳回的单据才能启动流程！';
      return;
    end if;
/*    xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_CT_H',
                              'CT_H_ID',
                              P_CT_H_ID,
                              'CT_H_ID',
                              'CT_H_CODE',
                              'ORG_ID',
                              'DEPT_ID',
                              R_FLAG,
                              R_MSG);*/
         xsr_xz_ba_pkg.gen_wf_para_test('XSR_XZ_CT_H_V',
                              'CT_H_ID',
                              P_CT_H_ID,
                              'CT_H_ID',
                              'CT_H_CODE',
                              'ORG_ID',
                              'DEPT_ID',
                              'CT_CHANGE_MONEY',
                              'CT_MONEY',
                              '',
                              '',
                              '',
                              '',
                              R_FLAG,
                              R_MSG);
  
  exception
    when others then
      R_FLAG := 0;
      R_MSG  := P_CT_H_ID || ':流程启动错误：' || SQLERRM;
  end;

  PROCEDURE wf_ct_change_qd_accept(p_ins_code          in VARCHAR2,
                                   p_key_id            in VARCHAR2,
                                   p_audit_status      in VARCHAR2,
                                   p_audit_status_name in VARCHAR2,
                                   p_user_id           in VARCHAR2,
                                   p_return_msg        out clob) IS
  BEGIN
    p_return_msg := '<result><flag>33333</flag><msg>ok!</msg></result>';
  END;
  /*合同签订阶段变更管理*/
  PROCEDURE wf_ct_change_qd(P_CONTRACT_ID IN VARCHAR2,
                            flag          OUT NUMBER,
                            msg           OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    v_inv_h_code   varchar2(1000);
    v_inv_h_name   varchar2(1000);
    v_flag         number;
    v_msg          varchar2(1000);
    h_flag         number;
    B_FLAG         varchar2(2);
    h_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from Xsr_Xz_Ct_Change_qd h
     where h.contract_id = P_CONTRACT_ID;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
  
    /*2.检查单据预算*/
    -- vld_inv(p_inv_h_id,'Y',v_flag,v_msg);
    flag := 1;
    if v_flag = 0 then
      flag := v_flag;
      msg  := v_msg;
    else
      flag := 1;
      xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_CT_CHANGE_QD',
                                'contract_id',
                                P_CONTRACT_ID,
                                'CONTRACT_ID',
                                'CONTRACT_ID',
                                'ORG_ID',
                                'DEPT_ID',
                                v_flag,
                                v_msg);
      if v_flag = 0 then
        --合成失败--
        flag := v_flag;
        msg  := v_msg;
      else
        flag := 1;
        msg  := v_msg;
      end if;
    end if;
  exception
    when others then
      flag := 0;
      msg  := P_CONTRACT_ID || ':流程启动错误：' || SQLERRM;
  end;
PROCEDURE wf_ct_change_qd_end(p_ins_code          in VARCHAR2,
                        p_key_id            in VARCHAR2,
                        p_audit_status      in VARCHAR2,
                        p_audit_status_name in VARCHAR2,
                        p_user_id           in VARCHAR2,
                        p_return_msg        out clob)is
    t_uuid       varchar2(36);
    p_uuid       varchar2(36);
    v_flag       number;
    vCount       number;
    pContract_id    varchar2(36);
    v_seq_id         number;
    v_msg        varchar2(1000);
    vCheck_h_id  varchar2(36);
    vCheck_l_id  varchar2(36);
    v_count          number;
    begin
      --取合同履行阶段变更ID
      select l.contract_id 
             into pContract_id 
      from XSR_XZ_CT_CHANGE_QD l
      where l.ins_code is not null
      and l.ins_code = p_ins_code;
      
      --查询是否有对应项目ID
       select count(1) into v_count from XSR_XZ_MD_PRO
       where pro_id =(select lx.PROJECT_ID from XSR_XZ_CT_CHANGE_QD lx  where lx.CONTRACT_ID=pContract_id);
      --得到查询个数
     if v_count>0 then
    --  select SYS_GUID() into t_uuid from DUAL@LK_TO_JT.ZHENERGY.COM.CN; --主键ID
      --将合同管理变更插入到中间表中
      insert into XSR_XZ_CT_MID_C_QD@LK_TO_JT.ZHENERGY.COM.CN 
      	(PK_MID_C_QD_ID, -- 0中间表ID
         CONTRACT_ID, -- 1业务表ID
         CHANGE_CONTRACT_ID, -- 2合同ID,(项目层,被变更的合同ID)
         CONTRACT_NAME, -- 3合同名称
         ORG_ID, -- 4组织id
         PRO_ID, -- 5项目ID
         ENDORSE_DATE, -- 6签订日期
         ENDORSE_UNIT_ID, -- 7签订单位ID
         WIN_BIDDING_PRICE, -- 8中标价格
         CONTRACT_PRICE, -- 9合同价格
         MAIN_CONTENT, -- 10招标文件与原合同条款主要内容
         CHANGE_CONTENT, -- 11变更主要内容、原因
         REASONS_AND_BASIS, -- 12理由及依据
         ENDORSE_UNIT_NAME, -- 13签约单位          
         DATA_FROM, -- 15文档数据来源(JT:集团录入   IF:子项目上传)
         CREATED_BY, -- 16创建人
         CREATION_DATE -- 17创建日期
        )select 
         FUN_GET_UUID@LK_TO_JT.ZHENERGY.COM.CN, -- 0
         CONTRACT_ID, -- 1
         CHANGE_CONTRACT_ID, -- 2
         CONTRACT_NAME, -- 3
         (select o.ou_org_id from XSR_XZ_MD_PRO o where o.org_id = lx.ORG_ID and o.PRO_ID =lx.PROJECT_ID), -- 4
         (select o.PROJECT_ID from XSR_XZ_MD_PRO o where o.PRO_ID = lx.PROJECT_ID), -- 5
         ENDORSE_DATE, -- 6
         ENDORSE_UNIT_ID, -- 7
         WIN_BIDDING_PRICE, -- 8
         CONTRACT_PRICE, -- 9
         MAIN_CONTENT, -- 10
         CHANGE_CONTENT, -- 11
         REASONS_AND_BASIS, -- 12
         (select a.com_name from XSR_XZ_BA_COM_ALL a where a.com_id=lx.ENDORSE_UNIT_ID), -- 13
         'IF', -- 15
         (select EMP_NAME from XIP_PUB_EMPS  where EMP_ID=(select EMP_ID from XIP_PUB_USERS  where USER_ID =LX.CREATED_BY)), -- 16
         CREATION_DATE -- 17
        from XSR_XZ_CT_CHANGE_QD lx where lx.CONTRACT_ID = pContract_id;
        
          /*3.将数据插入到中间表*/
      --获取序列值
      SELECT XSR_XZ_CCS_SEQ.NEXTVAL INTO V_SEQ_ID FROM DUAL@LK_TO_JT.ZHENERGY.COM.CN;
        --插入数据到附件中间表
      /**
      * 字段说明
      * DOC_ID 关联表 XSR_XZ_PM_DOC_M、XSR_XZ_PM_DOC_U
      * DOCS_URL_ID  
      * PK_JTDS_DOC_MANAGEMENT 表中主键，传集团时用到
      * MAIN_ID 4.0中业务主键  关联业务表中主键，不传集团
      */
      INSERT INTO XSR_XZ_PM_DOC_U@LK_TO_JT.ZHENERGY.COM.CN
        (DOCS_URL_ID, --1     
         DOC_ID, --2
         DOC_URL, --3
         DOC_NAME, --4
         PK_JTDS_DOCS_URL, --5
         INTERFACE_STATUS, --6
         DATA_FROM, --7              
         PROJECT_ID, --8
         TENDER_LEDGER_ID, --9
         DOC_TYPE, --10
         IS_DELETE, --11
         CREATE_DATE, --12
         DOC_TYPE_CODE, --13
         MAIN_ID,--14
         DOC_ATT_ID,--15
         DOC_ATT_FILE_TYE,--16
         ATT_CAT_NAME

         )
        SELECT V_SEQ_ID,
               V_SEQ_ID,
               /*(SELECT PC.CAT_CODE
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_URL,*/
                 (select 
                   ( select max(o.jt_address)
    from XSR_XZ_MD_PRO o,XIP_PUB_ATTS P
   where o.org_id =
         (select org_id
             from XSR_XZ_CT_CHANGE_QD Q
            where Q.CONTRACT_ID= P.SRC_ID))||
                    (select max(o.jt_file_name)
     from XSR_XZ_MD_PRO o, XIP_PUB_ATTS P
    where o.org_id =
          (select org_id
             from XSR_XZ_CT_CHANGE_QD Q
            where Q.CONTRACT_ID= P.SRC_ID))||'/'||
                     d.cat_code || '/' || a.att_id || a.att_file_type as url
                from xip_pub_atts        a,
                     xip_pub_att_cat_sec b,
                     xip_pub_att_cat     d,
                     xip_pub_att_server  c
               where a.att_cat_id = b.att_cat_id
                 and b.att_cat_id = d.att_cat_id
                 and b.att_server_id = c.server_id
                 and a.att_id = P.att_Id) DOC_URL,

               P.ATT_FILE_NAME,
               XSR_XZ_CCS_SEQ.NEXTVAL@LK_TO_JT.ZHENERGY.COM.CN,--5
               '',
               0,
               (select MP.PROJECT_ID  from XSR_XZ_MD_PRO MP where MP.PRO_ID =
                  (select Q.PROJECT_ID from XSR_XZ_CT_CHANGE_QD Q where Q.CONTRACT_ID=P.SRC_ID )) PRO_ID, --8
               '',
 (SELECT PC.CAT_NAME
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE,
               '',
               P.CREATION_DATE,
              (SELECT PC.CAT_CODE
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE_CODE,
           /*  (select h.category_code from XSR_XZ_PM_REP_H h where h.mainform_id=p.src_id) DOC_TYPE_CODE,*/
               P.SRC_ID,
               p.ATT_ID,
               p.ATT_FILE_TYPE,
               (select CAT_NAME from XIP_PUB_ATT_CAT z where z.ATT_CAT_ID = p.ATT_CAT_ID) ATT_CAT_NAME

          FROM XIP_PUB_ATTS P
         WHERE P.SRC_ID = pContract_id;
  end  if;
    commit;
    p_return_msg := '<result><flag>0</flag><msg>ok!</msg></result>';
    end;
  /*合同履行阶段变更管理*/
  PROCEDURE wf_ct_change_lx(P_CONTRACT_ID IN VARCHAR2,
                            flag          OUT NUMBER,
                            msg           OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    h_flag         number;
    B_FLAG         varchar2(2);
    h_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from Xsr_Xz_Ct_Change_LX h
     where h.contract_id = P_CONTRACT_ID;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
    flag := 1;
    xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_CT_CHANGE_LX',
                              'contract_id',
                              P_CONTRACT_ID,
                              'CONTRACT_ID',
                              'CONTRACT_ID',
                              'ORG_ID',
                              'DEPT_ID',
                              flag,
                              msg);
  exception
    when others then
      flag := 0;
      msg  := P_CONTRACT_ID || ':流程启动错误：' || SQLERRM;
  end;
PROCEDURE wf_ct_change_lx_end(p_ins_code          in VARCHAR2,
                        p_key_id            in VARCHAR2,
                        p_audit_status      in VARCHAR2,
                        p_audit_status_name in VARCHAR2,
                        p_user_id           in VARCHAR2,
                        p_return_msg        out clob)is
    t_uuid       varchar2(36);
    p_uuid       varchar2(36);
    v_flag       number;
    vCount       number;
    pContract_id    varchar2(36);
    v_seq_id         number;
    v_msg        varchar2(1000);
    vCheck_h_id  varchar2(36);
    vCheck_l_id  varchar2(36);
    v_count          number;
    begin
      --取合同履行阶段变更ID
      select l.contract_id 
             into pContract_id 
      from XSR_XZ_CT_CHANGE_LX l
      where l.ins_code is not null
      and l.ins_code = p_ins_code;
      
       --查询是否有对应项目ID
       select count(1) into v_count from XSR_XZ_MD_PRO
       where pro_id =(select lx.PROJECT_ID from XSR_XZ_CT_CHANGE_LX lx  where lx.CONTRACT_ID=pContract_id);
      --得到查询个数
      if v_count>0 then
      
  
    --  select SYS_GUID() into t_uuid from DUAL@LK_TO_JT.ZHENERGY.COM.CN; --主键ID
      --将合同管理变更插入到中间表中
      insert into XSR_XZ_CT_MID_C_LX@LK_TO_JT.ZHENERGY.COM.CN 
      	(PK_MID_C_LX_ID, -- 0中间表ID
         CONTRACT_ID, -- 1业务表ID
         CHANGE_CONTRACT_ID, -- 2合同ID,(项目层,被变更的合同ID)
         CONTRACT_NAME, -- 3合同名称
         ORG_ID, -- 4组织id
         PRO_ID, -- 5项目ID
         ENDORSE_DATE, -- 6签订日期
         ENDORSE_UNIT_ID, -- 7签订单位ID
         REPLENISH_CONTRACT_ID, -- 8补充合同ID
         INIT_CONTRACT_PRICE, -- 9初始合同价格
         REPLENISH_ADD_PRICE, -- 10补充合同增加金额
         ADJUST_CONTRACT_PRICE, -- 11调整后合同金额
         REPLENISH_MAIN_CONTENT, -- 12签订补充合同的主要内容
         REPLENISH_WHYS, -- 13签订补充合同的原因和理由
         ENDORSE_UNIT_NAME, -- 14签约单位        
         DATA_FROM, -- 15文档数据来源(JT:集团录入   IF:子项目上传)
         CREATED_BY, -- 16创建人
         CREATION_DATE -- 17创建日期
        )select 
         FUN_GET_UUID@LK_TO_JT.ZHENERGY.COM.CN, -- 0
         CONTRACT_ID, -- 1
         CHANGE_CONTRACT_ID, -- 2
         CONTRACT_NAME, -- 3
         (select o.ou_org_id from XSR_XZ_MD_PRO o where o.org_id = lx.ORG_ID and o.PRO_ID =lx.PROJECT_ID), -- 4
         (select o.PROJECT_ID from XSR_XZ_MD_PRO o where o.PRO_ID = lx.PROJECT_ID),
         ENDORSE_DATE, -- 6
         ENDORSE_UNIT_ID, -- 7
         REPLENISH_CONTRACT_ID, -- 8
         INIT_CONTRACT_PRICE, -- 9
         REPLENISH_ADD_PRICE, -- 10
         ADJUST_CONTRACT_PRICE, -- 11
         REPLENISH_MAIN_CONTENT, -- 12
         REPLENISH_WHYS, -- 13
         (select a.com_name from XSR_XZ_BA_COM_ALL a where a.com_id=lx.ENDORSE_UNIT_ID), -- 14
         'IF', -- 15
         (select EMP_NAME from XIP_PUB_EMPS  where EMP_ID=(select EMP_ID from XIP_PUB_USERS  where USER_ID =LX.CREATED_BY)), -- 16
         CREATION_DATE -- 17
        from XSR_XZ_CT_CHANGE_LX lx where lx.CONTRACT_ID = pContract_id;
        
          /*3.将数据插入到中间表*/
      --获取序列值
      SELECT XSR_XZ_CCS_SEQ.NEXTVAL INTO V_SEQ_ID FROM DUAL@LK_TO_JT.ZHENERGY.COM.CN;
        --插入数据到附件中间表
      /**
      * 字段说明
      * DOC_ID 关联表 XSR_XZ_PM_DOC_M、XSR_XZ_PM_DOC_U
      * DOCS_URL_ID  
      * PK_JTDS_DOC_MANAGEMENT 表中主键，传集团时用到
      * MAIN_ID 4.0中业务主键  关联业务表中主键，不传集团
      */
      INSERT INTO XSR_XZ_PM_DOC_U@LK_TO_JT.ZHENERGY.COM.CN
        (DOCS_URL_ID, --1     
         DOC_ID, --2
         DOC_URL, --3
         DOC_NAME, --4
         PK_JTDS_DOCS_URL, --5
         INTERFACE_STATUS, --6
         DATA_FROM, --7              
         PROJECT_ID, --8
         TENDER_LEDGER_ID, --9
         DOC_TYPE, --10
         IS_DELETE, --11
         CREATE_DATE, --12
         DOC_TYPE_CODE, --13
         MAIN_ID,--14
         DOC_ATT_ID,--15
         DOC_ATT_FILE_TYE,--16
         ATT_CAT_NAME

         )
        SELECT V_SEQ_ID,
               V_SEQ_ID,
               /*(SELECT PC.CAT_CODE
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_URL,*/
                 (select 
                     (select max(o.jt_address)
    from XSR_XZ_MD_PRO o,XIP_PUB_ATTS P
   where o.org_id =
         (select org_id
             from XSR_XZ_CT_CHANGE_LX LX
            where LX.CONTRACT_ID= P.SRC_ID))||
                     (select max(o.jt_file_name)
     from XSR_XZ_MD_PRO o, XIP_PUB_ATTS P
    where o.org_id =
          (select org_id
             from XSR_XZ_CT_CHANGE_LX LX
            where LX.CONTRACT_ID= P.SRC_ID))||'/'||
                     d.cat_code || '/' || a.att_id || a.att_file_type as url
                from xip_pub_atts        a,
                     xip_pub_att_cat_sec b,
                     xip_pub_att_cat     d,
                     xip_pub_att_server  c
               where a.att_cat_id = b.att_cat_id
                 and b.att_cat_id = d.att_cat_id
                 and b.att_server_id = c.server_id
                 and a.att_id = P.att_id) DOC_URL, 

               P.ATT_FILE_NAME,
               XSR_XZ_CCS_SEQ.NEXTVAL@LK_TO_JT.ZHENERGY.COM.CN,--5
               '',
               0,
               (select MP.PROJECT_ID  from XSR_XZ_MD_PRO MP where MP.PRO_ID =
                  (select LX.PROJECT_ID from XSR_XZ_CT_CHANGE_LX LX where LX.CONTRACT_ID=P.SRC_ID )) PRO_ID, --8
               '',
/*               (SELECT PC.CAT_NAME
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE,*/
             (SELECT PC.CAT_NAME
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE,
               '',
               P.CREATION_DATE,
              (SELECT PC.CAT_CODE
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE_CODE,
              P.SRC_ID,
               p.ATT_ID,
               p.ATT_FILE_TYPE,
               (select CAT_NAME from XIP_PUB_ATT_CAT z where z.ATT_CAT_ID = p.ATT_CAT_ID) ATT_CAT_NAME

          FROM XIP_PUB_ATTS P
         WHERE P.SRC_ID = pContract_id;
    end if;
    commit;
    p_return_msg := '<result><flag>0</flag><msg>ok!</msg></result>';
    end;
  /*合同结算情况表*/
  PROCEDURE wf_ct_change_js(P_CONTRACT_ID IN VARCHAR2,
                            flag          OUT NUMBER,
                            msg           OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    h_flag         number;
    B_FLAG         varchar2(2);
    h_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from XSR_XZ_CT_SETTLEMENT_NEW h
     where h.contract_id = P_CONTRACT_ID;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
    flag := 1;
    xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_CT_SETTLEMENT_NEW',
                              'contract_id',
                              P_CONTRACT_ID,
                              'CONTRACT_ID',
                              'CONTRACT_ID',
                              'ORG_ID',
                              'DEPT_ID',
                              flag,
                              msg);
  exception
    when others then
      flag := 0;
      msg  := P_CONTRACT_ID || ':流程启动错误：' || SQLERRM;
  end;
PROCEDURE wf_ct_change_js_end(p_ins_code          in VARCHAR2,
                        p_key_id            in VARCHAR2,
                        p_audit_status      in VARCHAR2,
                        p_audit_status_name in VARCHAR2,
                        p_user_id           in VARCHAR2,
                        p_return_msg        out clob)is
    t_uuid       varchar2(36);
    p_uuid       varchar2(36);
    v_flag       number;
    vCount       number;
    pContract_id    varchar2(36);
    v_seq_id         number;
    v_msg        varchar2(1000);
    vCheck_h_id  varchar2(36);
    vCheck_l_id  varchar2(36);
    v_count          number;
    begin
      --取合同履行阶段变更ID
      select l.contract_id 
             into pContract_id 
      from XSR_XZ_CT_SETTLEMENT_NEW l
      where l.ins_code is not null
      and l.ins_code = p_ins_code;
      
        --查询是否有对应项目ID
       select count(1) into v_count from XSR_XZ_MD_PRO
      where pro_id =(select lx.PROJECT_ID from XSR_XZ_CT_SETTLEMENT_NEW lx  where lx.CONTRACT_ID=pContract_id);
      --得到查询个数
     if v_count>0 then 
      
      
      
     -- select SYS_GUID() into t_uuid from DUAL@LK_TO_JT.ZHENERGY.COM.CN; --主键ID
      --将合同管理变更插入到中间表中
      insert into XSR_XZ_CT_MID_S_NEW@LK_TO_JT.ZHENERGY.COM.CN 
      	(PK_MID_S_NEW_ID, -- 0中间表ID
         CONTRACT_ID, -- 1业务表ID
         CHANGE_CONTRACT_ID, -- 2合同ID,(项目层,被变更的合同ID)
         CONTRACT_NAME, -- 3合同名称
         ORG_ID, -- 4组织id
         PRO_ID, -- 5项目ID
         ENDORSE_DATE, -- 6签订日期
         ENDORSE_UNIT_ID, -- 7签订单位ID
         ENDORSE_UNIT_NAME,
         REPLENISH_SUM_PRICE,
         SETTLEMENT_EXPLAIN,
         INIT_CONTRACT_PRICE, -- 9初始合同价格
         SETTLEMENT_PRICE, -- 10结算单价
         ADD_PRICE, -- 11结算价与初始合同价相比-增加额
         ADD_RANGE, -- 12结算价与初始合同价相比-增加幅度
         DATA_FROM, -- 15文档数据来源(JT:集团录入   IF:子项目上传)
         CREATED_BY, -- 16创建人
         CREATION_DATE -- 17创建日期
        )select 
         FUN_GET_UUID@LK_TO_JT.ZHENERGY.COM.CN, -- 0
         CONTRACT_ID, -- 1
         CHANGE_CONTRACT_ID, -- 2
         CONTRACT_NAME, -- 3
         (select o.ou_org_id from XSR_XZ_MD_PRO o where o.org_id = lx.ORG_ID and o.PRO_ID =lx.PROJECT_ID), -- 4
         (select o.PROJECT_ID from XSR_XZ_MD_PRO o where o.PRO_ID = lx.PROJECT_ID),
         ENDORSE_DATE, -- 6
         ENDORSE_UNIT_ID, -- 7
         (select a.com_name from XSR_XZ_BA_COM_ALL a where a.com_id=lx.ENDORSE_UNIT_ID),
         REPLENISH_SUM_PRICE,
         SETTLEMENT_EXPLAIN,
         INIT_CONTRACT_PRICE, -- 9
         SETTLEMENT_PRICE, -- 10
         ADD_PRICE, -- 11
         ADD_RANGE, -- 12
         'IF', -- 15
         (select EMP_NAME from XIP_PUB_EMPS  where EMP_ID=(select EMP_ID from XIP_PUB_USERS  where USER_ID =LX.CREATED_BY)), -- 16
         CREATION_DATE -- 17
        from XSR_XZ_CT_SETTLEMENT_NEW lx where lx.CONTRACT_ID = pContract_id;
        
          /*3.将数据插入到中间表*/
      --获取序列值
      SELECT XSR_XZ_CCS_SEQ.NEXTVAL INTO V_SEQ_ID FROM DUAL@LK_TO_JT.ZHENERGY.COM.CN;
        --插入数据到附件中间表
      /**
      * 字段说明
      * DOC_ID 关联表 XSR_XZ_PM_DOC_M、XSR_XZ_PM_DOC_U
      * DOCS_URL_ID  
      * PK_JTDS_DOC_MANAGEMENT 表中主键，传集团时用到
      * MAIN_ID 4.0中业务主键  关联业务表中主键，不传集团
      */
      INSERT INTO XSR_XZ_PM_DOC_U@LK_TO_JT.ZHENERGY.COM.CN
        (DOCS_URL_ID, --1     
         DOC_ID, --2
         DOC_URL, --3
         DOC_NAME, --4
         PK_JTDS_DOCS_URL, --5
         INTERFACE_STATUS, --6
         DATA_FROM, --7              
         PROJECT_ID, --8
         TENDER_LEDGER_ID, --9
         DOC_TYPE, --10
         IS_DELETE, --11
         CREATE_DATE, --12
         DOC_TYPE_CODE, --13
         MAIN_ID,--14
         DOC_ATT_ID,--15
         DOC_ATT_FILE_TYE,--16
         ATT_CAT_NAME

         )
        SELECT V_SEQ_ID,
               V_SEQ_ID,
               /*(SELECT PC.CAT_CODE
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_URL,*/
                 (select 
                     (select max(o.jt_address)
    from XSR_XZ_MD_PRO o,XIP_PUB_ATTS P
   where o.org_id =
         (select org_id
             from XSR_XZ_CT_SETTLEMENT_NEW N
            where N.CONTRACT_ID= P.SRC_ID))||
                     ( select max(o.jt_file_name)
     from XSR_XZ_MD_PRO o, XIP_PUB_ATTS P
    where o.org_id =
          (select org_id
             from XSR_XZ_CT_SETTLEMENT_NEW N
            where N.CONTRACT_ID= P.SRC_ID))||'/'||
                     d.cat_code || '/' || a.att_id || a.att_file_type as url
                from xip_pub_atts        a,
                     xip_pub_att_cat_sec b,
                     xip_pub_att_cat     d,
                     xip_pub_att_server  c
               where a.att_cat_id = b.att_cat_id
                 and b.att_cat_id = d.att_cat_id
                 and b.att_server_id = c.server_id
                 and a.att_id = P.att_Id) DOC_URL,

               P.ATT_FILE_NAME,
               XSR_XZ_CCS_SEQ.NEXTVAL@LK_TO_JT.ZHENERGY.COM.CN,--5
               '',
               0,
               (select MP.PROJECT_ID  from XSR_XZ_MD_PRO MP where MP.PRO_ID =
                  (select N.PROJECT_ID from XSR_XZ_CT_SETTLEMENT_NEW N where N.CONTRACT_ID=P.SRC_ID )) PRO_ID, --8
               '',
/*               (SELECT PC.CAT_NAME
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE,*/
         (SELECT PC.CAT_NAME
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE,
               '',
               P.CREATION_DATE,
              (SELECT PC.CAT_CODE
                  FROM XIP_PUB_ATT_CAT PC
                 WHERE PC.ATT_CAT_ID = P.ATT_CAT_ID) DOC_TYPE_CODE,
              P.SRC_ID,
               p.ATT_ID,
               p.ATT_FILE_TYPE,
               (select CAT_NAME from XIP_PUB_ATT_CAT z where z.ATT_CAT_ID = p.ATT_CAT_ID) ATT_CAT_NAME

          FROM XIP_PUB_ATTS P
         WHERE P.SRC_ID = pContract_id;
    end if ;
    commit;
    p_return_msg := '<result><flag>0</flag><msg>ok!</msg></result>';
    end ;
  /*合同结算管理*/
  PROCEDURE wf_ct_account(P_CT_ACCOUNT_ID IN VARCHAR2,
                          flag            OUT NUMBER,
                          msg             OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    h_flag         number;
    B_FLAG         varchar2(2);
    h_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select A.audit_status
      into v_audit_status
      from XSR_XZ_CT_ACCOUNT A
     where A.CT_ACCOUNT_ID = P_CT_ACCOUNT_ID;
    if v_audit_status not in ('A', 'D', 'R', 'CA') then
      flag := 0;
      msg  := '只有新建、撤回、驳回、变更起草的单据才能启动流程！';
      return;
    end if;
    flag := 1;
    xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_CT_ACCOUNT',
                              'CT_ACCOUNT_ID',
                              P_CT_ACCOUNT_ID,
                              'CT_ACCOUNT_ID',
                              'CT_ACCOUNT_ID',
                              'ORG_ID',
                              'DEPT_ID',
                              flag,
                              msg);
  exception
    when others then
      flag := 0;
      msg  := P_CT_ACCOUNT_ID || ':流程启动错误：' || SQLERRM;
  end;

  /**
  * 自动编码
  * 
  **/
  FUNCTION F_AUTO_CODE(P_CT_H_ID VARCHAR2, P_FLAG VARCHAR2) RETURN VARCHAR2 IS
    V_COUNT     NUMBER;
    V_SERIAL_ID VARCHAR2(8); --最大流水号
    V_SYSDATE   VARCHAR2(8); --日期
    V_RET_CODE  VARCHAR2(512); --返回值
    V_CON_CODE  VARCHAR2(512); --合同编码
  BEGIN
    IF P_FLAG IS NULL THEN
      RETURN '';
    END IF;
  
    IF P_CT_H_ID IS NOT NULL THEN
      --获取合同编码
      SELECT CO.CT_H_CODE
        INTO V_CON_CODE
        FROM xsr_xz_ct_h CO
       WHERE CO.CT_H_ID = P_CT_H_ID;
    
      /*    --截取开头含有'ZNTE-01-'的合同
      IF SUBSTR(V_CON_CODE,1,LENGTH('ZNTE-01-')) = 'ZNTE-01-' THEN
         V_CON_CODE := SUBSTR(V_CON_CODE,LENGTH('ZNTE-01-')+1);
      END IF;*/
    
    END IF;
  
    --合同行信息，格式：003位流水号
    IF P_FLAG = 'HT' THEN
    
      --获取流水号
      SELECT COUNT(1)
        INTO V_COUNT
        FROM xsr_xz_ct_L CL
       WHERE CL.CT_H_ID = P_CT_H_ID;
    
      IF V_COUNT = 0 THEN
        V_SERIAL_ID := '001';
      ELSE
        SELECT TO_CHAR(TO_NUMBER(MAX(CL.L_CODE)) + 1, 'FM000')
          INTO V_SERIAL_ID
          FROM xsr_xz_ct_L CL
         WHERE CL.CT_H_ID = P_CT_H_ID;
      END IF;
    
      V_RET_CODE := V_SERIAL_ID;
    
      RETURN V_RET_CODE;
    END IF;
  
    --报量，格式：BL-合同编码-3位流水号
    IF P_FLAG = 'BL' THEN
      SELECT COUNT(1)
        INTO V_COUNT
        FROM XSR_XZ_CT_PLAN_H RM
       WHERE RM.CT_H_ID = P_CT_H_ID
         AND RM.PLAN_H_CODE LIKE 'BL-' || V_CON_CODE || '-%';
    
      --构造流水号
      IF V_COUNT = 0 THEN
        V_SERIAL_ID := '001';
      ELSE
        SELECT TO_CHAR(TO_NUMBER(SUBSTR(MAX(RM.PLAN_H_CODE), -3, 3)) + 1,
                       'FM000')
          INTO V_SERIAL_ID
          FROM XSR_XZ_CT_PLAN_H RM
         WHERE RM.CT_H_ID = P_CT_H_ID
           and rm.operation_status = 'NOR'
           AND RM.PLAN_H_CODE LIKE 'BL-' || V_CON_CODE || '-%';
      END IF;
    
      V_RET_CODE := 'BL-' || V_CON_CODE || '-' || V_SERIAL_ID;
    
      RETURN V_RET_CODE;
    END IF;
  
    --接收入库，格式：RK-合同编码-3位流水号
    IF P_FLAG = 'RK' THEN
      SELECT COUNT(1)
        INTO V_COUNT
        FROM XSR_XZ_MT_IN_H IM
       WHERE IM.Ct_h_Id = P_CT_H_ID
         AND IM.IN_NO LIKE 'RK-' || V_CON_CODE || '-%';
    
      IF V_COUNT = 0 THEN
        V_SERIAL_ID := '001';
      ELSE
        SELECT TO_CHAR(TO_NUMBER(SUBSTR(MAX(IM.IN_NO), -3, 3)) + 1, 'FM000')
          INTO V_SERIAL_ID
          FROM XSR_XZ_MT_IN_H IM
         WHERE IM.Ct_h_Id = P_CT_H_ID
           AND IM.IN_NO LIKE 'RK-' || V_CON_CODE || '-%'
           AND IM.OPERATION_STATUS = 'NOR';
      END IF;
    
      V_RET_CODE := 'RK-' || V_CON_CODE || '-' || V_SERIAL_ID;
      RETURN V_RET_CODE;
    END IF;
    --出库，格式：CK-20130602-3位流水号
    IF P_FLAG = 'CK' THEN
      --获取年月日
      SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') INTO V_SYSDATE FROM DUAL;
    
      --获取流水号
      SELECT COUNT(1)
        INTO V_COUNT
        FROM XSR_XZ_MT_OUT_H OM
       WHERE OM.OUT_NO LIKE 'CK-' || V_SYSDATE || '-%';
    
      IF V_COUNT = 0 THEN
        V_SERIAL_ID := '001';
      ELSE
        SELECT TO_CHAR(TO_NUMBER(SUBSTR(MAX(OM.OUT_NO), -3, 3)) + 1,
                       'FM000')
          INTO V_SERIAL_ID
          FROM XSR_XZ_MT_OUT_H OM
         WHERE om.out_par_h_id is null
           AND OM.OPERATION_STATUS = 'NOR'
           AND OM.OUT_NO LIKE 'CK-' || V_SYSDATE || '-%';
      END IF;
    
      V_RET_CODE := 'CK-' || V_SYSDATE || '-' || V_SERIAL_ID;
    
      RETURN V_RET_CODE;
    END IF;
  
    --付款，格式：FK-合同编码-3位流水号
    IF P_FLAG = 'FK' THEN
      SELECT COUNT(1)
        INTO V_COUNT
        FROM XSR_XZ_EX_PAY_REQ_H P
       WHERE P.CT_H_ID = P_CT_H_ID
         AND P.PAY_REQ_H_CODE LIKE 'FK-' || V_CON_CODE || '-%';
    
      IF V_COUNT = 0 THEN
        V_SERIAL_ID := '001';
      ELSE
        SELECT TO_CHAR(TO_NUMBER(SUBSTR(MAX(P.PAY_REQ_H_CODE), -3, 3)) + 1,
                       'FM000')
          INTO V_SERIAL_ID
          FROM XSR_XZ_EX_PAY_REQ_H P
         WHERE P.CT_H_ID = P_CT_H_ID
           AND P.OPERATION_STATUS = 'NOR'
           AND P.PAY_REQ_H_CODE LIKE 'FK-' || V_CON_CODE || '-%';
      END IF;
    
      V_RET_CODE := 'FK-' || V_CON_CODE || '-' || V_SERIAL_ID;
      RETURN V_RET_CODE;
    END IF;
  END;
END;
