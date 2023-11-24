PROCEDURE wf_mt_handcost_tp_start(p_handcost_tp_h_id IN VARCHAR2,
                                 flag            OUT NUMBER,
                                 msg             OUT VARCHAR2) is
    v_audit_status varchar2(1000);
    --v_inv_h_code   varchar2(1000);
   -- v_inv_h_name   varchar2(1000);
    v_flag         number;
    v_msg          varchar2(1000);
    --t_msg          varchar2(1000);
  begin
    /*1.检查单据状态*/
    select h.audit_status
      into v_audit_status
      from XSR_XZ_MT_HANDCOST_TP_H h
     where h.handcost_tp_h_id = p_handcost_tp_h_id;
    if v_audit_status not in ('A', 'D', 'R') then
      flag := 0;
      msg  := '只有新建、撤回、驳回的单据才能启动流程！';
      return;
    end if;
    /*2.检查单据预算*/
    -- vld_inv(p_handcost_tp_h_id,'Y',v_flag,v_msg);
    flag := 1;
    if v_flag = 0 then
      flag := v_flag;
      msg  := v_msg;
    else
      flag := 1;
      xsr_xz_ba_pkg.gen_wf_para('XSR_XZ_MT_HANDCOST_TP_H',
                                'HANDCOST_TP_H_ID',
                                p_handcost_tp_h_id,
                                'HANDCOST_TP_H_CODE',
                                'HANDCOST_TP_H_NAME',
                                'ORG_ID', --ORG_ID
                                '', --DEPT_ID
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
      msg  := p_handcost_tp_h_id || ':流程启动错误：' || SQLERRM;
  end;