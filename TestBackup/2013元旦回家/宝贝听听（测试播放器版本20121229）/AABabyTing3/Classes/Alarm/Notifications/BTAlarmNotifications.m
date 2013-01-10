//
//  BTAlarmNotifications.m
//  testAlarm
//
//  Created by song on 12-12-21.
//  Copyright (c) 2012年 21kunpeng. All rights reserved.
//

#import "BTAlarmNotifications.h"
#import "BTAlarm.h"

//按钮点击事件
NSString * const BTAlarmButtonDidClickedNotification
	= @"BTAlarmButtonDidClickedNotification";

//关闭定时定量界面通知
NSString * const BTAlarmViewControllerShouldDisappearNotification
	= @"BTAlarmViewControllerShouldDisappearNotification";

//定时器开始
NSString * const BTAlarmDidStartedNotification
	= @"BTAlarmDidStartedNotification";
//定时器的值发生改变
NSString * const BTAlarmValueChangedNotification
	= @"BTAlarmValueChangedNotification";
//定时器结束
NSString * const BTAlarmDidFinishedNotification
	= @"BTAlarmDidFinishedNotification";
//定时器被终止
NSString * const BTAlarmDidStopedNotification
	= @"BTAlarmDidStopedNotification";


@implementation BTAlarmNotifications
+ (void)postNotificationName:(NSString *)aNotifName
				   withAlarm:(BTAlarm *)anAlarm {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	NSDictionary *userInfo = nil;
	if (anAlarm != nil) {
		userInfo = [NSDictionary dictionaryWithObject:anAlarm
											   forKey:DICTIONARY_KEY_ALARM];
	}
	[center postNotificationName:aNotifName
						  object:anAlarm
						userInfo:userInfo];
}
+ (void)addObserver:(id)anObserver
		   selector:(SEL)aSelector
			 object:(id)anObject
			   name:(NSString *)aNotifName {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:anObserver
			   selector:aSelector
				   name:aNotifName
				 object:anObject];
}
+ (void)removeObserver:(id)anObserver
				object:(id)anObject
				  name:(NSString *)aNotifName {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:anObserver
					  name:aNotifName
					object:anObject];
}
+ (void)removeObserver:(id)anObserver {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:anObserver];
}
@end
