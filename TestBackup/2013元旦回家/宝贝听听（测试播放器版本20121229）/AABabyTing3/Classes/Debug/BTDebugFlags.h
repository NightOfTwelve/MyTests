//
//  BTDebugFlags.h
//  testLogLevel
//
//  Created by Zero on 9/18/12.
//  Copyright (c) 2012 21kunpeng. All rights reserved.
//



#ifndef __BTDEBUGFLAGS_H_1__
#define	__BTDEBUGFLAGS_H_1__

#ifdef DEBUG

#define	ZLog(...)	CDLog(BTDFLAG_AUDIOPLAYER20121231,__VA_ARGS__);			//Zero
#define NLog(...)	CDLog(Neoadd,__VA_ARGS__);						//Neo
#define TLog(...)	CDLog(BTDFLAG_DOWNLOAD,__VA_ARGS__);			//Tiny
#define DoLog(...)	CDLog(DoraSay,__VA_ARGS__);						//Dora

#else

#define ZLog(...)	((void)0)
#define NLog(...)	((void)0)
#define TLog(...)	((void)0)
#define DoLog(...)	((void)0)

#endif

#endif

/*
 * 某个模块的Log信息是否打印的标识位
 * 1打印，0不打印
 * 注：可以自己扩展一个模块，定义一个宏
 */

#ifndef __BTDEBUGFLAGS_H__
#define __BTDEBUGFLAGS_H__

//Common
#define BTDFLAG_SWITCH					1	//Log总开关：关闭此开关，所有Log均不打印
#define BTDFLAG_ALWAYS_PRINT			1	//打印错误使用，请勿关闭，请勿滥用 by Zero
#define BTDFLAG_DEFAULT					0
#define BTDFLAG_SERVICE_PRINT			0
#define BTDFLAG_SERVICE_CHECKIN_PRINT	0

//Zero
#define BTDFLAG_AUDIOPLAYER20121231		1
#define BTDFLAG_ALARM_CLOCK				0
#define BTDFLAG_AudioPlayerTest			0
#define	BTDFLAG_VIEWCONTROLLERS			0
#define BTDFLAG_BANNER					0
#define BTDFLAG_SPLASH					0
#define BTDFLAG_IPHONE5					0
#define BTDFLAG_CHECKIN					0
#define BTDFLAG_CountDown_PlayMode		0
#define BTDFLAG_CountDown_TimeHasSet	0
#define BTDFLAG_CountDown_Pause			0
#define BTDFLAG_Feedback				0
#define BTDFLAG_PlayedCountStatistics	0
#define BTDFLAG_AudioStreamer_Download	0
#define BTDFLAG_AudioStreamer_Download2	0
#define BTDFLAG_SetRootViewcontroller	0
#define BTDFLAG_Splash_And_Banner		0
#define BTDFLAG_Next_Button_Play_Story	0
#define BTDFLAG_AboutView				0
#define BTDFLAG_AudioStreamer			0
#define BTDFLAG_PlayedCount312			0
#define	BTDFLAG_TEA_CRYPT				0
#define BTDFLAG_KPLABEL					0
#define BTDFLAG_RANKLIST				0
#define BTDFLAG_RANKLIST_BUG			0
#define BTDFLAG_NEW_FEEDBACK			0
#define BTDFLAG_NEW_BANNER				0
#define	BTDFLAG_NEW_TEA_CRYPT			0
#define	BTDFLAG_SERVICE_TEST			0

//Bird
#define BTDFLAG_PLAYER					0

//Neo
#define Neoadd							0
#define NeoRankList                     0
#define NeoPlayViewCache                0

//Tiny
#define BTDFLAG_DOWNLOAD                0
#define BTDFLAG_PRESS_PLAYING_CRASH     0
#define BTDFLAG_ADD_STATUS_BAR          0
#define BTDFLAG_RADIO_TIMER             0
#define BTDFLAG_CATEGORY_NAME_DISAPPEAR 0
#define BTDFLAG_SINA_SHARE_ERROR        0
#define BTDFLAG_NEW_FLAG                0
#define BTDFLAG_316_PROTOCAL            0
#define BTDFLAG_LOCAL_SORT              0
#define BTDFLAG_RENREN_SHARE            0

//Dora
#define BTDFLAG_DOUBLESPLASH            0 
#define DoraSay                         0
//Others

#endif