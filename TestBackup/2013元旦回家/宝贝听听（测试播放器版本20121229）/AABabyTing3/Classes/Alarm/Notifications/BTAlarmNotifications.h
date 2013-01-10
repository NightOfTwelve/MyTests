//
//  BTAlarmNotifications.h
//  testAlarm
//
//  Created by song on 12-12-21.
//  Copyright (c) 2012年 21kunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

//按钮点击事件
extern NSString * const BTAlarmButtonDidClickedNotification;

//关闭定时定量界面通知
extern NSString * const BTAlarmViewControllerShouldDisappearNotification;

//定时器开始
extern NSString * const BTAlarmDidStartedNotification;
//定时器的值发生改变
extern NSString * const BTAlarmValueChangedNotification;
//定时器结束
extern NSString * const BTAlarmDidFinishedNotification;
//定时器被终止
extern NSString * const BTAlarmDidStopedNotification;

@class BTAlarm;
@interface BTAlarmNotifications : NSObject
+ (void)postNotificationName:(NSString *)aNotifName
				   withAlarm:(BTAlarm *)anAlarm;
+ (void)addObserver:(id)anObserver
		   selector:(SEL)aSelector
			 object:(id)anObject
			   name:aNotifName;
+ (void)removeObserver:(id)anObserver
				object:(id)anObject
				  name:(NSString *)aNotifName;
+ (void)removeObserver:(id)anObserver;
@end
