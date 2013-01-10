//
//  BTTestAction.m
//  AABabyTing3
//
//  Created by Zero on 12/5/12.
//
//

#import "BTTestAction.h"

@implementation BTTestAction
- (void)dealloc {
	self.error = nil;
	self.info = nil;
	self.data = nil;
	[super dealloc];
}
- (void)receiveData:(NSDictionary *)data {
	self.data = data;
	self.error = data[NOTIFICATION_ERROR];
	self.info = data[JSON_NAME_RET];
	self.finished = YES;
}
@end
