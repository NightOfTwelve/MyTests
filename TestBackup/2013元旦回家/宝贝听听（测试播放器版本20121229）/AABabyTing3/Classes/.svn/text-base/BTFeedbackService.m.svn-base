//
//  BTFeedbackService.m
//  AABabyTing3
//
//  Created by Zero on 9/1/12.
//
//

#import "BTFeedbackService.h"

@interface BTFeedbackService ()
@property (nonatomic, retain)		NSDictionary			*feedbackInfo;			//用户反馈信息
@end

@implementation BTFeedbackService
@synthesize feedbackInfo;

- (id)initWithFeedbackInfo:(NSDictionary *)theFeedbackInfo {
//	DLog(@"%s",__FUNCTION__);
    if(self = [super init]) {
		self.feedbackInfo = theFeedbackInfo;
    }
    return self;
}

- (void)dealloc {
	[feedbackInfo release];
	[super dealloc];
}

- (NSData *)getPostData {
//	DLog(@"%@%s",self,__FUNCTION__);
    NSData *data = [BTUtilityClass requestPacking:REQUEST_NAME_FEEDBACK withInfo:self.feedbackInfo];
    return data;
}

@end
