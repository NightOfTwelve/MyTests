//
//  BTAlarm.m
//  DemoAlarm
//
//  Created by song on 12-12-21.
//  Copyright (c) 2012年 Zero. All rights reserved.
//

#import "BTAlarm.h"

static BTAlarm *shared = nil;

@implementation BTAlarm
@synthesize mode = _mode;
@synthesize state = _state;
@synthesize remains = _remains;

- (id)init {
	self = [super init];
	if (self) {
		_mode = eBTAlarmModeTiming;
		_state = eBTAlarmStateInitialized;
		_remains = 0;
		_timer = nil;
	}
	return self;
}

- (void)dealloc {
	[_timer release], _timer = nil;
	[super dealloc];
}

#pragma mark - Public Methods
//开始定时倒数
- (void)startTiming:(NSUInteger)seconds {
	[self stopTimerInternal];
	
	if (seconds > 0) {
		_mode = eBTAlarmModeTiming;
		_state = eBTAlarmStateRunning;
		_remains = seconds;
		
		[self startTimerInternal];
		
		[BTAlarmNotifications postNotificationName:BTAlarmDidStartedNotification
										 withAlarm:self];
	}
}

//开始定量倒数
- (void)startCounting:(NSUInteger)count {
	[self stopTimerInternal];
	
	if (count > 0) {
		_mode = eBTAlarmModeCounting;
		_state = eBTAlarmStateRunning;
		_remains = count;
		
		[BTAlarmNotifications postNotificationName:BTAlarmDidStartedNotification
										 withAlarm:self];
	}
}

//计数减1
- (void)decreaseCount {
	if (_mode == eBTAlarmModeCounting) {
		[self decreaseCountInternal];
	}
}

//停止倒计时
- (void)stop {
	[self stopTimerInternal];
	_state = eBTAlarmStateInitialized;
	_remains = 0;
	
	[BTAlarmNotifications postNotificationName:BTAlarmDidStopedNotification
									 withAlarm:self];
}

#pragma mark - Private Methods

//开始定时器
- (void)startTimerInternal {
	if (_timer == nil) {
		_timer = [[NSTimer scheduledTimerWithTimeInterval:1.
												   target:self
												 selector:@selector(decreaseCountInternal)
												 userInfo:nil
												  repeats:YES] retain];
	}
}

//停止定时器
- (void)stopTimerInternal {
	if (_timer != nil) {
		[_timer invalidate];
		[_timer release], _timer = nil;
	}
}

//计数减1（内部）
- (void)decreaseCountInternal {
	if (_remains > 0) {
		--_remains;
	}
	
	//发送通知
	if (_remains > 0) {
		[BTAlarmNotifications postNotificationName:BTAlarmValueChangedNotification
										 withAlarm:self];
	} else {
		_state = eBTAlarmStateFinished;
		[BTAlarmNotifications postNotificationName:BTAlarmDidFinishedNotification
										 withAlarm:self];
		[self stopTimerInternal];
	}
}

#pragma mark - Singleton
+ (BTAlarm *)sharedInstance {
	@synchronized (self) {
		if (shared == nil) {
			shared = [[self alloc] init];
		}
		return shared;
	}
}

+ (void)destorySharedInstance {
	@synchronized (self) {
		if (shared != nil) {
			[shared release], shared = nil;
		}
	}
}

@end
