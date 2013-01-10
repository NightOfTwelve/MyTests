//
//  BTAlarmTests.m
//  DemoAlarm
//
//  Created by song on 12-12-21.
//  Copyright (c) 2012年 Zero. All rights reserved.
//

#import "BTAlarmTests.h"
#import "BTAlarm.h"

static NSUInteger UIntZero = 0;

@implementation BTAlarmTests
#pragma mark - Bug修复————结束后还发通知
- (void)testBugFinishNotification {
	[BTAlarmNotifications removeObserver:self];
	BTAlarm *alarm = [[[BTAlarm alloc] init] autorelease];
	
	[self resetFlags];
	for (NSString *notifName in notificationNames) {
		[BTAlarmNotifications addObserver:self
								 selector:@selector(handleNotification:)
								   object:alarm
									 name:notifName];
	}
	
	//定量
	[alarm startCounting:1];
	STAssertFalse(_finished, nil);
	[alarm decreaseCount];
	STAssertTrue(_finished, nil);
	
	[self resetFlags];
	for (int i=0; i<3; i++) {
		[self wait:1];
		STAssertFalse(_started, nil);
		STAssertFalse(_finished, nil);
		STAssertFalse(_stoped, nil);
		STAssertFalse(_valueChanged, nil);
	}
	
	
	//定时
	[self resetFlags];
	[alarm startTiming:1];
	STAssertFalse(_finished, nil);
	[self wait:1.5];
	STAssertTrue(_finished, nil);
	
	[self resetFlags];
	for (int i=0; i<3; i++) {
		[self wait:1];
		STAssertFalse(_started, nil);
		STAssertFalse(_finished, nil);
		STAssertFalse(_stoped, nil);
		STAssertFalse(_valueChanged, nil);
	}
	
	[BTAlarmNotifications removeObserver:self];
}

#pragma mark - 单例
- (void)testSingleton {
	STAssertNotNil([BTAlarm sharedInstance], nil);
}

#pragma mark - 初始化
- (void)testInit {
	BTAlarm *alarm = [[[BTAlarm alloc] init] autorelease];
	STAssertNotNil(alarm, nil);
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateInitialized, nil);
	STAssertEquals(alarm.remains, UIntZero, nil);
}

#pragma mark - 倒数
- (void)testCounting {
	BTAlarm *alarm = [[[BTAlarm alloc] init] autorelease];
	
	[alarm startCounting:2];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)2, nil);
	
	[alarm decreaseCount];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)1, nil);
	
	[alarm decreaseCount];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateFinished, nil);
	STAssertEquals(alarm.remains, UIntZero, nil);
}

#pragma mark - 倒计时
- (void)testStartTiming {
	BTAlarm *alarm = [[[BTAlarm alloc] init] autorelease];
	
	[alarm startTiming:2];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)2, nil);
	
	
	[self wait:1.5];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)1, nil);
	
	[self wait:1.1];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateFinished, nil);
	STAssertEquals(alarm.remains, UIntZero, nil);
}

#pragma mark - 混合测试
- (void)testCountingTiming {
	[BTAlarm destorySharedInstance];
	BTAlarm *alarm = [BTAlarm sharedInstance];
	
	[alarm startCounting:3];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)3, nil);
	
	[alarm startTiming:2];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)2, nil);
	
	[alarm stop];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateInitialized, nil);
	STAssertEquals(alarm.remains, UIntZero, nil);
	[BTAlarm destorySharedInstance];
}

- (void)testTimingCounting {
	[BTAlarm destorySharedInstance];
	BTAlarm *alarm = [BTAlarm sharedInstance];
	[alarm startTiming:2];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)2, nil);
	
	[alarm startCounting:3];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)3, nil);
	
	[alarm stop];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateInitialized, nil);
	STAssertEquals(alarm.remains, UIntZero, nil);
	[BTAlarm destorySharedInstance];
}

- (void)testCountingCounting {
	[BTAlarm destorySharedInstance];
	BTAlarm *alarm = [BTAlarm sharedInstance];
	[alarm startCounting:2];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)2, nil);
	
	[alarm startCounting:3];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)3, nil);
	
	[alarm stop];
	STAssertEquals(alarm.mode, eBTAlarmModeCounting, nil);
	STAssertEquals(alarm.state, eBTAlarmStateInitialized, nil);
	STAssertEquals(alarm.remains, UIntZero, nil);
	[BTAlarm destorySharedInstance];
}

- (void)testTimingTiming {
	[BTAlarm destorySharedInstance];
	BTAlarm *alarm = [BTAlarm sharedInstance];
	[alarm startTiming:2];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)2, nil);
	
	[alarm startTiming:3];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateRunning, nil);
	STAssertEquals(alarm.remains, (NSUInteger)3, nil);
	
	[alarm stop];
	STAssertEquals(alarm.mode, eBTAlarmModeTiming, nil);
	STAssertEquals(alarm.state, eBTAlarmStateInitialized, nil);
	STAssertEquals(alarm.remains, UIntZero, nil);
	[BTAlarm destorySharedInstance];
}

#pragma mark - 通知
- (void)testCountingNotification {
	BTAlarm *alarm = [[[BTAlarm alloc] init] autorelease];
	
	[self resetFlags];
	for (NSString *notifName in notificationNames) {
		[BTAlarmNotifications addObserver:self
								 selector:@selector(handleNotification:)
								   object:alarm
									 name:notifName];
	}
	
	[alarm startCounting:2];
	STAssertFalse(_stoped, nil);
	[alarm stop];
	STAssertTrue(_stoped, nil);
	
	[BTAlarmNotifications removeObserver:self];
}

- (void)testTimingNotification {
	BTAlarm *alarm = [[[BTAlarm alloc] init] autorelease];
	
	[self resetFlags];
	for (NSString *notifName in notificationNames) {
		[BTAlarmNotifications addObserver:self
								 selector:@selector(handleNotification:)
								   object:alarm
									 name:notifName];
	}
	
	[alarm startTiming:2];
	STAssertTrue(_started, nil);
	STAssertFalse(_valueChanged, nil);
	STAssertFalse(_finished, nil);
	STAssertFalse(_stoped, nil);
	
	[self wait:1.1];
	STAssertTrue(_started, nil);
	STAssertTrue(_valueChanged, nil);
	STAssertFalse(_finished, nil);
	STAssertFalse(_stoped, nil);
	
	[self wait:1.1];
	STAssertTrue(_started, nil);
	STAssertTrue(_valueChanged, nil);
	STAssertTrue(_finished, nil);
	STAssertFalse(_stoped, nil);
	[BTAlarmNotifications removeObserver:self];
	
	
	alarm = [[[BTAlarm alloc] init] autorelease];
	for (NSString *notifName in notificationNames) {
		[BTAlarmNotifications addObserver:self
								 selector:@selector(handleNotification:)
								   object:alarm
									 name:notifName];
	}
	[alarm startTiming:1];
	STAssertFalse(_stoped, nil);
	[alarm stop];
	STAssertTrue(_stoped, nil);
	[BTAlarmNotifications removeObserver:self];
}

- (void)handleNotification:(NSNotification *)aNotif {
	NSString *notifName = aNotif.name;
	if (notifName == BTAlarmDidStartedNotification) {
		_started = YES;
	} else if (notifName == BTAlarmDidFinishedNotification) {
		_finished = YES;
	} else if (notifName == BTAlarmValueChangedNotification) {
		_valueChanged = YES;
	} else if (notifName == BTAlarmDidStopedNotification) {
		_stoped = YES;
	}
}

- (void)resetFlags {
	_started = NO;
	_valueChanged = NO;
	_finished = NO;
	_stoped = NO;
}

#pragma mark - Helper
- (void)wait:(NSTimeInterval)seconds {
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
}

#pragma mark -
- (void)setUp {
	notificationNames = [[NSArray alloc] initWithObjects:
						 BTAlarmDidStartedNotification,
						 BTAlarmDidFinishedNotification,
						 BTAlarmDidStopedNotification,
						 BTAlarmValueChangedNotification,
						 nil];
}
- (void)tearDown {
	[notificationNames release], notificationNames = nil;
}

@end
