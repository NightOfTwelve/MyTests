//
//  ZZRecordTestCase.m
//  ZZPokerRoller1
//
//  Created by Zero on 1/10/13.
//  Copyright (c) 2013 21kunpeng. All rights reserved.
//

#import "ZZRecordTestCase.h"
#import "ZZRecord.h"

@implementation ZZRecordTestCase
- (void)test1 {
	[MagicalRecord setDefaultModelFromClass:[self class]];
	[MagicalRecord setupCoreDataStackWithInMemoryStore];
	for (int i=0; i<10; i++) {
		ZZRecord *r = [ZZRecord MR_createEntity];
		r.id = i;
		r.message = [self randomString];
		r.timestamp = [[NSDate date] timeIntervalSince1970];
	}
	
	NSArray *allRecords = [ZZRecord MR_findAll];
	GHAssertEquals(allRecords.count, (NSUInteger)10, @"数据没有添加成功");
}

- (NSString *)randomString {
	NSMutableString *string = [NSMutableString string];
	int len = arc4random()%10+10;
	for (int i=0; i<len; i++) {
		char ch = arc4random()%48+(220-48);
		[string appendFormat:@"%c",ch];
	}
	return string;
}
@end
