//
//  BTFeedbackRecords.m
//  Test_Feedback
//
//  Created by Zero on 11/23/12.
//  Copyright (c) 2012 songzhipeng. All rights reserved.
//

#import "BTFeedbackRecords.h"
#import "BTFeedbackRecord.h"

static BTFeedbackRecords *shared = nil;

@interface BTFeedbackRecords()
{
	int index;
}
@property(nonatomic,retain) NSMutableArray *records;
@end

@implementation BTFeedbackRecords

- (id)init {
	self = [super init];
	if (self) {
		self.records = [NSMutableArray array];
		index = 0;
	}
	return self;
}

- (void)dealloc {
	self.records = nil;
	[super dealloc];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.records forKey:@"feedback_records_records"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.records = [aDecoder decodeObjectForKey:@"feedback_records_records"];
		if (self.records == nil) {
			self.records = [NSMutableArray array];
		}
		index = 0;
	}
	return self;
}

#pragma mark -

//获取单例
+ (BTFeedbackRecords *)sharedInstance {
	@synchronized(self) {
		if (shared == nil) {
			shared = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]] retain];
			if (shared == nil) {
				shared = [[self alloc] init];
			}
		}
		return shared;
	}
}

//销毁单例
+ (void)destorySharedInstance {
	@synchronized(self) {
		if (shared != nil) {
			[shared saveRecords];//销毁前保存到本地
			[shared release];
			shared = nil;
		}
	}
}

//存储路径
+ (NSString *)filePath {
	return [BTUtilityClass fileWithPath:@"feedback.dat"];
}

//保存数据到本地
- (BOOL)saveRecords {
	@synchronized(self) {
		NSString *filePath = [[self class] filePath];
		BOOL b = [NSKeyedArchiver archiveRootObject:self toFile:filePath];
		CDLog(BTDFLAG_NEW_FEEDBACK, @"save:%d",b);
		return b;
	}
}

//获取一条记录
//当没有可用记录时，返回nil
- (BTFeedbackRecord *)getOneRecord {
	if (index>=0 && index<self.records.count) {
		return self.records[index];
	} else {
		return nil;
	}
}

//添加一条记录
- (void)addRecord:(BTFeedbackRecord *)record {
	@synchronized(self) {
		[self.records addObject:record];
	}
}

- (BTFeedbackRecord *)getNextRecord {
	++ index;
	return [self getOneRecord];
}

//删除一条记录
//返回YES：删除成功；返回NO：不存在这条记录
- (BOOL)deleteRecord {
	BOOL suc = NO;
	@synchronized(self) {
		@try {
			[self.records removeObjectAtIndex:index];
			suc = YES;
		}
		@catch(NSException *exception) {
			suc = NO;
		}
		@finally {
			return suc;
		}
	}
}
@end
