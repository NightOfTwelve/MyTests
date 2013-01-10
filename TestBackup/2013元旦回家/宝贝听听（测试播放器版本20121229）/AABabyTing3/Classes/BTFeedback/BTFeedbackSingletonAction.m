//
//  BTFeedbackSingletonAction.m
//  AABabyTing3
//
//  Created by Zero on 11/23/12.
//
//

#import "BTFeedbackSingletonAction.h"
#import "BTFeedbackRecords.h"

static BTFeedbackSingletonAction *shared = nil;

@interface BTFeedbackSingletonAction ()
@property(nonatomic,assign) BTFeedbackSingletonService *service;
- (BTFeedbackRecords *)records;
@end

@implementation BTFeedbackSingletonAction
- (id)init {
	self = [super init];
	if (self) {
		_maxRetryCount = 3;
	}
	return self;
}
- (void)dealloc {
	_service.delegate = nil;
	[_service release];
	[super dealloc];
}

#pragma mark -
//创建单例
+ (BTFeedbackSingletonAction *)sharedInstance {
	@synchronized(self) {
		if (shared == nil) {
			shared = [[BTFeedbackSingletonAction alloc] init];
		}
		return shared;
	}
}
//销毁单例
+ (void)destorySharedInstance {
	@synchronized(self) {
		CDLog(BTDFLAG_NEW_FEEDBACK,@"销毁单例");
		if (shared != nil) {
			shared.delegate = nil;
            shared.service.delegate = nil;
			[shared release], shared = nil;
		}
		[BTFeedbackRecords destorySharedInstance];
	}
}

//添加一条反馈记录
- (void)addOneRecord:(BTFeedbackRecord *)record {
	[self.records addRecord:record];
}

- (BTFeedbackSingletonService *)service {
	if (_service == nil) {
		_service = [[BTFeedbackSingletonService alloc] init];
		_service.delegate = self;
	}
	return _service;
}

- (BOOL)reportOneRecord {
	return [self reportOneRecord:[self.records getOneRecord]];
}

- (BOOL)reportNextRecord {
	return [self reportOneRecord:[self.records getNextRecord]];
}

- (BOOL)reportOneRecord:(BTFeedbackRecord *)record {
	if (record != nil) {
		self.service.record = record;
		[self.service start];
		return YES;
	}
	return NO;
}

//发送所有反馈记录
- (void)reportAllRecords {
	if (![self reportOneRecord]) {
		//没有要发送的
		@try {
			[_delegate allRecordsHadBeedSend];
		}
		@catch (NSException *exception) {
		}
	}
}

#pragma mark -
- (BTFeedbackRecords *)records {
	return [BTFeedbackRecords sharedInstance];
}

#pragma mark - BTFeedbackSingletonServiceDelegate
- (void)didFinishedReportFeedbackOnService:(BTFeedbackSingletonService *)service {
	CILog(BTDFLAG_NEW_FEEDBACK, @"反馈成功！");
	
	//删掉该条记录
	[self.records deleteRecord];
	
	if (![self reportOneRecord]) {//都发完了
		//保存
		[_service release];
		_service = nil;
		
		@try {
			[_delegate allRecordsHadBeedSend];
		}
		@catch (NSException *exception) {
		}
	}
}

- (void)didFailedReportFeedbackOnService:(BTFeedbackSingletonService *)service withError:(NSError *)error {
	CELog(BTDFLAG_NEW_FEEDBACK, @"反馈失败！");
	static int count = 0;
	BOOL finish = NO;
	if (count++ < _maxRetryCount) {
		//重试本条
		finish = [self reportOneRecord];
	} else {
		//发送下一条
		finish = [self reportNextRecord];
	}
	
	
	if (!finish) {//结束
		@try {
			[_delegate allRecordsHadBeedSend];
		}
		@catch (NSException *exception) {
		}
	}
}

@end
