HIS 英文全称 Hospital Information System（医院信息系统），主要功能按照数据流量、流向及处理过程分为临床诊疗、药品管理、财务管理、患者管理。诊疗活动由各工作站配合完成，并将临床信息进行整理、处理、汇总、统计、分析等。本系统包括以下工作站：门诊医生工作站、药房医生工作站、医技医生工作站、收费员工作站、对帐员工作站、管理员工作站。基于 Spring Cloud Netflix 和 Spring Boot 2.x 实现
![[HIS架构图.png]]
## [前言](https://github.com/ZainZhao/HIS#%E5%89%8D%E8%A8%80)

HIS 项目致力于打造一个医疗系统demo

本仓库包含

|系统|描述|
|---|---|
|HIS-master|单体应用|
|his-cloud|分布式微服务应用|
|HIS-web|诊疗前端|
|HIS-app|患者前端|

`注：单体应用和分布式实现业务完全相同`

## [一. 项目架构](https://github.com/ZainZhao/HIS#%E4%B8%80-%E9%A1%B9%E7%9B%AE%E6%9E%B6%E6%9E%84)
![[HIS架构图.png]]

### [后端技术栈](https://github.com/ZainZhao/HIS#%E5%90%8E%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%A0%88)

|技术|版本|说明|
|---|---|---|
|Spring Cloud Netflix|Finchley.RELEASE|分布式全家桶|
|Spring Cloud Eureka|2.0.0.RELEASE|服务注册|
|Spring Cloud Zipkin|2.0.0.RELEASE|服务链路|
|Spring Cloud config|2.0.0.RELEASE|服务配置|
|Spring Cloud Feign|2.0.0.RELEASE|服务调用|
|Spring Cloud Zuul|2.0.0.RELEASE|服务网关|
|Spring Cloud Hystrix|2.0.0.RELEASE|服务熔断|
|Spring Cloud Turbine|2.0.0.RELEASE|服务熔断监控|
|Spring Boot Admin|2.0.1|服务监控|
|Spring Boot|2.0.3.RELEASE|容器+MVC框架|
|Spring Security|5.1.4.RELEASE|认证和授权框架|
|MyBatis|3.4.6|ORM框架|
|MyBatisGenerator|1.3.3|数据层代码生成|
|PageHelper|5.1.8|MyBatis物理分页插件|
|Maven|3.6.1|项目管理工具|
|Swagger2|2.7.0|交互式API文档|
|Elasticsearch|6.2.2|搜索引擎|
|kibana|6.2.2|数据分析和可视化平台|
|LogStash|6.2.2|数据采集引擎|
|RabbitMq|3.7.14|消息队列|
|Redis|3.2|缓存|
|Druid|1.1.10|数据库连接池|
|OSS|2.5.0|对象存储|
|JWT|0.9.1|跨域身份验证解决方案|
|Lombok|1.18.6|简化对象封装工具|
|Junit|4.12|单元测试框架|
|Logback|1.2.3|日志框架|
|Java doc|————|API帮助文档|
|Docker|18.09.6|应用容器引擎|
|Docker-compose|18.09.6|容器快速编排|

### [前端技术栈](https://github.com/ZainZhao/HIS#%E5%89%8D%E7%AB%AF%E6%8A%80%E6%9C%AF%E6%A0%88)

|技术|版本|说明|
|---|---|---|
|Vue|2.6.10|前端框架|
|Vue-router|3.0.2|前端路由框架|
|Vuex|3.1.0|vue状态管理组件|
|Vue-cli|————|Vue脚手架|
|Element-ui|2.7.0|前端UI框架|
|Echarts|4.2.1|数据可视化框架|
|Uni-app|————|跨平台前端框架|
|Mockjs|1.0.1-beta3|模拟后端数据|
|Axios|0.18.0|基于Promise的Http库|
|Js-cookie|2.2.0|Cookie组件|
|Jsonlint|1.6.3|Json解析组件|
|screenfull|4.2.0|全屏组件|
|Xlsx|0.14.1|Excel表导出组件|
|Webpack|————|模板打包器|

## [二. 项目展示](https://github.com/ZainZhao/HIS#%E4%BA%8C-%E9%A1%B9%E7%9B%AE%E5%B1%95%E7%A4%BA)

- 主页 [![主页](https://github.com/ZainZhao/HIS/raw/master/document/picture/PC-%E4%B8%BB%E9%A1%B5.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/PC-%E4%B8%BB%E9%A1%B5.png)
    
- 门诊医生工作台 [![门诊医生工作台](https://github.com/ZainZhao/HIS/raw/master/document/picture/PC-%E9%97%A8%E8%AF%8A%E5%8C%BB%E7%94%9F%E5%B7%A5%E4%BD%9C%E5%8F%B0-1.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/PC-%E9%97%A8%E8%AF%8A%E5%8C%BB%E7%94%9F%E5%B7%A5%E4%BD%9C%E5%8F%B0-1.png)
    
- 医技医生工作台 [![医技医生工作台](https://github.com/ZainZhao/HIS/raw/master/document/picture/PC-%E5%8C%BB%E6%8A%80%E5%8C%BB%E7%94%9F%E5%B7%A5%E4%BD%9C%E5%8F%B0-1.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/PC-%E5%8C%BB%E6%8A%80%E5%8C%BB%E7%94%9F%E5%B7%A5%E4%BD%9C%E5%8F%B0-1.png)
    
- 药房医生工作台 [![药房医生工作台](imag/药房医生工作台.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/PC-%E8%8D%AF%E6%88%BF%E5%8C%BB%E7%94%9F%E5%B7%A5%E4%BD%9C%E5%8F%B0-1.png)
    
- 收银员工作台 [![收银员工作台](https://github.com/ZainZhao/HIS/raw/master/document/picture/%E6%94%B6%E9%93%B6%E5%91%98%E5%B7%A5%E4%BD%9C%E5%8F%B0.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/%E6%94%B6%E9%93%B6%E5%91%98%E5%B7%A5%E4%BD%9C%E5%8F%B0.png)
    
- 对账员工作台 [![对账员工作台](https://github.com/ZainZhao/HIS/raw/master/document/picture/PC-%E6%97%A5%E7%BB%93-1.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/PC-%E6%97%A5%E7%BB%93-1.png)
    
- 病历模板 [![病历模板](https://github.com/ZainZhao/HIS/raw/master/document/picture/PC-%E7%97%85%E5%8E%86%E6%A8%A1%E6%9D%BF%E7%AE%A1%E7%90%86.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/PC-%E7%97%85%E5%8E%86%E6%A8%A1%E6%9D%BF%E7%AE%A1%E7%90%86.png)
    
- 排班管理 [![排班管理](https://github.com/ZainZhao/HIS/raw/master/document/picture/PC-%E6%8E%92%E7%8F%AD-1.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/PC-%E6%8E%92%E7%8F%AD-1.png)
    
- App挂号 [![App挂号](https://github.com/ZainZhao/HIS/raw/master/document/picture/APP-%E6%8C%82%E5%8F%B7-1.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/APP-%E6%8C%82%E5%8F%B7-1.png)
    
- Spring boot admin [![Spring boot admin](imag/Spring_boot_admin-1.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/admin-1.png)
    
- Spring boot admin [![Spring boot admin](imag/Spring_boot_admin.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/admin-2.png)
    
- ZinKin链路追踪 [![ZinKin链路追踪](imag/ZinKin链路追踪.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/ZinKin%E9%93%BE%E8%B7%AF%E8%BF%BD%E8%B8%AA.png)
    
- 分布式日志收集 [![分布式日志收集](https://github.com/ZainZhao/HIS/raw/master/document/picture/%E5%88%86%E5%B8%83%E5%BC%8F%E6%97%A5%E5%BF%97%E6%94%B6%E9%9B%86.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/%E5%88%86%E5%B8%83%E5%BC%8F%E6%97%A5%E5%BF%97%E6%94%B6%E9%9B%86.png)
    
- Hystrix dashboard [![Hystrix dashboard](https://github.com/ZainZhao/HIS/raw/master/document/picture/Hystrix-dashboard.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/Hystrix-dashboard.png)
    

## [三. 环境搭建](https://github.com/ZainZhao/HIS#%E4%B8%89-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)

### [开发工具](https://github.com/ZainZhao/HIS#%E5%BC%80%E5%8F%91%E5%B7%A5%E5%85%B7)

|工具|版本|说明|
|---|---|---|
|IDEA|2019.1.1|后端开发IDE|
|WebStorm|2019.1.1|前端开发IDE|
|Visual Studio Code|1.35.1|前端开发IDE|
|HbuilderX|V2.0.1|前端开发IDE|
|Git|2.21.0|代码托管平台|
|Google Chrome|75.0.3770.100|浏览器、前端调试工具|
|VMware Workstation Pro|14.1.3|虚拟机|
|PowerDesigner|15|数据库设计工具|
|Navicat|11.1.13|数据库连接工具|
|SQLyog|12.0.3|数据库连接工具|
|Visio|2013|时序图、流程图等绘制工具|
|ProcessOn|——|架构图等绘制工具|
|XMind ZEN|9.2.0|思维导图绘制工具|
|RedisDesktop|0.9.3.817|redis客户端连接工具|
|Postman|7.1.0|接口测试工具|

## [三. 业务需求](https://github.com/ZainZhao/HIS#%E4%B8%89-%E4%B8%9A%E5%8A%A1%E9%9C%80%E6%B1%82)

### [业务流程图](https://github.com/ZainZhao/HIS#%E4%B8%9A%E5%8A%A1%E6%B5%81%E7%A8%8B%E5%9B%BE)

[![项目开发进度图](https://github.com/ZainZhao/HIS/raw/master/document/picture/%E4%B8%9A%E5%8A%A1%E6%B5%81%E7%A8%8B%E5%9B%BE.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/%E4%B8%9A%E5%8A%A1%E6%B5%81%E7%A8%8B%E5%9B%BE.png)

## [需求](https://github.com/ZainZhao/HIS#%E9%9C%80%E6%B1%82)

[![项目开发进度图](https://github.com/ZainZhao/HIS/raw/master/document/picture/%E9%9C%80%E6%B1%82%E6%80%9D%E7%BB%B4%E5%9B%BE.png)](https://github.com/ZainZhao/HIS/blob/master/document/picture/%E9%9C%80%E6%B1%82%E6%80%9D%E7%BB%B4%E5%9B%BE.png)

