//
//  BTAlarmConstants.h
//  DemoAlarm
//
//  Created by Zero on 12/21/12.
//  Copyright (c) 2012 Zero. All rights reserved.
//

#define DICTIONARY_KEY_ALARM \
@"alarm.key.alarm"
#define KEY_ALARM_BUTTON_CLICKED_BUTTON \
@"alarm.key.button_clicked"

#define NOT_SELECTED ((NSInteger)9999)

//定时器模式
typedef NS_ENUM(NSUInteger, EnumBTAlarmMode) {
	eBTAlarmModeTiming,			//计时
	eBTAlarmModeCounting		//计数
};

//定时器状态
typedef NS_ENUM(NSUInteger, EnumBTAlarmState) {
	eBTAlarmStateInitialized,	//初始
	eBTAlarmStateRunning,		//倒计时中
	eBTAlarmStateFinished		//结束
};

