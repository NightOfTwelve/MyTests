//
//  BTAlarmNotificationsTests.m
//  DemoAlarm
//
//  Created by song on 12-12-21.
//  Copyright (c) 2012年 Zero. All rights reserved.
//

#import "BTAlarmNotificationsTests.h"
#import "BTAlarmNotifications.h"

@implementation BTAlarmNotificationsTests

- (void)setUp {
	notificationNames = [[NSArray alloc] initWithObjects:
						 BTAlarmDidStartedNotification,
						 BTAlarmDidFinishedNotification,
						 BTAlarmDidStopedNotification,
						 BTAlarmValueChangedNotification,
						 BTAlarmViewControllerShouldDisappearNotification,
						 nil];
}
- (void)tearDown {
	[notificationNames release], notificationNames = nil;
}

- (void)test01PostNotifications {
	//set handle methods
	for (NSString *notifName in notificationNames) {
		[BTAlarmNotifications addObserver:self
								 selector:@selector(handleNotification:)
								   object:nil
									 name:notifName];
	}
	
	//reset flags
	[self resetFlags];
	
	//post notifications
	for (NSString *notifName in notificationNames) {
		[BTAlarmNotifications postNotificationName:notifName
										 withAlarm:nil];
	}
	
	//verify flags
	STAssertTrue(_stoped, nil);
	STAssertTrue(_started, nil);
	STAssertTrue(_finished, nil);
	STAssertTrue(_valueChanged, nil);
	STAssertTrue(_shouldDisappear, nil);
}

- (void)test02RemoveObserver {
	[BTAlarmNotifications removeObserver:self];
	
	//reset flags
	[self resetFlags];
	
	//post notifications
	for (NSString *notifName in notificationNames) {
		[BTAlarmNotifications postNotificationName:notifName
										 withAlarm:nil];
	}
	
	//verify flags
	STAssertFalse(_stoped, nil);
	STAssertFalse(_started, nil);
	STAssertFalse(_finished, nil);
	STAssertFalse(_valueChanged, nil);
	STAssertFalse(_shouldDisappear, nil);
}



- (void)resetFlags {
	_stoped = NO;
	_started = NO;
	_finished = NO;
	_valueChanged = NO;
	_shouldDisappear = NO;
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
	} else if (notifName == BTAlarmViewControllerShouldDisappearNotification) {
		_shouldDisappear = YES;
	}
}

@end
