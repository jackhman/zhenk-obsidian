--练习
Select '' CLS_ID, '&nbsp;' CLS_NAME, 0 SORT
          FROM DUAL
        UNION
        Select C.CLS_ID, C.CLS_NAME, 1 SORT From Xsr_Xz_Pm_Cls C

--表示的是左关联,返回左表的全部数据
		select s.*,r.* from test_student s,test_result r
	where s.student_id=r.student_id(+)

	
--oracle创建用户名
--1.创建表空间
create tablespace znpm
datafile 'D:\do\oracle\product\10.2.0\oradata\orcl\znpm.dbf' size 50m
autoextend on next 50m maxsize 20480m;
--2.创建用户名和密码
create user znpm identified by znpm
  default tablespace znpm;
--3.授权
grant all privileges to znpm


start with A.folder_tree_id ={?folder_id?}
        connect by prior A.folder_tree_id = A.up_id

--Extjs  
---点击column时弹出提示		
metaData.tdAttr = 'data-qtip="'+value+'"'; 
		
-- 部署到开发环境
--查看功能路径

select * from wb_module m 
start with m.module_id='23ZTOJLP1I8L'
connect by prior m.parent_id=m.module_id; 

---查看菜单注册功能的路径
SELECT *
  FROM XIP_PUB_FUN_TREE T
 START WITH T.FUN_TREE_NAME LIKE '%切换项目%'
CONNECT BY PRIOR T.UP_ID = T.FUN_TREE_ID

  Wb.get('STATUS').setValue(true); //开口合同
  Ext.MessageBox.alert('提示', '上线确认成功！');

(select nvl((select e.emp_name
                     from xip_pub_users b,
                          xip_pub_emps e
                    where b.emp_id=e.emp_id
                          and b.user_id = a.execute_user),
                   a.execute_user) emp_name
          From xip_wf_ins_task a
         where a.instance_id in
               (select w.instance_id from xip_wf_process_instance w
                        where w.instance_code=P.ins_code)--单据工作流id
                and a.task_state='open'
                and rownum<2
         ) AUDIT_MAN, --待审批人--   

---
var myDate = new Date();  // 得到系统日期
var year =myDate.getFullYear();  //获取完整的年份(4位,1970-????) 
// alert(year);
var month = myDate.getMonth() + 1; 


//将标准时间转化为格式时间  yyyy-mm-dd 格式 
var formatDate = function (date) {  
  if(date == null){
  	return '';
  }
  var y = date.getFullYear();  
  var m = date.getMonth() + 1;  
  m = m < 10 ? '0' + m : m;  
  var d = date.getDate();  
  d = d < 10 ? ('0' + d) : d;  
  return y + '-' + m + '-' + d;  
};  

function strToDate(str) {
str = str.replace(/-/g,"/");
var date = new Date(str );
return date;
}

function sleep(numberMillis) { 
  var now = new Date(); 
  var exitTime = now.getTime() + numberMillis; 
  while (true) { 
  now = new Date(); 
  if (now.getTime() > exitTime) 
  return; 
  } 
}

---使用方法
var year = Wb.formatDate(new Date(),'Y');//获得年份2017
request.setAttribute('PRJ_YEAR',DateUtil.formatDate(new Date(), "yyyy"));

--cookie配置
var t_prj_id =getCookie('prj_id');
Wb.load(select_main_store,{'PRJ_ID':t_prj_id});



leaf = record.get('leaf');
//////设置cookie start ///////
var cookie_prj_id=getCookie('prj_id');
// alert(cookie_prj_id);
if(prj_id == null || prj_id == undefined || prj_id == ''){
//   alert(11);
// 	prj_id = record.get('ID');	//获取当前选中行的ID
  prj_id=getCookie('prj_id');
}else{
//   alert(22);
   if(leaf){
  setCookie('prj_id',prj_id,365);
  }else{
  setCookie('prj_id','',365);
  }
    alert(prj_id);
}
// alert(prj_id);
//////设置cookie end   //////


--左边是结构树，右边不是润乾的结构树展现

is_project = record.get('IS_PROJECT');//是否项目

if(is_project == 'Y'){
Wb.load(store_project,{'PRJ_ID':prj_id});
  }else{
  return;

}


//数字转换成千分位
function format (num) {
    return (num.toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
}
//根据数据库中的数据保留最大的小数位数为十位
function getNum(value){
	if((value != null && value != '') || value==0){
		var value = Ext.util.Format.number(value, "0,000,000,000,000.0000000000");
		var value_1 = value.split('.');
		if(value_1.length==2){
			var first = value_1[0];
			var value_2 = value_1[1].split('');
			var index =value_2.length;
			if(value_2.length>0){
			for(var i =value_2.length-1;i>0;i--){
			  if(value_2[i] == '0'){
				index = i;
			  }else{
				break;
			  }
			}
		   var second =  value_1[1].substring(0, index);
		   if(second==0){
			 return first;
		   }
		   if(value<0){
			 if(first==0){
			 var value_3 = '-'+0+'.'+second;
			 return value_3;
			 }
		   }else{
			 if(first==0){
			   var value_3 = 0+'.'+second;
			   return value_3;
			 }
		   }
		   var result = first+'.'+second;
		   return result;
		  }
		}
	}else{
	   return '';
	}
}

--//数字去除千分位
function delformat(sNum){
  	return sNum.replace(/,/g,"");
}

function commafyback(num) { 
  var x = num.split(','); 
  return parseFloat(x.join("")); 
} 
function commafy(num) { 
   num = num.toFixed(2) +""; 
   var re=/(-?/d+)(/d{3})/ 
   while(re.test(num)){ 
   num=num.replace(re,"$1,$2"); 
  } 
    return num; 
} 

---去除千分位
select REPLACE('21,2131.00',',','') from dual 

//浮点数加法运算   
 function FloatAdd(arg1,arg2)
{   
   var r1,r2,m;   
   try{r1=arg1.toString().split(".")[1].length;}catch(e){r1=0;}   
   try{r2=arg2.toString().split(".")[1].length;}catch(e){r2=0;}   
   m=Math.pow(10,Math.max(r1,r2)) ;  
   return (arg1*m+arg2*m)/m ;  
  }   
 //浮点数减法运算   
 function FloatSub(arg1,arg2){   
 var r1,r2,m,n;   
 try{r1=arg1.toString().split(".")[1].length;}catch(e){r1=0;}   
 try{r2=arg2.toString().split(".")[1].length;}catch(e){r2=0;}
 m=Math.pow(10,Math.max(r1,r2));   
 //动态控制精度长度   
 n=(r1>=r2)?r1:r2;   
 return ((arg1*m-arg2*m)/m).toFixed(n);   
 }   

var t_prj_id =getCookie('prj_id');
var url = 'showRaq/showRaqPage.jsp?raq_url=xsr_xz_ccs_xmjj.raq&params=PRJ_ID&PRJ_ID='+t_prj_id+'&USER_ID='+user_id;

var iframe = document.getElementById('prj_info_iframe');
iframe.src = url;
//iframe加载完毕后，隐藏提示信息
iframeOnload(iframe);


//show
var rowInfos = Wb.get('prj_treePanel').getSelectionModel().getSelection();

if(rowInfos==''){
  	return;
}

Wb.mask(null,"正在加载页面，请稍候...");
var record = rowInfos[0].data;	//获取树的选中行
var prj_id = record.ID;
if(leaf){
//var url = serverPath+'WebRaq4/showRaq/showRaqPage.jsp?raq_url=xsr_xz_pm_kybg.raq&params=CATEGORY_CODE&PRJ_ID='+t_prj_id+'&USER_ID='+user_id+'&CATEGORY_CODE=PTS_PD_QM_QMS';
var url = 'showRaq/showRaqPage.jsp?raq_url=xsr_xz_pm_kybg.raq&params=category_code,prject_id&prject_id='+prj_id+'&category_code=PTS_PM_EPP_XIN1';
  }else{
var url='';
}
var iframe = document.getElementById('keyan_report_iframe');
iframe.src = url;

//iframe加载完毕后，隐藏提示信息
iframeOnload(iframe);


//afterrender
var t_prj_id =getCookie('prj_id');
if(t_prj_id){
url = 'showRaq/showRaqPage.jsp?raq_url=xsr_xz_pm_kybg.raq&params=category_code,prject_id&prject_id='+t_prj_id+'&category_code=PTS_PM_EPP_XIN1';
}else{
  var  url='';
}
    var iframe = document.getElementById('keyan_report_iframe');
  	iframe.src = url;
    //iframe加载完毕后，隐藏提示信息
    iframeOnload(iframe);
	
	
--集团root
cd  /u01/oracle/soa/opmn/logs
tail -f default_group~OC4J_XZAPPS~default_group~1.log

--检查项目
  (SELECT T.PROJECT_NAME  FROM CTS_PROJECT T WHERE T.PROJECT_ID =PR.PRO_ID ) PRO_NAME,
-- 检查公司
(select JTC.ORGANIZATION_NAME company_name from JTDS_PROJECT_COMPANY_V JTC where JTC.STRUT_ID=pr.COMPANY_ID) AS company_name,
       pr.COMPANY_ID
FROM PTS_RPT_REPORT PR;

--把权限授权给其他用户
chown -R tomcat:tomcat bhpm

select * from XSR_XZ_BA_LKP_TYPE t where t.lookup_type='ROOT_NAME'
select * from XSR_XZ_BA_LKP_VALUE V where V.lookup_type='ROOT_NAME' 

SELECT STATUS_CATEGORY,STATUS_DESC FROM (
SELECT '' STATUS_CATEGORY,'&nbsp;' STATUS_DESC,0 SORT FROM DUAL UNION
SELECT M.STATUS_CATEGORY,M.STATUS_DESC,1 SORT
  FROM XIP_WF_BIZ_STATUS_ENUM M, XIP_WF_ENTITIES S
 WHERE M.ENTITY_ID = S.ENTITY_ID
   AND M.ENABLE_FLAG ='Y'
   AND S.ENTITY_CODE = 'XSR_XZ_CT_H_B') ORDER By SORT
	 
	 
	 SELECT * FROM XIP_WF_ENTITIES S WHERE S.ENTITY_CODE = 'XSR_XZ_CT_H_B'
	 
var prj_id=Wb.get('ePRJECT_ID').getValue();--中ePRJECT_ID是界面window中的id
--从数据库中的数据年月日分秒截取月份
SELECT distinct TO_CHAR(REPORT_DATE,'YYYY-MM-DD') as mounth  FROM XSR_XZ_PM_REP_H WHERE CATEGORY_CODE ='XSR_XZ_APPLICATION_CHECK'; 


var re=Wb.getRows(grid_pm_line,false);
var re1 = grid_pm_line.getSelectionModel();
var rows = re1.getSelection();
if(Wb.isEmpty(re))
{
  Wb.warning("请选中要编辑的单据！");
  return;
}
isNew='N';
var selection = grid_pm_rep.getSelectionModel().getSelection()[0];
var t_audit_stutas_name = selection.get("AUDIT_STATUS_NAME");
if(t_audit_stutas_name=='审批中' || t_audit_stutas_name=='审批通过'){
   Wb.get('clickOk_line').setDisabled(true);
}else{
   Wb.get('clickOk_line').setDisabled(false);
}
var detall_id=rows[0].data.DETAIL_ID;
 Wb.load(select_line_byId_store,{'DETAIL_ID':detall_id});
 Wb.edit(grid_pm_line,window_pm_line,'MAINFORM_ID');
 Wb.setTitle(window_pm_line,'');
 
 
 
 --多行插入数据
    -----import_in.click
 //导入提交按钮
var re=Wb.getRows(grid_import_in,false);

if(Wb.isEmpty(re)){
  	Wb.warning("请选中行!");
  	return;
}else{
 	var a = grid_pm_rep.getSelectionModel().getSelection()[0];
	var MAINFORM_ID = a.get('MAINFORM_ID');
  	select_lines_maxNo_ajax.request({'MAINFORM_ID':MAINFORM_ID});
}



---oracle截取字符串
 (SUBSTR({?ATT_FILE_NAME?},INSTR({?ATT_FILE_NAME?}, '.', -1) + 1,LENGTH({?ATT_FILE_NAME?}))),
      substr(P.BIRD_EYE_IMG,instr(P.BIRD_EYE_IMG,'/',-1)+1) BIRD_EYE_IMG_A,  --鸟瞰图名称

   AND PI.INSTANCE_CODE like '%'|| substr('{#insCode#}',
              instr('{#insCode#}', ';', 1, 4) + 1,
              (instr('{#insCode#}', ';', 1, 5) -
              instr('{#insCode#}', ';', 1, 4) - 1)) ||'%'
			  

 
   ----select_lines_maxNo_ajax.success
 //解析返回值 jsonarray
var rs =  Ext.decode(response.responseText);
//取得count 值
var seq_no = rs.SEQ; 
if(seq_no==null||seq_no==''){
   seq_no = 0;
}else{
	seq_no = seq_no+1;
}

var a = grid_pm_rep.getSelectionModel().getSelection()[0];
var MAINFORM_ID = a.get('MAINFORM_ID');

//获取grid选中的所有行
var re=Wb.getRows(grid_import_in,false);

for(var i = 0; i < re.length; i++){
    var new_uuid = xzUuid();
	var PROJECT_ID = re[i].PRJ_ID; //项目ID
   
    import_line_ajax.request({DETAIL_ID:new_uuid,
                              MAINFORM_ID:MAINFORM_ID,
                              L_SEQ:seq_no,
                              PROJECT_ID:PROJECT_ID});
}
Wb.load(select_line,{MAINFORM_ID_HID:MAINFORM_ID});
window_import_in.hide();



   ---- 能够自由配置
      ---先配置viewConfig
   {
    enableTextSelection:true
  }
  
  然后在每个column中的width配置宽度
  
  
  --成本归集、概算归集、库存归集、费用台账查询
 
  prj_id = record.get('ID');	//获取当前选中行的ID
// alert(prj_id);
Wb.load(qry_inv_bus_dtl_store,{'PRJ_ID':prj_id});


is_project = record.get('IS_PROJECT');//是否项目
leaf = record.get('leaf');
// alert(leaf);

// if(leaf){
//   Wb.load(qry_inv_bus_dtl_store,{'PRJ_ID':prj_id});
//   }else{
//   return;
// }


//////设置cookie start ///////
var cookie_prj_id=getCookie('prj_id');
// alert(cookie_prj_id);
if(prj_id == null || prj_id == undefined || prj_id == ''){
//   alert(11);
// 	prj_id = record.get('ID');	//获取当前选中行的ID
  prj_id=getCookie('prj_id');
}else{
//   alert(22);
   if(leaf){
  setCookie('prj_id',prj_id,365);
  }else{
  setCookie('prj_id','',365);
  }
//     alert(prj_id);
}
// alert(prj_id);
//////设置cookie end   //////


--更新sql语句
update table1 set column1=replace(column1,'(可以是column1字段中某一段)原数据','要改成的数据')

---首页配置表
select t.*, t.rowid from XIP_PORTAL_HOME t;
select t.*, t.rowid from XIP_PORTAL_COMPONENT t;
select t.*, t.rowid from XIP_PORTAL_COMPONENT_DTL t;
--首页配置字段中为0表示不显示
select t.is_default from XIP_PORTAL_HOME t;


--根据点击项目板块进入的树结构
   AND L.ORG_STRUT_L_ID = DECODE(ORG_STRUT_FAR_ID,'-1',{?org_strut_l_id?},ORG_STRUT_L_ID)

---虚拟机
895 124 389 --4号虚拟机

var vSql1="SELECT D.DEPT_ID,D.DEPT_NAME,O.ORG_ID,O.ORG_NAME,PD.PRJ_ID,F.PRJ_NAME FROM XSR_XZ_PM_PRJ_ALL F,XIP_PUB_EMP_ASG A,XIP_PUB_DEPTS D,XSR_XZ_BA_ORG_PRJ_DEFAULT PD,XIP_PUB_ORGS O,XIP_PUB_EMPS E WHERE A.DEPT_ID=D.DEPT_ID AND PD.ORG_ID=O.ORG_ID AND D.ORG_ID=O.ORG_ID AND A.EMP_ID=E.EMP_ID AND F.PRJ_ID=PD.PRJ_ID AND PD.USER_ID='{#XIP.userId#}' AND E.EMP_ID=(SELECT U.EMP_ID FROM XIP_PUB_USERS U WHERE U.USER_ID = '{#XIP.userId#}')";

--河北建投
http://60.205.124.209:8089/ccs/m?xwl=xip/pub/navigator/portalNavigator/portalExplorer

--饼状图链接
javascript:show('../../../znpm/showRaq/showRaqPage.jsp?raq_url=NDJH_TZWC.raq',400,750);



---当选择了项目全部显示内容，当没选择内容显示选了项目的内容
SELECT *
  FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
          FROM DUAL
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_PM_PROBASE_VALUES
         WHERE LOOKUP_TYPE = 'PROJECT_CODE'
/*            AND DESCRIPTION LIKE '%{#DESCRIPTION#}%' */
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1)
           AND  PRJ_ID={?PRJ_ID?} 
        UNION
        SELECT LOOKUP_CODE CODE, VALUE_NAME NAME,SORT
          FROM XSR_XZ_PM_PROBASE_VALUES
         WHERE LOOKUP_TYPE = 'PROJECT_CODE'
           AND sysdate > START_DATE_ACTIVE
           AND sysdate < nvl(END_DATE_ACTIVE,sysdate+1)
           AND  PRJ_ID IS NULL        
       )
 ORDER BY SORT
 
 --联系单基础信息维护中的LOOKUP_TYPE_ID
 --然后在工程资料--变更管理--工程联系单--工作联系单--设计联系单
 --较通用
  SELECT *
   FROM (SELECT '' CODE, '&nbsp;' NAME, 0 SORT
           FROM DUAL
         UNION
         SELECT LOOKUP_CODE CODE , VALUE_NAME NAME,SORT
           FROM XSR_XZ_PM_PROBASE_VALUES
          WHERE LOOKUP_TYPE_ID = '284400c4-047c-46c1-9745-80b97a9365c1'
            AND LOOKUP_TYPE = 'ISSUING_ORGANIZATION'
            AND ENABLED_FLAG = '1'
            AND  PRJ_ID={?PRJ_ID?}
         UNION
         SELECT LOOKUP_CODE CODE , VALUE_NAME NAME,SORT
           FROM XSR_XZ_PM_PROBASE_VALUES
          WHERE LOOKUP_TYPE_ID = '284400c4-047c-46c1-9745-80b97a9365c1'
            AND LOOKUP_TYPE = 'ISSUING_ORGANIZATION'
            AND ENABLED_FLAG = '1'
            AND  PRJ_ID IS NULL
          )
  ORDER BY SORT
  
  --在pickList
  [['','&nbsp;'],['A','未处理'],['S','已成功上传'],['E','上传失败']]
  
  --在where查询的时候，查询空数据
  where nvl(MYTYP,' ') LIKE '%{#MSTYP#}%' 

  --显示有上标字样以及项目字体颜色
       decode((select a.prj_progress_status from XSR_XZ_PM_PRJ_ALL  a where a.prj_id=l.pro_id),
       'ZJ','<font style="color:#392884;">'||L.ORG_STRUT_L_NAME||'</font>'|| (select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' 省')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       'JHZ','<font style="color:#5BBD2C;">'||L.ORG_STRUT_L_NAME||'</font>'||(select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' 省')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       'JG','<font style="color:#E33439;">'||L.ORG_STRUT_L_NAME||'</font>'||(select '<sup style="color:#E33439;">'||decode(a.is_pro_szd,'Y',' 省')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id)||(select '<sup style="color:#E33439;">'||decode(a.is_pro_foo,'Y',' 411')||'</sup>' from XSR_XZ_PM_PRJ_ALL a where a.prj_id=l.pro_id),
       L.ORG_STRUT_L_NAME) as "text",
	   
--根据条件显示标签
var t_prj_id =getCookie('prj_id');
var sql="select p.is_zndjcy as re from XSR_XZ_PM_PRJ_ALL p where p.prj_id ='"+t_prj_id+"'";
var is_zndjcy=xzDbSqlReSingle(sql); 
console.log(is_zndjcy);
if(is_zndjcy=='Y'){
   tabPanel.tabBar.items.items[7].show();//显示
}else{
   tabPanel.tabBar.items.items[7].hide();//隐藏
}

---列的隐藏和显示
//如果是出库信息，就走出库界面
 if(ex=='OUT'){
    Ext.getCmp('SOURCE_LINES_CODE_COL1').hide();//来源行编码隐藏
    Ext.getCmp('SOURCE_LINES_NAME_COL1').hide();//来源行名称隐藏
    grid_intax_l.columns[11].setVisible(true);
    grid_intax_l.columns[12].setVisible(true);
 }else{
    Ext.getCmp('DATA_CODE_COL1').hide();//物资全编码隐藏
    Ext.getCmp('DATA_NAME_COL1').hide();//物资名称隐藏
 }
---end

--修改某个字段的部分值
update XSR_XZ_PM_SPLAN_H h
   set h.main_pic_url = REPLACE(h.main_pic_url,
                                '浙江浙能温州发电有限公司光伏发电项目',
                                '温州电厂光伏工程')
								
---审批状态
SELECT STATUS_CATEGORY,STATUS_DESC FROM (
SELECT '' STATUS_CATEGORY,'&nbsp;' STATUS_DESC,0 SORT FROM DUAL UNION
SELECT M.STATUS_CATEGORY,M.STATUS_DESC,1 SORT
  FROM XIP_WF_BIZ_STATUS_ENUM M, XIP_WF_ENTITIES S
 WHERE M.ENTITY_ID = S.ENTITY_ID
   AND S.ENTITY_CODE = 'XSR_XZ_PM_REP_H_V'
   AND  M.Enable_Flag = 'Y') ORDER By SORT
   
   
   
   
 SELECT REPORT_DATE FROM (
SELECT '&nbsp;' REPORT_DATE,0 SORT FROM DUAL UNION
SELECT TO_CHAR(M.REPORT_DATE,'YYYY-MM-YY'),1 SORT
FROM XSR_XZ_PM_REP_H M 
WHERE CATEGORY_CODE ='XSR_XZ_APPLICATION_CHECK'
)ORDER By SORT


--获取当前用户名
var re1 = Wb.getSelRec(grid_Main); //获取选中行
var rowIndex = store_Main.indexOf(re1[0]);//定位选中行的第一行行号
var e= grid_Main.plugins[0],index=1;
e.completeEdit();
var mainform_id =xzUuid();
var create_by='{#XIP.empName#}';---获取当前用户名
if(rowIndex!=-1){//判断是否有选中行，有选中行就在选中行下面新增一行，并且复制选中行的第一行的值给新增行
  store_Main.insert(rowIndex+1,{MAINFORM_ID:mainform_id,SUM:'0',AUDIT_STATUS_NAME:'起草',CREATION_DATE:new Date(),CREATE_BY:create_by});
  e.startEditByPosition({row:rowIndex+1,column:0});
}else{//没有选中行，就新增空白行到第0行
  	  store_Main.insert(0,{MAINFORM_ID:mainform_id});
	  e.startEditByPosition({rows:rowIndex+1,column:0});
     }
	 
---插入
REQ_PLAN_DATE=to_date(substr({?REQ_PLAN_DATE?},1,19),'yyyy-mm-dd hh24:mi:ss'),--15制单日期
--update
TO_CHAR(H.BLDAT, 'yyyy-mm-dd') BLDAT, --凭证中的凭证日期
--or
UPDATE XSR_XZ_PM_REP_H SET
REPORT_DATE=to_date(substr({?REPORT_DATE?},1,7),'yyyy-mm')
WHERE MAINFORM_ID = {?MAINFORM_ID?}

---
and B.REQ_DATE between nvl(to_date(substr('{#date1#}',0,10),'yyyy/mm/dd'),to_date('1990/1/1','yyyy/mm/dd')) 


---DECODE用法
SELECT
 DECODE(L.ORG_STRUT_FAR_ID, '-1','浙能集团',
              (SELECT ORG_STRUT_L_NAME FROM XSR_XZ_PM_ORG_STRUT_L WHERE ORG_STRUT_L_ID = L.ORG_STRUT_FAR_ID)) ORG_STRUT_FAR_NAME
			  FROM XSR_XZ_PM_ORG_STRUT_L L
 WHERE ORG_STRUT_H_ID={?ORG_STRUT_H_ID?}
   and l.pro_id=a.prj_id(+)
   AND (ORG_STRUT_FAR_ID = {?ORG_STRUT_FAR_ID?}
    OR ({?ORG_STRUT_FAR_ID?} IS NULL AND ORG_STRUT_FAR_ID = '-1'))

 ORDER BY DECODE(L.IS_DIRECTORY,'N','A','B'),
 DECODE(a.prj_progress_status,'ZJ', 'A', 'JHZ', 'B', 'JG', 'C', ''),
L.IS_PROJECT,L.IS_COMPANY,L.NO_LEAF,L.NO_DIRECTORY


---查看树关系表的根节点有多少？
select level lv   --查看树关系表的根节点有多少？
,TO_CHAR(SYSDATE, 'yyyy') REPORT_YEAR,--当时时间
...from 

---查询框中默认
Wb.get('Q_INTERFACE_FINISH').setValue('未处理,上传失败');
var sql_param = 'A'+"',"+"'"+'E' ;
Wb.load(Query_Contract_Info_Store,{INTERFACE_FINISH:sql_param});

---与系统时间进行比较
  WHERE ..
   --AND (E_DATE > SYSDATE OR E_DATE IS NULL)
   AND SYSDATE BETWEEN NVL(S_DATE,SYSDATE-1) AND NVL(E_DATE,SYSDATE+1)
   
   
---查看本年12月份
select to_char(sysdate,'yyyy')||'-'||lpad(level,2,0) m_date from dual connect by level<13


---获取其中某个字段
var r=Wb.getRows(grid_pm_rep,false);
var create_by=r[0].CREATE_BY;


var selection = grid_pm_rep.getSelectionModel().getSelection()[0];
var create_by=selection.get("CREATE_BY");

---设置权限操作数据
var people = re[0].CREATED_BY;

if(people != '{#XIP.userId#}')
{
	Wb.warning("没有权限操作！");
  	return ;
}

//判断当前用户是否等于创建数据的用户
var create_by=re[0].CREATE_BY;
var p_userId = '{#XIP.userId#}';	//从session中获取当前用户ID
if(create_by!=p_userId){
  Ext.Msg.alert('提示','没有权限操作此数据!');
  return;
}



//获取url参数 
// http://www.xzsoft.info:8080/xzpm/main?xwl=23WKS5W8G7NE&CATEGORY_CODE=PTS_PD_PO_PBE&userId=f92c688a-df48-d4e2-e040-a8c021824389&roleId=&funId=b03b4d3b-c320-4cc1-a59c-7b3c7b06fe79
function getParame(name){
 //var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
  var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
     var r = window.location.search.substr(1).match(reg); //匹配目标参数
   if (r !== null) return unescape(r[2]); return null; //返回参数值
 }

---地址相同，参数不同，功能不同
var CATEGORY_CODE=getParame('CATEGORY_CODE');
sql语句中
like '%{#CATEGORY_CODE#}%'

var tabIframe=document.getElementsByTagName("iframe")[0].id;


---启动流程并向D表中插入数据
//向plan_l_d表中插入数据
function callBack1(e)
{
  	var reObj=Ext.JSON.decode(e);
    if (reObj.flag=='1')
    {
     // Wb.message(reObj.msg);
    }
    else
    {
      //alert(reObj.msg);
      Wb.message(reObj.msg);
    }
}
//工作流回调函数
function callWf(resp)
{
if(resp.flag==1){
     //Ext.Msg.alert('提示','创建流程实例失败,原因：'+resp.msg);
  	Wb.message('创建流程实例失败,原因：'+resp.msg);
}
  else if(resp.flag===0){
	 //此处可以添加业务逻辑，比如讲返回的实例编码回写到业务表
     //Ext.Msg.alert('提示','流程实例创建成功,流程实例编码：'+resp.instanceCode);
    //Wb.message('流程实例创建成功,流程实例编码：'+resp.instanceCode);
   formQuery();
   //向ct_plan_d表中插入或更新行表数据
   var plan_h_id = grid.getSelectionModel().getSelection()[0].get("PLAN_H_ID");
    var procName1="XSR_XZ_CT_INSERT_PLAN_D.INSERT_D";
    var procParas1="'"+plan_h_id+"'";
    xzDbProc(procName1,procParas1,callBack1);
	--xsr_xz_ct_pkg.wf_ct_h_callback(${e_instance_code},${e_business_id},${e_current_biz_status_cat},${e_current_biz_status_desc},${e_submitter})
}
}
//预算检查回调函数,启动发票结算流程
function callBack(e)
{	
  	var reObj=Ext.JSON.decode(e);
  	
    if (reObj.flag=='1')
    {
      //启动流程
      var _params = Ext.JSON.decode(reObj.msg) ;
      startAndSubmitByEntityCode('XSR_XZ_CT_PLAN_H_V',_params,callWf);
    }
    else
    {
      Wb.message(reObj.msg);
    }
}

function start_callBack(e){
    //存储过程名
    var procName="xsr_xz_ct_pkg.wf_ct_plan_start";
    //参数按照 逗号 分割
    var procParas="'"+re[0].PLAN_H_ID+"'";
   
    var reObj=Ext.JSON.decode(e);


  	if(reObj.flag=='2' || reObj.flag=='-1'){
  		Ext.MessageBox.alert('提示',reObj.msg);
    }else if(reObj.flag=='1'){
      	Wb.confirm(reObj.msg,function d(){
      		xzDbProc(procName,procParas,callBack);
      	});
    }else{
    	xzDbProc(procName,procParas,callBack);
    }
}

var re = Wb.getRows(grid,false);
if(Wb.isEmpty(re))
{
  Wb.message("请选中记录!");
  return;
}
//根据行信息判断，是否可以启动流程。
var t_l_sql = "select count(*) as re from XSR_XZ_CT_PLAN_L l where l.PLAN_H_ID='"+re[0].PLAN_H_ID+"'";
var t_l = xzDbSqlReSingle(t_l_sql);
if(t_l==null || t_l==0){
  Wb.warning("没有对应的报量行信息，无法启用流程!");
  return;
}

var proName = 'xsr_xz_ct_pkg.wf_ct_plan_start_check';

var proParas = "'"+re[0].PLAN_H_ID+"'";

Wb.confirm("启动流程？",
	function wfStart(){
  		xzDbProc(proName,proParas,start_callBack);
	}
);



---去掉数据中符号
YLZBJ_SUM=REPLACE({?YLZBJ_SUM?},',',''),

---按回车键load数据
if (event.getKey() == event.ENTER) {
  Wb.load(store4Comment);
}

P.PAY_REQ_H_CODE LIKE '%{#PAY_REQ_H_CODE_Q#}%' ---中PAY_REQ_H_CODE_Q表示查询输入框中id
--
//向plan_l_d表中插入数据
function callBack1(e)
{
  	var reObj=Ext.JSON.decode(e);
    if (reObj.flag=='1')
    {
     // Wb.message(reObj.msg);
    }
    else
    {
      //alert(reObj.msg);
      Wb.message(reObj.msg);
    }
}
//工作流回调函数
function callWf(resp)
{
if(resp.flag==1){
     //Ext.Msg.alert('提示','创建流程实例失败,原因：'+resp.msg);
  	Wb.message('创建流程实例失败,原因：'+resp.msg);
}
  else if(resp.flag===0){
	 //此处可以添加业务逻辑，比如讲返回的实例编码回写到业务表
     //Ext.Msg.alert('提示','流程实例创建成功,流程实例编码：'+resp.instanceCode);
    //Wb.message('流程实例创建成功,流程实例编码：'+resp.instanceCode);
   formQuery();
   //向ct_plan_d表中插入或更新行表数据
   var plan_h_id = grid.getSelectionModel().getSelection()[0].get("PLAN_H_ID");
    var procName1="XSR_XZ_CT_INSERT_PLAN_D.INSERT_D";
    var procParas1="'"+plan_h_id+"'";
    xzDbProc(procName1,procParas1,callBack1);
}
}


vtype:'decimals'


---获取/main?xwl=243OP3CLSBGX
var re =eval('['+response.responseText+']');


var t_date = eval('['+re[0].jsonData+']');
  
  	var t_store = new Ext.data.Store({
      data:t_date[0].root,
      autoLoad:true,  
      root:'root',  
      totalProperty:'totalProperty',  
      fields:['PRINT_PLAN_NAME','RAQ_CODE','RAQ_NAME']  
  	});
  	

var grid = Ext.getCmp('audit_detail_grid');
//获取动态的columns
grid.reconfigure(grid.getStore(),getCt_Plan_L_D_Columns());


---查询语句中条件
   AND P.CREATED_BY = {?XIP.userId?}
   
   
 //如果当前是回车事件
 ---在输入框中plan_l_where.specialkey
if(event.getKey() == event.ENTER){
l_name=Wb.get('plan_l_where').getValue();
var sql1=getSGBLSql(plan_h_id,l_name);
Wb.load(store1,{sql:sql1});
  console.log(sql1);
}

--角色id
{?XIP.roleId?})
--用户id
{?XIP.userId?}
---当前用户名
{#XIP.empName#}

---系统uuid
{?sys.uuid?}

Wb.get('ID').setValue(xzUuid()); //给主键赋值  

 {?timestamp.START_DATE?},
 {?timestamp.END_DATE?},
 {?timestamp.NEXT_DATE?},
 {?XIP.userId?},
 {?timestamp.sys.date?}


---在insert中的module下initScript
var result=StringUtil.getUtfString(request.getInputStream());
if(result.startsWith('{'))
  result='['+result+']';//to Array
var i, r=Wb.decode(result);
for(i in r){
  r[i].PLAN_TMP_ID=java.util.UUID.randomUUID();
}
r=Wb.encode(r);
request.setAttribute('returns',r);
request.setAttribute('rows',r);


--根据角色不同显示项目不同
SELECT P.PRJ_ID,
     P.PRJ_CODE,
     P.PRJ_NAME,
    P.CLS_NAME,
P.S_DATE,
P.E_DATE,
P.URL_FRM_ID,
P.CREATED_BY,
P.AUDIT_STATUS,
P.AUDIT_STATUS_NAME,
P.CREATE_MAN,
P.CREATION_DATE,
P.ORG_ID,
P.ORG_NAME,
--DECODE(P.PRJ_PROGRESS_STATUS,'DYS','待验收','SSZ','实施中','WH','维护','WKS','未开始','YWC','已完成','ZT','暂停') PRJ_PROGRESS_STATUS,
(SELECT VALUE_NAME FROM XSR_XZ_BA_LKP_VALUE WHERE LOOKUP_TYPE = 'PA_PROJECT_STATUS' AND LOOKUP_CODE=PRJ_PROGRESS_STATUS)PRJ_PROGRESS_STATUS,
P.INS_CODE,
p.dj_pro_id,
P.URL_FRM_ID_APP FRM_PRN_URL
  FROM XSR_XZ_PM_PRJ_ALL_V P
 WHERE
/*  p.dj_pro_id is not null 
 and */
 P.PRJ_CODE LIKE '%{#prj_code#}%'
   AND P.PRJ_NAME LIKE '%{#prj_name#}%'
and exists (select 1 
                	from xip_pub_org_sec sec
               		where (
                     		(sec.type='U' and sec.target_id={?XIP.userId?})
                         	or (sec.type='D' and sec.target_id={?XIP.roleId?})
                         )
               	     and sec.org_id=p.org_id
               )
 ORDER BY P.CREATION_DATE DESC

 
 
----查看结算款中的扣款是否被本结算款自己引用
   var count_other_sql="SELECT COUNT(O.OTHERS_H_ID) as re FROM XSR_XZ_EX_OTHERS_H O WHERE O.DEDUCTS_H_ID IN (SELECT B.DEDUCTS_H_ID FROM XSR_XZ_EX_DEDUCTS_H B WHERE B.PAY_REQ_H_ID='"+re[0].PAY_REQ_H_ID+"') and o.pay_req_h_id='"+re[0].PAY_REQ_H_ID+"'";

   
   
--查看数据库连接池的连接数
select count(*) from v$process 

select value from v$parameter where name = 'processes' 

---设置连接数
alter system set processes = 300 scope = spfile;


---所在column点击后跳入成功
var grid = Ext.getCmp('audit_detail_grid');
//获取动态的columns
grid.reconfigure(grid.getStore(),getCt_Plan_L_D_Columns());
console.log(getCt_Plan_L_D_Columns());


---在insert中的module.initScript
var result=StringUtil.getUtfString(request.getInputStream());
if(result.startsWith('{'))
  result='['+result+']';//to Array
var i, r=Wb.decode(result);
for(i in r){
  r[i].HANDCOST_TP_L_ID=java.util.UUID.randomUUID();
}
r=Wb.encode(r);
request.setAttribute('returns',r);
request.setAttribute('rows',r);


//浮点数乘法运算   
function FloatMul(arg1,arg2)    
{    
  var m=0,s1=arg1.toString(),s2=arg2.toString();    
  try{m+=s1.split(".")[1].length;}catch(e){}    
  try{m+=s2.split(".")[1].length;}catch(e){}    
  return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m) ;   
}
//浮点数加法运算   
function FloatAdd(arg1,arg2){   
  var r1,r2,m;   
  try{r1=arg1.toString().split(".")[1].length;}catch(e){r1=0;}   
  try{r2=arg2.toString().split(".")[1].length;}catch(e){r2=0;}   
  m=Math.pow(10,Math.max(r1,r2)); 
  //动态控制精度长度   
  n=(r1>=r2)?r1:r2;   
  return ((arg1*m+arg2*m)/m).toFixed(n);   
  //return (arg1*m+arg2*m)/m ;  
}  

//保留两位小数点
function floatParse(l_val){
  return (parseFloat(l_val).toFixed(2)+'').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
}


---本次报量数
var rowInfo = grid_plan_l.getSelectionModel().getSelection()[0];
var l_pro = rowInfo.get('PRO');
var l_val = (1/l_pro)*this.value;
l_val=(parseFloat(l_val).toFixed(2)+'').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
console.log(l_val);
rowInfo.set('L_PAPER_AMOUNT',l_val);
rowInfo.set('L_VAL',this.value);//L_VAL表示的是column


---物资调拨
//调拨数量
var t_amount_value= Wb.get('AMOUNT_VALUE').getValue();
var t_now_amount_value=Math.round(t_amount_value*Math.pow(10,10))/Math.pow(10,10);
var type_d_name=Wb.get('TYPE_D_NAME').getValue();

if(type_d_name !==''&& type_d_name !== null && type_d_name !== undefined){
       if(type_d_name.indexOf("调出")>0||type_d_name.indexOf("调入")>0){
            if(t_now_amount_value>0||t_now_amount_value==null||t_now_amount_value==''||t_now_amount_value=='undefined'){
	            Ext.MessageBox.alert('提示','调拨数量不能为空且一定要为负数！');
  	            return;
              }
        }
 
 
 ---NUMBER类型转换成string类型
        TO_CHAR((SELECT NVL(SUM(PL.PRE_L_VAL), 0)
                  FROM XSR_XZ_EX_PAY_PRE_L PL, XSR_XZ_EX_PAY_PRE_H PH
                 WHERE PL.PAY_PRE_H_ID = PH.PAY_PRE_H_ID
                   AND PH.AUDIT_STATUS = 'E'
                   AND PL.PAY_PRE_L_ID != L.PAY_PRE_L_ID),
                'FM999,999,999,999,990.00') AS ALREADY_PAID_SUM --已付款金额
				
				
---查询按钮
var code=Wb.get('text1').getValue();
Wb.load(storePayReqL,{code:code});
---sql语句中
WHERE PAY_TYPE_NAME LIKE '%{#name#}%'




----查询天然气组织下的用户和名字
SELECT DISTINCT
  a.USER_ID,
  a.USER_NAME,
  c.EMP_NAME 
FROM
  xip_pub_users a,
  xip_pub_emp_asg b,
  xip_pub_emps c 
WHERE a.EMP_ID = b.EMP_ID 
AND a.EMP_ID = c.EMP_ID 
and b.ORG_ID ='81c707e5-2fa2-4743-8bbc-46f7b830e9e0'


select * from xip_pub_orgs o where o.org_name like '%省天%'


---重置
Wb.reset(form_query2);
Wb.get('qryBtn2').fireEvent('click');//执行下查询按钮的click事件
Wb.get('CT_H_CODE_Q').reset();
Wb.load(store_select_h,{PRE_H_CODE:'',PRE_H_NAME:'',AUDIT_STATUS:''});

//重置查询表单
form_query.getForm().reset();

form1.getForm().reset();
Wb.load(store1,{qINV_H_CODE:qINV_H_CODE.value,
                qINV_H_NAME:qINV_H_NAME.value,
                qEX_TMP_NAME:qEX_TMP_NAME.value,
                qAUDIT_STATUS:qAUDIT_STATUS.value
                  });

---查询年、月份
select year
  from (select to_number(to_char(sysdate, 'yyyy')) - rownum year
          from dual
        connect by level <= 2
        union all
        select to_number(to_char(sysdate, 'yyyy')) year
          from dual
        union all
        select to_number(to_char(sysdate, 'yyyy')) + rownum year
          from dual
        connect by level <= 2)
 order by year;
 
 ---12月份
 select lpad(level,2,0) month from dual connect by level<13

 
 --上一年和本年
 var n;
 select sysdate ,sysdate-interval'1' year from dual
 select sysdate ,sysdate+interval'n' year from dual;/*查询本年和未来n年*/
 
---在润乾数据集sql
 and substr(to_char(H.SMRPT_DATE, 'yyyy-mm-dd'), 0, 4) LIKE
       '%' || nvl(?, to_char(sysdate, 'YYYY')) || '%'
 and (? like '%' || P.PRJ_ID || '%'
        or P.PRJ_ID like '%' || ? || '%')--项目名称多选

--拼接sql：
SELECT SYSDATE || '|' ||USER FROM DUAL;
SELECT CONCAT(SYSDATE|| '|',USER) FROM DUAL;		
		
---获取字符串中含有%前面的数字
 (TO_NUMBER((SELECT TRANSLATE(V.VALUE_NAME, '%', ' ')
                    FROM XSR_XZ_BA_LKP_VALUE V, XSR_XZ_CT_PLAN_H PH
                   WHERE V.LOOKUP_TYPE = 'PA_PAYMENT_PROPORTION'
                     AND V.VALUES_ID = PH.PAYMENT_PRO_ID
                     AND PH.PLAN_H_ID =
                         '6375a22b-39e8-4756-b6a4-eb904c7e1848')) * 0.01)
						 
						 
app.smrpt_l_grid.store.each(function(record){ //函数grid.store.each(record))相当于一个for循环，遍历整个record

  if(record.get('PROGRESS_DATE')==='' || record.get('PROGRESS_DATE')===null){
    Ext.MessageBox.alert('提示','进展日期不能为空');
    return;
  }
 });
 
 
 
 //浮点数加法运算   
function FloatAdd(arg1,arg2){   
    var r1,r2,m;   
    try{r1=arg1.toString().split(".")[1].length;}catch(e){r1=0;}   
    try{r2=arg2.toString().split(".")[1].length;}catch(e){r2=0;}   
    m=Math.pow(10,Math.max(r1,r2));   
    return (arg1*m+arg2*m)/m; 
}

Wb.get('save11').fireEvent('click');//执行下查询按钮的click事件

---两种获取值 start
Wb.request({
    url:'main?xwl=244V4BHA1DB5',  //
  	params:{'INTAX_H_ID':intax_h_id},
    async:false,  //设为同步
    success:function(r){   	
		var re=eval('['+r.responseText+']');
      	var c=re[0].rows[0];
        intax_h_code = c.INTAX_H_CODE;
        intax_h_name = c.INTAX_H_NAME;
      	org_id=c.ORG_ID;
      	att_count=c.ATT_COUNT;
    
    }
});

var record = grid_intax_h.getSelectionModel().getSelection();
var index_h_id = record[0].get('INTAX_H_ID'); //进项税ID
var operation_status = record[0].get('OPERATION_STATUS');//状态：NOR原单；RED红冲原单；
var index_par_h_id = record[0].get('INTAX_PAR_H_ID');//进项税父ID   
var index_type = record[0].get('INTAX_TYPE');//进项税类型('OUT',出库;'PLAN'报量)

---两种获取值 end


audit_inputTax_grid.store.each(function(record){ //函数grid.store.each(record))相当于一个for循环，遍历整个record
  
  	if(record.get('HKONT')==='2221010100'){
  		if(record.get('MWSKZ')==='' || record.get('MWSKZ')===null){
        	Ext.MessageBox.alert('提示','应交税费-应交增值税-进项税额,ERP税码不能为空');
          
        	return fn;
        }
    }   
   if(record.get('HKONT')==='2221010800'){
  		if(record.get('MWSKZ')==='' || record.get('MWSKZ')===null){
        	Ext.MessageBox.alert('提示','应交税费-应交增值税-进项税额转出,ERP税码不能为空');
          
        	return fn;
        }
    } 

});
if(is_first==true)
{
	is_first='Y';
}
else
{
	is_first='N';
}

---更新语句
	update_out_h_ajax.request(
      dateItemToStr(Ext.apply(
            Ext.apply({},
              Wb.getValue(form),
                Wb.getValue(form.output)),
            Wb.getValue(form.output))
        ));

ajax_update_out_l.request({
      'OUT_L_ID':t_out_l_id,
      'OUTQTY':t_outqty,
      'TSK_ID':t_tsk_id,
      'BG_ITEM_ID':t_bg_item_id,
      'BG_FARE_ID':t_bg_fare_id,
      'REQ_BUDGETPRICE':t_reqPrice,
      'REQ_BUDGETAMOUNT':t_reqAmount
    });

 ---查看某个表中流程id
select * from XSR_XZ_GL_SAP_INTERFACE_H h where h.ins_code = 
(select t.instance_code from XIP_WF_INS_TASK t where t.task_id = 'a49245ce-4feb-4f44-9e43-a9177a7ebbcc')

---光伏-集团正式
10.154.71.47(集团4.0新)
IP：10.154.200.204 
用户名称：fmis04@root@10.154.71.47
密码：vMIqyNbQ

"C:\fakepath\QQ图片20180130212323.png"


VPS:
You will need a new root password to access your VPS: 
vp04uM2ku8n2
	65.49.225.77
New SSH Port: 
26897

 ShadowsocksR账号 配置信息：


 ShadowsocksR账号 配置信息：

 I  P	    : 65.49.225.77
 端口	    : 1123
 密码	    : ttdx.com.cn
 加密	    : aes-192-ctr
 协议	    : auth_sha1_v4_compatible
 混淆	    : plain
 设备数限制 : 0(无限)
 单线程限速 : 0 KB/S
 端口总限速 : 0 KB/S
 SS    链接 : ss://YWVzLTE5Mi1jdHI6dHRkeC5jb20uY25ANjUuNDkuMjI1Ljc3OjExMjM 
 SS  二维码 : http://doub.pw/qr/qr.php?text=ss://YWVzLTE5Mi1jdHI6dHRkeC5jb20uY25ANjUuNDkuMjI1Ljc3OjExMjM
 SSR   链接 : ssr://NjUuNDkuMjI1Ljc3OjExMjM6YXV0aF9zaGExX3Y0OmFlcy0xOTItY3RyOnBsYWluOmRIUmtlQzVqYjIwdVkyNA 
 SSR 二维码 : http://doub.pw/qr/qr.php?text=ssr://NjUuNDkuMjI1Ljc3OjExMjM6YXV0aF9zaGExX3Y0OmFlcy0xOTItY3RyOnBsYWluOmRIUmtlQzVqYjIwdVkyNA 
 
  提示: 
 在浏览器中，打开二维码链接，就可以看到二维码图片。
 协议和混淆后面的[ _compatible ]，指的是 兼容原版协议/混淆。


ftp账号密码
10.154.200.204
fmis04@root@10.154.97.3

通过堡垒主机访问维护	
https://10.154.200.204/cgi-bh/login.cgi 
账号：fmis04 	vMIqyNbQ/XZsoft2017

1zUAmvIp


服务器地址：https://115.239.233.218:4435
账号：pmis2
密码：Bhrd2020*


集团文档密码 ssh账号密码
1qaz2WSX3edc
8mvIpAUz
pmisdoc密码
http://10.154.71.56:8086/xzamssh/attachment//ZNXSFD/CXDMGF/PM/PTS_PM_EB_KB1/4c61ecf4-479e-4124-9b64-23ab5f7098d0.pdf


阿克苏VPN 
https://222.80.140.21:6443
xingzhu
XINGZHU@123456

可再生项目VPN（可以登录可再生、光伏系统）
https://202.101.160.106
账号：pmisuser01
密码：pmis！
账号：JXFD
密码：Jxfd01!


ar ttDate = "2013年12月20日 14:20:20"; 
ttDate = ttDate.replace(/[^0-9]/mg, '').match(/.{8}/); 
alert(ttDate);

20131220

var ttDate = "2013年12月20日 14:20:20";  
ttDate = ttDate.match(/\d{4}.\d{1,2}.\d{1,2}/mg).toString();  
ttDate = ttDate.replace(/[^0-9]/mg, '-');  
alert(ttDate); 

2013-12-20 

var ttDate = "2013年12月20日 14:20:20";  
 
ttDate = ttDate.replace(/(\d{4}).(\d{1,2}).(\d{1,2}).+/mg, '$1-$2-$3'); 
alert(ttDate); 
2013-12-20 

生产环境	PMIS正式环境应用服务器	10.154.71.47 

生产环境	PMIS正式环境数据库服务器	10.154.71.48 

生产环境	PMIS正式环境文档服务器	10.154.71.56 

生产环境	PMIS电力股份应用	10.154.71.57 

生产环境	PMIS电力股份数据库	10.154.71.58 

测试环境	PMIS测试环境服务器	10.154.97.3 
--end

XSR_XZ_UPLOAD_TO_JT_PKG.upLoadpmUnitToJT('znjtpm','LK_TO_JT.ZHENERGY.COM.CN');

--查询登录密码
select PASSWORD from XIP_PUB_USERS where USER_NAME ='ZHOUJINJUN';
SELECT *
  FROM XIP_PUB_USERS B, XIP_PUB_EMPS C
 WHERE B.EMP_ID = C.EMP_ID
   AND (C.EMP_NAME = '周青山' OR B.USER_NAME = 'XULEI2')
   
   
---默认组织SQL
SELECT D.DEPT_ID, D.DEPT_NAME, O.ORG_ID, O.ORG_NAME
  FROM XIP_PUB_EMP_ASG           A,
       XIP_PUB_DEPTS             D,
       XSR_XZ_BA_ORG_PRJ_DEFAULT PD,
       XIP_PUB_ORGS              O,
       XIP_PUB_EMPS              E
 WHERE A.DEPT_ID = D.DEPT_ID
   AND PD.ORG_ID = O.ORG_ID
   AND D.ORG_ID = O.ORG_ID
   AND A.EMP_ID = E.EMP_ID
   AND PD.USER_ID = '{#XIP.userId#}'
   AND E.EMP_ID = (SELECT U.EMP_ID
                     FROM XIP_PUB_USERS U
                    WHERE U.USER_ID = '{#XIP.userId#}')
---默认项目
SELECT D.PRJ_ID,
       (SELECT P.PRJ_NAME FROM XSR_XZ_PM_PRJ_ALL P WHERE P.PRJ_ID = D.PRJ_ID) PRJ_NAME
  FROM XSR_XZ_BA_ORG_PRJ_DEFAULT D
 WHERE D.CREATED_BY = '{#XIP.userId#}'--{?XIP.userId?}
   AND D.ORG_ID = '{#id#}'--{?id?}
   
 //默认项目
//var vSql=" select d.prj_id,(select p.prj_name from xsr_xz_pm_prj_all p where p.prj_id = d.prj_id) prj_name "+
//"from xsr_xz_ba_org_prj_default d where d.CREATED_BY ='{#XIP.userId#}'  and d.org_id ='"+org_id+"'"; 
var vSql=" select p.prj_id,p.prj_name "+
"from xsr_xz_ba_org_prj_default d,xsr_xz_pm_prj_all p  where p.prj_id = d.prj_id /*and p.STATUS='0'*/ and d.CREATED_BY ='{#XIP.userId#}'  and d.org_id ='"+org_id+"'"; 
//console.log(vSql);
var prj_id=xzDbSqlQuery(vSql).PRJ_ID;
var prj_name=xzDbSqlQuery(vSql).PRJ_NAME;
//alert(prj_name+prj_id);
Wb.get('PRJ_ID').setValue(prj_id);
Wb.get('PRJ_NAME').setValue(prj_name);
Wb.get('INV_TYPE_NAME').setValue(ex_tmp_name);
Wb.get('INV_H_ID').setValue(inv_h_id);
Wb.get('ORG_ID').setValue(org_id);
   
 //默认组织
var vSql1="SELECT D.DEPT_ID,D.DEPT_NAME,O.ORG_ID,O.ORG_NAME FROM XIP_PUB_EMP_ASG A,XIP_PUB_DEPTS D,XSR_XZ_BA_ORG_PRJ_DEFAULT PD,XIP_PUB_ORGS O,XIP_PUB_EMPS E WHERE A.DEPT_ID=D.DEPT_ID AND PD.ORG_ID=O.ORG_ID AND D.ORG_ID=O.ORG_ID AND A.EMP_ID=E.EMP_ID AND PD.USER_ID='{#XIP.userId#}' AND E.EMP_ID=(SELECT U.EMP_ID FROM XIP_PUB_USERS U WHERE U.USER_ID = '{#XIP.userId#}')";
var t_rowInfo=xzDbSqlQuery(vSql1);
var org_id=t_rowInfo.ORG_ID;
var org_name=t_rowInfo.ORG_NAME;
var dept_id=t_rowInfo.DEPT_ID;
var dept_name=t_rowInfo.DEPT_NAME;
Wb.get('ORGANIZATION_ID').setValue(org_id);
Wb.get('ORGANIZATION_NAME').setValue(org_name);
//Wb.get('DEPARTMENT_NAME').setValue(dept_name);
//Wb.get('DEPARTMENT_ID').setValue(dept_id);
//默认项目
var sql_prj ="select p.prj_id,p.prj_name,p.prj_code from xsr_xz_ba_org_prj_default d ,xsr_xz_pm_prj_all p " +
"where d.user_id={?XIP.userId?} and d.prj_id = p.prj_id " ;
var t_rowInfo=xzDbSqlQuery(sql_prj);
var id = t_rowInfo.PRJ_ID;
var name = t_rowInfo.PRJ_NAME;
var code = t_rowInfo.PRJ_CODE;
Wb.get('PRJECT_ID').setValue(id);
Wb.get('PRJECT_NAME').setValue(name);
   
--Oracle用户解锁
sqlplus / as sysdba
alter user scott account unlock;
alter user scott identified by tiger;

--迁移数据库

--1.登录
sqlplus / as sysdba

--2.删除用户和表空间
drop tablespace nsName including contents and datafiles cascade constraints ;
drop user bhpm cascade;
--3、创建用户
create user bhpm identified by bhpm default tablespace XIP_DATA

--4、分配用户权限
grant connect,resource,dba to bhpm;

select * from v$nls_parameters;


--17、linux导入导出dmp文件
--设置CRT编码，在oracle用户下
windows：set NLS_LANG=AMERICAN_AMERICA.UTF8
linux ：export NLS_LANG=AMERICAN_AMERICA.UTF8

export LC_ALL="zh_CN.UTF-8"
export LANG="zh_CN.UTF-8"

export LC_ALL="zh_CN.GBK"
export LANG="zh_CN.GBK"

exp znpm/znpm@orcl owner=znpm file=/u01/oracle/dmp/znpmdb.dmp
imp bhpm/bhpm@orcl fromuser=znpm touser=bhpm file=/u01/oracle/dmp/znpmdb.dmp ignore=y
imp bhpm/bhpm@10.150.75.156/orcl fromuser=bhpm touser=bhpm file=/u01/oracle/dmp/bhpmdb1.dmp ignore=y

--终止imp/exp的方法
ps -ef |grep imp  找到对应进程   查询到pid，kill -9 pid
SELECT 'ALTER SYSTEM KILL SESSION '||''''||SID||''''||','||''''||SERIAL#||''''||';' as KILLER FROM V$SESSION WHERE USERNAME='BHPM';


select sid,serial# from v$session where username='BHPM';
alter system kill session 'serial#, sid ';

   
---正则表达式
select * from xip_pub_atts a where a.att_file_name like '%:\%';


bhpm
gEKrdmyyx8bgLNiEMssQcOR2rl2a9CkpibCXuaewuP10lurznFFlmQrgftl0KG3PyZ4F2BoSqU2Pfhhx9bnzOA==

znpm
AwLu7z3Ohgkrd6b2/+wJ/qwFVIGYPkSTACnQ+3alwgt1cnZ03FMEnFvrxy09NXaeX1Ei5n0UbTx2RbTFbBuSFQ==


UPDATE xip_pub_atts A
   SET a.att_file_name = regexp_substr(att_file_name,
                                       '([^<>/\\\|:""\*\?]+\.\w+$)')
 where a.att_file_name like '%:\%'
   

//获取该工程在服务器端的绝对路径
var physicsPath = request.getSession().getServletContext().getRealPath("/").replace("\\", "/");

//获取该工程在服务器端的虚拟路径
var path = request.getContextPath();
var virtualPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
request.setAttribute('physicsPath',physicsPath);
request.setAttribute('virtualPath',virtualPath);
   
AND EXISTS (SELECT D.PRJ_ID
            FROM XSR_XZ_BA_ORG_PRJ_DEFAULT D
            WHERE D.USER_ID = {?XIP.userId?}
            AND D.PRJ_ID=H.PRJECT_ID)

    (select wmsys.wm_concat(nvl((select c.emp_name
                     from xip_pub_users b,
                          xip_pub_emps  c
                    where b.emp_id=c.emp_id
                          and b.user_id = a.execute_user),
                   a.execute_user)) emp_name
          From xip_wf_ins_task a
         where a.instance_id in
               (select w.instance_id from xip_wf_process_instance w
                          where w.instance_code=P.INS_CODE)--单据工作流id
                and a.task_state='open'
         ) AUDIT_MAN, --待审批人-- 
		 
select c.emp_name,C.EMP_CODE
  from xip_pub_users b, xip_pub_emps c, xip_wf_ins_task a
 where b.emp_id = c.emp_id
   and b.user_id = a.execute_user
			
---启动验收发布按钮
xsr_xz_pm_pkg.SETSTATUSACCEPTFORINTERFACE

---审核备案启动按钮---插入中间表(内部审查纪要、外部审查纪要)
xsr_xz_pm_pkg.wf_pm_shba_start


-- 发票编码 JLW16-043_FP  05546427
---付款编码 FK-JLW16-043-001 FK-JLW16-043-002


---COMPANY_NAME_ED.beforequery  start
var rowInfo = grid1.getSelectionModel().getSelection()[0];
var com_name=rowInfo.get('COMPANY_NAME');
Wb.load(com_store,{SAP_DEP_NAME:com_name});
---COMPANY_NAME_ED.beforequery  end


---COMPANY_NAME_ED.change  start
var rowInfo = grid1.getSelectionModel().getSelection()[0];
var t_com_name_sql="SELECT DISTINCT SAP_DEP_ID CODE, /*公司代码*/SAP_DEP_NAME NAME  /*公司名称*/  FROM XSR_XZ_PM_PRJ_ALL WHERE SAP_DEP_ID IS NOT NULL AND SAP_DEP_NAME IS NOT NULL AND SAP_DEP_NAME='"+this.value+"'";
var t_rowInfo = xzDbSqlQuery(t_com_name_sql);
var com_code=t_rowInfo.CODE;
rowInfo.set('COMPANY_CODE',com_code);
---COMPANY_NAME_ED.change  end


---pickList
[['Y','已发布'],['N','未发布']]

--renderer
if(value ==='Y'){
  return '是';
}if(value ==='N'){
  return '否';
}


xzUuid();



公网:
	IP：http://182.18.19.153/ 

   
	CRT用户名/密码:xzecs/xz2015
   

海外项目：http://182.18.19.153:8010/hwpm 

 
登陆用户：admin/xzsoft
后台登陆crt地址：root/XZsoft2015
xzecs/xz2015 


vpn：
https://vpn.zjenergy.com.cn
用户密码:pmis/5oi0MyeT


XSR_XZ_SAP_PAY_RECORD---付款指令表
request.setAttribute('PRJ_YEAR',DateUtil.formatDate(new Date(), "yyyy"));


---所属公司编码
var company_Sql="select t.sap_dep_id as re from XSR_XZ_FSSC_PM_PRJ_ALL t where t.PRJ_ID='"+prj_id+"'";
var company_code = xzDbSqlReSingle(company_Sql);
XSR_XZ_FSSC_PM_PRJ_ALL(项目信息中间表(共享平台))


---鼠标弹出 start
metaData.tdAttr = 'data-qtip="'+value+'"';
return value;
----end 


http://gastestpm.zhenergy.com.cn:8089/znpm/upgrade.jsp    ----查看平台版本

/*XSR_XZ_CT_H_V视图改成实际表名XSR_XZ_CT_H*/ XSR_XZ_CT_H H,XIP_PUB_ORGS  B

----建立索引
 --1)工程管理编辑
XIP_PUB_ATTS  --INDEX_XIP_PUB_ATTS(列SRC_ID)
XSR_XZ_CT_PLAN_L   ----INDEX_XSR_XZ_CT_PLAN_L(列plan_h_id)
XSR_XZ_CT_PLAN_H   ----INDEX_XSR_XZ_CT_PLAN_H(列ct_h_id)
XIP_WF_INS_TASK    ----INDEX_XIP_WF_INS_TASK(列instance_id)
 --2)发票管理编辑
   /*视图转换成实际表*/
 --3)实际付款
XSR_XZ_EX_PAY_FACT  ---INDEX_XSR_XZ_EX_PAY_FACT(列PAY_REQ_H_ID)

 --4)入库管理编辑中合同编码
XSR_XZ_CT_D  ---INDEX_XSR_XZ_CT_D(列CT_H_ID)
XSR_XZ_MT_IN_L ---INDEX_XSR_XZ_MT_IN_L(列CT_H_ID)

---稽核功能的浏览页面(工程报量)
IN_XSR_XZ_GL_SAP_INTERFACE_H  ---IN_XSR_XZ_GL_SAP_INTERFACE_H(列BUS_H_ID)
---发票稽核
XSR_XZ_PM_PRJ_EMP   ---INDEX_XSR_XZ_PM_PRJ_EMP(列EMP_ID, PRJ_ID, CREATION_DATE)


---稽核功能的稽核界面
XSR_XZ_BA_SAP_CODE_COMB  ---INDEX_XSR_XZ_BA_SAP_CODE_COMB(列COMBINATION_CODE)
XSR_XZ_GL_SAP_INTERFACE_L--(总账表的业务表)   ---IND_XSR_XZ_GL_SAP_INTERFACE_L(列ZXH)


----合同管理/综合查询/综合物资
XSR_XZ_MT_OUT_H  表中OUT_H_ID
XSR_XZ_MT_DATA_L表中PAR_UOM_ID


---<注意> 不能再创建索引(TABLE ACCESS FULL)
XSR_XZ_CT_H
XSR_XZ_CT_PLAN_L

--PMIS 费用查询
XSR_XZ_CT_D  ---INDEX_XSR_XZ_CT_D(列CT_H_ID, CT_L_ID)
XSR_XZ_MT_OUT_L ---INDEX_XSR_XZ_MT_OUT_L(列OUT_H_ID)


XSR_XZ_PMT_HANDCOST_H	----INDEX_XSR_XZ_PMT_HANDCOST_H(BUS_TYPE)
(无效果)XSR_XZ_PMT_HANDCOST_L   ----INDEX_XSR_XZ_PMT_HANDCOST_L(HANDCOST_H_ID)

XSR_XZ_PM_PRJ_TSK  ----INDEX_XSR_XZ_PM_PRJ_TSK(TSK_FULL_CODE)

1)
---在启动流程按钮中
    /*UPDATE JQH 20180313 FOR 启动流程后load所启动的这条数据 start*/
    Wb.get('STATUS_CATEGORY').setValue('');
    Wb.get('Q_PAY_REQ_H_ID').setValue(re[0].PAY_REQ_H_ID);
    /*UPDATE JQH 20180313 FOR 启动流程后load所启动的这条数据 end*/    
	
---在SQL语句中
AND P.PAY_REQ_H_ID=NVL({?Q_PAY_REQ_H_ID?}, P.PAY_REQ_H_ID)/*UPDATE JQH 201810313 FOR 启动流程后load所启动的这条数据 */   

---新建一个数值载体  Q_PAY_REQ_H_ID
  
---在一开始加载功能的时候,执行的js文件中 加载sql语句中的参数值  比如:{?Q_PAY_REQ_H_ID?} 在此
function formQuery(){
	var q_plan_code = Wb.get('Q_PLAN_H_CODE').getValue();
	var q_plan_name = Wb.get('Q_PLAN_H_NAME').getValue();
  	var q_status_name = Wb.get('Q_STATUS_NAME').getValue();
  	var q_ct_name = Wb.get('Q_CT_NAME').getValue();
  	var q_ct_code = Wb.get('Q_CT_CODE').getValue();
    var q_temp = Wb.get('Q_TEMP').getValue();
    var q_plan_h_id=Wb.get('Q_PLAN_H_ID').getValue();/*UPDATE JQH 201810313 FOR 启动流程后load所启动的这条数据 */
  	Wb.load(Query_Contract_Info_Store,{
      	plan_h_code:q_plan_code,
      	plan_h_name:q_plan_name,
      	status_name:q_status_name,
      	ct_h_name:q_ct_name,
      	ct_h_code:q_ct_code,
        PLAN_TMP_NAME:q_temp,
        PLAN_H_ID:q_plan_h_id/*UPDATE JQH 201810313 FOR 启动流程后load所启动的这条数据 */
      /*其中PLAN_H_ID 表示在sql语句中{?PLAN_H_ID?} 的PLAN_H_ID*/
    });
}

2)   
/*UPDATE JQH 20180313 START*/
var in_no_sql="select (xsr_xz_ct_pkg.F_AUTO_CODE('"+record.get('CT_H_ID')+"','RK'))as re from dual";
var t_in_no=xzDbSqlReSingle(in_no_sql);
Wb.get('IN_NO').setValue(t_in_no);
/*UPDATE JQH 20180313 END*/

/*,(xsr_xz_ct_pkg.F_AUTO_CODE(h.CT_H_ID,'RK'))as in_no*//*UPDATE JQH 注销掉 改成当选择合同编码时才生成 20180313*/

---入库..报量..外部出库 编辑页面下拉选择合同编码
---<注> 原先的视图修改成实际表中查看数据



---四张报表
XSR_XZ_PA_PKG.UPDATE_PROJECT_TSK


①---枣泉各项数据统计 
  ---项目单位自评中 项目id添加
select *
  from xsr_xz_pm_doc_m@LK_TO_JT.ZHENERGY.COM.CN h
  where h.doc_name='宁夏枣泉发电有限责任公司2017年基建工作总结及考核表' for update


②----项目公司整改
  
  --涉及到的job
select *
  from dba_jobs  j where j.WHAT like '%LK_TO_JT.ZHENERGY.COM.CN%'

 ---然后涉及存储过程	项目公司自查
XSR_XZ_CHECK_PKG.download_pm_rectify_from_jt('znjtpm','LK_TO_JT.ZHENERGY.COM.CN');

--集团检查---下发到项目层---上传到集团
XSR_XZ_CHECK_PKG.download_pm_rectify_from_jt('znjtpm','LK_TO_JT.ZHENERGY.COM.CN');

--项目层检查--上传到集团


---项目单位整改审批通过写入历史表
XSR_XZ_CHECK_PKG.wf_rectify_h_end('znjtpm','LK_TO_JT.ZHENERGY.COM.CN');

--菜单注册数据库:
select *
  from xip_pub_fun_tree t
 where /*fun_tree_name like '%工程审计%'
   and*/ URL LIKE '%2435TD27EDPF%'
   for update


联系单编码
     var vSql1="select TO_CHAR(h.LOOKUP_CODE) as re from XSR_XZ_BA_LKP_VALUE h where h.LOOKUP_TYPE = 'PTS_PM_LXD_GC' and h.VALUE_NAME like '"+PRJECT_NAME+"%'" ;
     code_no=xzDbSqlReSingle(vSql1);
	 var code_auto2=code_no+'-'+PROPOSED_UNIT_CODE+'-'+FILE_TYPE_CODE+'-'+SPECIALTY_CODE+PROJECT_UNIT_CODE;
	  if(count<1)
     {
        v_serial_id='0001';
     }else{
        var vSqlNum="SELECT TO_CHAR(TO_NUMBER(SUBSTR(MAX(h.mainform_code), -3, 3)) + 1,'FM0000') as re FROM XSR_XZ_PM_REP_H h WHERE h.CATEGORY_CODE = 'PTS_PM_LXD_GC' AND h.mainform_code LIKE '"+code_auto2+"%'" ;
        v_serial_id=xzDbSqlReSingle(vSqlNum);
     }
	 var code=code_auto2+'-'+v_serial_id;
	 
	 ---转换成JSON
  var obj = eval('(' + resp + ')');
  

----定时任务 backup.sh
rq=`date +"%y%m%d"`
cd /u01/
tar -zcvf  /u01/backup/backup/prod.$rq.tar.gz  ./prod
#tar -zcvf  /u01/backup/backup/test.$rq.tar.gz  ./test
find /u01/backup/backup -mtime +5 -exec rm -rf {} \;
chmod -R 777 /u01/backup

  
----兴竹笔记
  defaultStore.sync(
    {
      callback :function(){
        Wb.unmask();
        Ext.MessageBox.alert('提示', '保存成功！');
      }
    });
  

XIP_PUB_APPS  ----平台应用表(各项目中的ip，端口，数据库名称以及密码)
XSR_XZ_PM_PRJ_ALL  ---项目表
DUAL----虚拟表(可以做任何事)

XSR_XZ_PM_ORG_STRUT_H ---镇海(新)项目组织结构树主表
XSR_XZ_PM_ORG_STRUT_L ---        项目组织结构树明细表

XIP_PUB_ORG_SEC ---组织授权表

XSR_XZ_CT_TYPE_D ---合同明细分类(明细类型)--基建调入基建、基建调出生产、基建调出基建、生产调入基建
XSR_XZ_CT_TYPE_H  ---合同模板表
XSR_XZ_CT_TYPE_L  ---合同类型行表


XSR_XZ_EX_INV_H  ---入库主表
XSR_XZ_EX_INV_L  ---入库明细表

XSR_XZ_MT_OUT_H --出库主信息
XSR_XZ_MT_OUT_L --出库行




XSR_XZ_BA_SAP_GL_TYPE   ---业务类型对照对照SAP接口

XSR_XZ_PM_PRJ_ALL       ----项目表
XIP_PUB_USERS   ---平台用户表


XIP_WF_ENTITIES ----业务实体管理表



---接口相关新增的中间表
XSR_XZ_FSSC_INS_TASK_H --流程待办主信息
XSR_XZ_FSSC_INS_TASK --流程待办信息   ----XIP_WF_INS_TASK (业务表)
XSR_XZ_FSSC_ARCH_TASK --流程履历信息

XSR_XZ_FSSC_OPER_INFOR --流转回调信息表
XSR_XZ_FSSC_KEY_INV_H --发票关键信息主表

XSR_XZ_FSSC_KEY_PAY_H --付款关键信息主表

---流程待办信息：在启动流程审批中的时候ins_code 进入业务表XIP_WF_INS_TASK(暂时性的)中，
---------而审批通过时候就会进入XSR_XZ_FSSC_INS_TASK(永久保存--审批中的时候还没有进入)


XSR_XZ_FSSC_KEY_L  --关键信息行表  发票付款进项税共用一个行表


XSR_XZ_FSSC_TSK_EX ---概算节点预算执行情况表(业务表)
XSR_XZ_PMIS_TSK_EX ---概算节点预算执行情况表-中间表(服务端)
--联行号：
XSR_XZ_FSSC_BANK
FsscBankInListVOMapper

----业务表
XSR_XZ_GL_SAP_INTERFACE_H --总账表
XSR_XZ_PMT_HANDCOST_H     ---手工成本主表


xsr_xz_bg_bus_dtl_bud_v  
XSR_XZ_BG_BUS_DTL ---BUS_VAL
SELECT BD.BUS_VAL FROM XSR_XZ_BG_BUS_DTL BD WHERE BD.ORG_ID= AND BD.PRJ_ID


XSR_XZ_BA_COM_ALL  ---单位表
XSR_XZ_PM_PRJ_ALL  ---项目表
XSR_XZ_BA_SAP_CODE_COMB  ---科目表/*-科目ID*/
XSR_XZ_PM_PRJ_TSK   ---项目任务表()/*-概算结构ID(任务)*/
XSR_XZ_BG_BUS_DTL  /*预算发生表(冗余)*/

XSR_XZ_MT_INV_BUS_DTL---库存表 SOURCE_L_ID 1)表示的是XSR_XZ_MT_IN_L中的IN_L_ID入库行id

XSR_XZ_BA_SAP_EBS_U_PKG  ---稽核的时候执行的存储过程

---集团
select a.value_name from XSR_XZ_BA_LKP_VALUE a where a.lookup_code=?

select a.main_id, a.doc_name, a.attribute5, a.report_date
  from xsr_xz_pm_doc_m a
 where a.project_id = ?
   and a.doc_code = ?
 order by a.create_date desc
 
select d.prj_name from XSR_XZ_PM_PRJ_ALL d where d.prj_id = ?
 --3482874 --公用(prj_id、project_id)
 
 --PTS_PM_EPP_CS2_PDR2_NEW---外部(lookup_code、doc_code)
 
 ---内部
 --PTS_PM_EPP_CS2_PDR1_NEW ---内部

---查看下一节点
select t.task_id,t.act_name
from XIP_WF_INS_TASK t
where
t.creation_date =
(select max(tt.creation_date)
from XIP_WF_INS_TASK tt
where tt.instance_code = t.instance_code)
and t.instance_code = (select
ttt.instance_code
from XIP_WF_INS_TASK ttt
where ttt.task_id='31b3b9e0-8ab6-48fd-84cf-adf5831740fb')



var r_p_h_id = getParame('REQ_PLAN_ID');
var r_p_source = getParame('REQ_PLAN_SOURCE');
var code;
var data_temp;
if(status == 'edit' || status =='view'){
  if(r_p_h_id !== null && r_p_h_id !== ''){
  	  //访问连接 ajax获取数据		
  Wb.request({url:'main?xwl=23XJMHP1N3PT',
              params:{'REQ_PLAN_ID':r_p_h_id},
              success:function(r){
                //解析返回值
                var re =eval('['+r.responseText+']');
                var temp=re[0].rows[0];
                //Wb.println(temp.CT_H_ID);
                /////////////////////////////存储
                data_temp=temp;
//                 console.log(data_temp);
                ////////////////////////////
                //退出编辑状态遮罩层
                Wb.unmask();
              },
              async:false,//异步
              timeout:10000000//毫秒
             });
  }
}else if(status == 'add'){
	code = '';
}


function isCited(param){
//定义数据集合
var data_temp = new Array(count);
var have_temp ='';
   //访问连接 ajax获取数据		
  Wb.request({url:'main?xwl=249459I04D8Z', //select_PRESET_L(导入预制凭证)
              params:{'PRESET_H_ID':param},
              success:function(r){
                //解析返回值
                var re =eval('['+r.responseText+']');
                var temp=re[0].rows[j];
                if(temp.EX_COUNT||temp.OH_COUNT||temp.DH_COUNT){
                  have_temp = 1;
                }
                /////////////////////////////存储
                data_temp[j]=temp;
                ////////////////////////////
                //退出编辑状态遮罩层
                Wb.unmask();
              },
              async:false,//异步
              timeout:10000000//毫秒
             });
}


---在grid配置文件中加:grid修改不出现红色三角标的设置tagProperties
viewConfig: {　　 
markDirty: false 
}


console.log(grid_type.plugins[0]);
console.log(Ext.getCmp('grid_type').getStore().getAt(0));
console.log(Ext.getCmp('grid_type').getStore().data.map);
console.log(grid_type.plugins[0].editors.keys);
var row = grid_type.getSelectionModel().getSelection();
console.log(row);



---查看银联号
SELECT *
  FROM (SELECT ROW_NUMBER() OVER(PARTITION BY F.CNAPSNO ORDER BY F.CREATE_DATE DESC) RN,
               F.*
          FROM XSR_XZ_FSSC_BANK F
          WHERE F.CNAPSNO IN())
 WHERE RN = 1
   AND (STATUS = 'I' OR STATUS = 'U')
   AND CNAPSNO = '403148800011'
   
SELECT ROW_NUMBER() OVER(PARTITION BY F.CNAPSNO ORDER BY F.CREATE_DATE DESC) RN,
       F.*
  FROM XSR_XZ_FSSC_BANK F
 WHERE F.CNAPSNO IN
       (SELECT K.CNAPSNO FROM XSR_XZ_FSSC_BANK K WHERE K.STATUS = 'D')
	   
	   
	   
exp bhpm/bhpm@orcl owner=bhpm file=/u01/oracle/dmp/bhpmdb.dmp

imp znpm/znpm@orcl fromuser=bhpm touser=znpm file=/u01/oracle/dmp/bhpmdb.dmp ignore=y


Failure to transfer org.codehaus.plexus:plexus-interpolation:jar:1.15
pengliang1590人评论2208人阅读2015-06-21 08:42:35
eclipse maven项目错误：Failure to transfer org.codehaus.plexus:plexus-interpolation:jar:1.15 from http://repo.maven.apache.org/maven2 was cached in the local repository, resolution will not be reattempted until the update interval of central has elapsed or updates are forced. Original error: Could not transfer artifact org.codehaus.plexus:plexus-interpolation:jar:1.15 from/to central (http://repo.maven.apache.org/maven2): The operation was cancelled.pom.xml



解决办法：删除掉下载失败的jar

find ~/.m2 -name "*.lastUpdated" -exec grep -q "Could not transfer" {} \; -print -exec rm {} \;

windows下：

cd %userprofile%\.m2\repository 

for /r %i in (*.lastUpdated) do del %i

然后在项目中右键选择 Maven->UpdateDependencies.

或者右键：Maven -> Disable maven nature

然后右键：Configure > Convert to maven Project




slmgr /ipk NKJFK-GPHP7-G8C3J-P6JXR-HQRJR
slmgr /skms kms.xspace.in
slmgr /ato




slmgr.vbs -xpr
slmgr.vbs -dlv



iconv -c -f gbk -t utf-8 $data_path/$item_uv


echo "export LANG="en_US.UTF-8"  >> /etc/proflile
echo "export LANG="zh_CN.GBK"  >> /etc/proflile



./configure --prefix=/usr/share/zwman --disable-zhtw && make && make install
echo "alias cman='man -M /usr/share/zwman/share/man/zh_CN'" >> ~/.bash_profile	   


='<img SRC="'+ds2.B_EXECUTEUSERCODE+' " height=\"41\" onerror=\"javascript:this.src=\'./../reportFiles/PIC/NotFind.JPG\'\" >'
='<img SRC="'+ds2.B_EXECUTEUSERCODE+' " height=\"41\" onerror=\"javascript:this.src=\'./../reportFiles/PIC/NotFind.JPG\'\" >'
=NVL(ds2.select1(APPROVECOMMNET,ds2.ACTNAME=='造价咨询负责人'),ds2.select1(APPROVECOMMNET,ds2.ACTNAME=='造价咨询专业工程师'))



 select count(*) from v$process;----系统有多少连接数
 select value from v$parameter where name = 'processes';-------oracle设置中设置了多少连接数
 alter system set processes = 300 scope = spfile;------修改连接池数


 select b.owner,b.object_name,a.session_id,a.locked_mode 
  from v$locked_object a,dba_objects b
  where b.object_id = a.object_id;
  
  
select a.USERNAME,
       a.MACHINE,
       sql_text,
       'alter system kill session ''' || a.SID || ',' || a.SERIAL# || ',@' ||
       a.INST_ID || ''';',
       status
  from gV$session a
 inner join GV$sql b
    on a.sql_id = b.sql_id
 WHERE status = 'ACTIVE'
select count(*) from v$process;
 
select count(*) from v$session;
select max(pga_used_mem)// M from v$process; 
select min(pga_used_mem)// M from v$process where pga_used_mem>; 