//
//  BTAlarmDataSource.m
//  DemoAlarm
//
//  Created by Zero on 12/21/12.
//  Copyright (c) 2012 Zero. All rights reserved.
//

#import "BTAlarmDataSource.h"

static NSArray *timingTexts = nil;
static NSArray *countingTexts = nil;
static NSArray *timingValues = nil;
static NSArray *countingValues = nil;

@implementation BTAlarmDataSource

#pragma mark DataSource
+ (NSUInteger)countOnMode:(EnumBTAlarmMode)aMode {
	switch (aMode) {
		case eBTAlarmModeTiming:
			return MIN(timingTexts.count,timingValues.count);
		case eBTAlarmModeCounting:
			return MIN(countingTexts.count, countingValues.count);
		default:
			return 0;
	}
}

+ (NSArray *)textsOnMode:(EnumBTAlarmMode)aMode {
	switch (aMode) {
		case eBTAlarmModeTiming:
			return timingTexts;
		case eBTAlarmModeCounting:
			return countingTexts;
		default:
			return nil;
	}
}

+ (NSArray *)valuesOnMode:(EnumBTAlarmMode)aMode {
	switch (aMode) {
		case eBTAlarmModeTiming:
			return timingValues;
		case eBTAlarmModeCounting:
			return countingValues;
		default:
			return nil;
	}
}

#pragma mark initialize
+ (void)initialize {
	[super initialize];
	timingTexts = [[NSArray alloc] initWithObjects:
				   @"12秒钟"
				   ,@"1分钟"
				   ,@"10分钟"
				   ,@"30分钟"
				   ,@"60分钟", nil];
	timingValues = [[NSArray alloc] initWithObjects:
					[NSNumber numberWithUnsignedInteger:12]
					,[NSNumber numberWithUnsignedInteger:60*1]
					,[NSNumber numberWithUnsignedInteger:60*10]
					,[NSNumber numberWithUnsignedInteger:60*30]
					,[NSNumber numberWithUnsignedInteger:60*60], nil];
	
	countingTexts = [[NSArray alloc] initWithObjects:
					 @"1个"
					 ,@"2个"
					 ,@"3个"
					 ,@"4个"
					 ,@"6个", nil];
	countingValues = [[NSArray alloc] initWithObjects:
					  [NSNumber numberWithUnsignedInteger:1]
					  ,[NSNumber numberWithUnsignedInteger:2]
					  ,[NSNumber numberWithUnsignedInteger:3]
					  ,[NSNumber numberWithUnsignedInteger:4]
					  ,[NSNumber numberWithUnsignedInteger:6], nil];
}

@end
