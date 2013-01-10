//
//  BTImportConstant.h
//  AABabyTing3
//
//  Created by Zero on 9/6/12.
//
//

#warning 发版本之前请一定检查此文件内的宏定义

//产品下载渠道标识
#define FROM_91						213000		//91手机助手
#define FROM_APP_STORE				213001		//苹果商店
#define FROM_SYNC					213002		//同步助手
#define FROM_PP						213003		//pp助手
#define DOWNLOAD_CHANNEL_FLAG		FROM_APP_STORE

//服务器地址选项
#define TEST_SERVER			2		//测试服务器
#define PREVIEW_SERVER		1		//预发布服务器
#define REGULAR_SERVER		0		//正式服务器
//测试服务器开关
#define CHECKIN_SERVER_LEVEL	PREVIEW_SERVER	//Checkin服务器
#define BABYSTORY_SERVER_LEVEL	PREVIEW_SERVER	//列表服务器（babystory）


//RQD上报开关
#define RQD_SWITCH					0		//RQD开关，0为关
#define CRASH_REPORT_SWITCH			0		//Crash报告开关，0为关


////下面内容不需要修改////

#if (CHECKIN_SERVER_LEVEL==TEST_SERVER)
#define DefaultServer_IP            @"http://10.3.51.251:10004"
#elif (CHECKIN_SERVER_LEVEL==PREVIEW_SERVER)
#define DefaultServer_IP            @"http://kphttp.cs0309.imtt.qq.com"
#else
#define DefaultServer_IP            @"http://kphttp.3g.qq.com"
#endif

#if (BABYSTORY_SERVER_LEVEL==TEST_SERVER)
#define REQUEST_SERVER_NAME         @"http://10.3.51.251:10002"
#elif (BABYSTORY_SERVER_LEVEL==PREVIEW_SERVER)
#define REQUEST_SERVER_NAME         @"http://mm.cs0309.imtt.qq.com"
#else
#define REQUEST_SERVER_NAME			@"http://kid.3g.qq.com:80"
#endif



