//
//  BTFeedbackAction.m
//  AABabyTing3
//
//  Created by Zero on 9/2/12.
//
//

#import "BTFeedbackAction.h"
#import "BTFeedbackService.h"
//#import "BTFeedbackView2Controller.h"

@interface BTFeedbackAction ()
@property (nonatomic, retain)	NSDictionary *feedbackInfo;
@end

@implementation BTFeedbackAction
@synthesize feedbackInfo;

- (id)initWithFeedbackInfo:(NSDictionary *)aFeedbackInfo {
	if (self = [super init]) {
		self.feedbackInfo = aFeedbackInfo;
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[feedbackInfo release];
	[super dealloc];
}

- (void)start {
	
//	NSDictionary *feedbackInfo = ((BTFeedbackViewController *)_actionDelegate).feedbackInfo;
//	DLog(@"feedbackInfo = %@",feedbackInfo);
	_service = [[BTFeedbackService alloc] initWithFeedbackInfo:feedbackInfo];
	_service.serviceDelegate = self;
	_service.requestCID = FEEDBACK_REQUEST_FINISH_NOTIFICATION;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didFinish:)
												 name:FEEDBACK_REQUEST_FINISH_NOTIFICATION
											   object:_service];
	
	[super start];
}

- (void)receiveData:(NSDictionary *)data {
	//CDLog(BTDFLAG_Feedback,@"data:%@",data);
	NSDictionary *userInfo = [data dictionaryForKey:JSON_NAME_RET];
	int ret = [[userInfo numberForKey:JSON_NAME_RET] intValue];
	if (ret == 100) {
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
			[_actionDelegate onAction:self withData:userInfo];
		}
		//		DLog(@"feedback succeed!");
	} else {
		//		DLog(@"feedback failed!");
		//		DLog(@"ret = %d",ret);
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"用户反馈错误啦" forKey:@"kErrorMsg"];
			NSError *error = [NSError errorWithDomain:@"feedback error" code:7734 userInfo:userInfo];
			[_actionDelegate onAction:self withError:error];
		}
	}
}

- (void)didFinish:(NSNotification *)notification {
	//CDLog(BTDFLAG_Feedback,@"3");
	NSDictionary *userInfo = notification.userInfo;
	int ret = [[userInfo numberForKey:JSON_NAME_RET] intValue];
	if (ret == 100) {
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
			[_actionDelegate onAction:self withData:userInfo];
		}
//		DLog(@"feedback succeed!");
	} else {
//		DLog(@"feedback failed!");
//		DLog(@"ret = %d",ret);
		if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withError:)]) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"用户反馈错误啦" forKey:@"kErrorMsg"];
			NSError *error = [NSError errorWithDomain:@"feedback error" code:7734 userInfo:userInfo];
			[_actionDelegate onAction:self withError:error];
		}
	}
}

@end
