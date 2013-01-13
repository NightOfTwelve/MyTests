//
//  BTStatisticsHelper.m
//  DemoStatistics
//
//  Created by Song Zhipeng on 1/13/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import "BTStatisticsHelper.h"
#import "BTStatisticsRecord.h"

@implementation BTStatisticsHelper

+ (BOOL)addRecordWithEventID:(NSInteger)anEventID
					targetID:(NSInteger)aTargetID {
	return [self addRecordWithEventID:anEventID
							 targetID:aTargetID
							  message:nil];
}

+ (BOOL)addRecordWithEventID:(NSInteger)anEventID
					targetID:(NSInteger)aTargetID
					 message:(NSString *)aMessage {
	BTStatisticsRecord *record = [BTStatisticsRecord MR_createEntity];
	record.eventID = anEventID;
	record.targetID = aTargetID;
	record.message = aMessage;
	record.timestamp = [[NSDate date] timeIntervalSince1970];
	return (record != nil);
}

@end
