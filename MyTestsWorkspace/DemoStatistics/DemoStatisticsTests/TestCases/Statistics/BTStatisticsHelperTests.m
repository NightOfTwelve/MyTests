//
//  BTStatisticsHelperTests.m
//  DemoStatistics
//
//  Created by Song Zhipeng on 1/13/13.
//  Copyright (c) 2013 Song Zhipeng. All rights reserved.
//

#import "BTStatisticsHelperTests.h"
#import "BTStatisticsHelper.h"

@implementation BTStatisticsHelperTests

- (void)setUp {
	[MagicalRecord setDefaultModelFromClass:[self class]];
	[MagicalRecord setupCoreDataStackWithInMemoryStore];
}

#pragma mark - Tests
- (void)testThatAddOneRecordWithoutMessage {
	int anyEventID = ANY_INT_VALUE;
	int anyTargetID = ANY_INT_VALUE;
	BOOL ret = [BTStatisticsHelper addRecordWithEventID:anyEventID
											   targetID:anyTargetID];
	GHAssertTrue(ret, nil);
}

- (void)testThatAddOneRecordWithMessage {
	int anyEventID = ANY_INT_VALUE;
	int anyTargetID = ANY_INT_VALUE;
	uint anyLength = arc4random()%1024;
	NSString *anyMessage = AnyNSStringOfLength(anyLength);
	
	BOOL ret = [BTStatisticsHelper addRecordWithEventID:anyEventID
											   targetID:anyTargetID
												message:anyMessage];
	GHAssertTrue(ret, nil);
}

@end
