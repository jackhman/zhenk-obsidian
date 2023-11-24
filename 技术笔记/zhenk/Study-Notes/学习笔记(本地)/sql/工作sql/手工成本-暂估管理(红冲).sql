Procedure XSR_XZ_REDBACK_PKG.mtHandCostTpRedBack(pHandTpHID VARCHAR2, vReturnDesc OUT VARCHAR2) IS
    vResult       VARCHAR2(128);

    t_uuid_hand_tp_h varchar2(36); --手工成本主键ID
    t_uuid_hand_tp_l varchar2(36); --手工成本行ID
    handHRow      XSR_XZ_MT_HANDCOST_TP_H%rowtype; --工程报量单主信息行记录
    fun_flag      number;
    fun_msg       varchar2(2000);
    p_raise EXCEPTION;
    p_bg_item_id VARCHAR2(36);
    p_bg_fare_id VARCHAR2(36);
    p_tsk_id  VARCHAR2(36);
  BEGIN
    SELECT *
      INTO handHRow
      FROM XSR_XZ_MT_HANDCOST_TP_H
     WHERE HANDCOST_TP_H_ID = pHandTpHID;
    SELECT SYS_GUID() INTO　t_uuid_hand_tp_h 　FROM DUAL;
    INSERT INTO XSR_XZ_MT_HANDCOST_TP_H
      (HANDCOST_TP_H_ID,
       HANDCOST_TP_H_CODE,
       HANDCOST_TP_H_NAME,
       PRJ_ID,
       ORG_ID,
       BUS_TYPE,
       COM_ID,
       AMOUNT,
       CREATED_BY,
       CREATION_DATE,
       LAST_UPDATED_BY,
       LAST_UPDATE_DATE,
       IN_OPER_ID,
       IN_OPER_DATE,
       IS_GL,
       AUDIT_STATUS,
       INS_CODE,
       AUDIT_STATUS_NAME)
    VALUES
      (t_uuid_hand_tp_h,
       'HC-' || handHRow.Handcost_tp_h_Code,
       '红冲-' || handHRow.Handcost_tp_h_Name,
       handHRow.Prj_Id,
       handHRow.Org_Id,
       handHRow.BUS_TYPE,
       handHRow.Com_Id,
       handHRow.Amount * (-1),
       handHRow.CREATED_BY,
       handHRow.CREATION_DATE,
       handHRow.LAST_UPDATED_BY,
       handHRow.LAST_UPDATE_DATE,
       handHRow.IN_OPER_ID,
       handHRow.IN_OPER_DATE,
       handHRow.IS_GL,
       handHRow.AUDIT_STATUS,
       handHRow.INS_CODE,
       handHRow.AUDIT_STATUS_NAME);
    FOR mt_hand_tp_L IN (SELECT *
                         FROM XSR_XZ_MT_HANDCOST_TP_L L
                        WHERE L.HANDCOST_TP_H_ID = pHandTpHID) LOOP
      SELECT SYS_GUID() INTO t_uuid_hand_tp_l FROM DUAL;
      INSERT INTO XSR_XZ_MT_HANDCOST_TP_L
        (HANDCOST_TP_L_ID,
         HANDCOST_TP_H_ID,
         SEQ_NO,
         HCTXT,
         AMOUNT_S,
         AMOUNT_H,
         Sub_Id,
         TSK_ID,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_DATE,
         DESCRIPTION)
      VALUES
        (t_uuid_hand_tp_l,
         t_uuid_hand_tp_h,
         mt_hand_tp_L.Seq_No,
         mt_hand_tp_L.Hctxt,
         mt_hand_tp_L.Amount_s * (-1),
         mt_hand_tp_L.Amount_h * (-1),
         mt_hand_tp_L.Sub_Id,
         mt_hand_tp_L.Tsk_Id,
         mt_hand_tp_L.Created_By,
         mt_hand_tp_L.Creation_Date,
         mt_hand_tp_L.Last_Updated_By,
         mt_hand_tp_L.Last_Update_Date,
         mt_hand_tp_L.Description);

      IF mt_hand_tp_L.Tsk_Id IS NOT NULL THEN

        SELECT TSK_ID
          INTO p_tsk_id
          FROM XSR_XZ_PM_PRJ_TSK T
         WHERE T.Tsk_Full_Code = mt_hand_tp_L.TSK_ID;

        SELECT DISTINCT BG_ITEM_ID
          INTO p_bg_item_id
          FROM XSR_XZ_BG_CCID_DTL D, XSR_XZ_PM_BG_H H
         WHERE D.PM_BG_H_ID = H.PM_BG_H_ID
           AND H.IF_CONTROL = '1'
           AND D.TSK_ID =
               (SELECT TSK_ID
                  FROM XSR_XZ_PM_PRJ_TSK
                 WHERE TSK_FULL_CODE = mt_hand_tp_L.TSK_ID);

        SELECT DISTINCT BG_FARE_ID
          INTO p_bg_fare_id
          FROM XSR_XZ_BG_CCID_DTL D, XSR_XZ_PM_BG_H H
         WHERE D.PM_BG_H_ID = H.PM_BG_H_ID
           AND H.IF_CONTROL = '1'
           AND D.TSK_ID =
               (SELECT TSK_ID
                  FROM XSR_XZ_PM_PRJ_TSK
                 WHERE TSK_FULL_CODE = mt_hand_tp_L.TSK_ID);
        --生成成本
        xsr_xz_pm_pkg.INSERT_COST_BUS('XSR_XZ_MT_HANDCOST_TP_H',
                                      t_uuid_hand_tp_h,
                                      t_uuid_hand_tp_l,
                                      '', --业务编码
                                      '', --业务名称
                                      '', --模板ID
                                      '', --EBS状态
                                      handHRow.AUDIT_STATUS, --审批状态
                                      mt_hand_tp_L.CREATION_DATE, --创建时间
                                      SYSDATE, --记账日期
                                      mt_hand_tp_L.Amount_s * (-1), --金额(不含税金额)
                                      mt_hand_tp_L.Amount_s * (-1) *
                                      mt_hand_tp_L.Amount_s * (-1), --折后金额
                                      'CNY', --币种
                                      handHRow.ORG_ID, --组织ID
                                      '', --部门ID
                                      handHRow.PRJ_ID, --项目ID
                                      p_tsk_id, --任务ID
                                      p_bg_item_id, --科目ID
                                      p_bg_fare_id, --栏目ID
                                      'SYSTEM', --创建人ID
                                      fun_flag,
                                      fun_msg);
      END IF;
      IF fun_flag = 1 THEN
        vReturnDesc := fun_msg;
        RAISE p_raise;
      END IF;
    END LOOP;
        --更新原工程报量单 是否红冲 字段  为 Y（已红冲）
    UPDATE XSR_XZ_MT_HANDCOST_TP_H
       SET IS_REDBACK = 'Y'
     WHERE HANDCOST_TP_H_ID = pHandTpHID;
    COMMIT;
   vReturnDesc := '1';
  EXCEPTION
    when p_raise then
      rollback;
    WHEN OTHERS THEN
      rollback;
      vReturnDesc := SQLERRM;
  END;