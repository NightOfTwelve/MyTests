//
//  BTAlarm.h
//  DemoAlarm
//
//  Created by song on 12-12-21.
//  Copyright (c) 2012年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTAlarmNotifications.h"
#import "BTAlarmConstants.h"


@interface BTAlarm : NSObject
{
	NSTimer *_timer;			//内部使用的NSTimer
	EnumBTAlarmMode _mode;		//定时器模式
	EnumBTAlarmState _state;	//定时器状态
	NSUInteger _remains;		//剩余秒数(个数)
}

//定时器模式
@property(nonatomic,readonly) EnumBTAlarmMode mode;
//定时器状态
@property(nonatomic,readonly) EnumBTAlarmState state;
//剩余秒数(个数)
@property(nonatomic,readonly) NSUInteger remains;

//开始定时倒数
- (void)startTiming:(NSUInteger)seconds;
//开始定量倒数
- (void)startCounting:(NSUInteger)count;
//计数减1
- (void)decreaseCount;
//停止倒计时
- (void)stop;

//获得单例
+ (BTAlarm *)sharedInstance;
//销毁单例
+ (void)destorySharedInstance;

@end
