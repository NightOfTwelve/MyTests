//
//  BTGiftEggsTestAction.m
//  AABabyTing3
//
//  Created by Zero on 12/6/12.
//
//

#import "BTGiftEggsTestAction.h"
#import <SenTestingKit/SenTestingKit.h>

@implementation BTGiftEggsTestAction
- (id)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didFinish:)
													 name:GIFT_EGGS_NOTIFICATION
												   object:nil];
	}
	return self;
}
- (void)didFinish:(NSNotification *)notif {
	self.data = notif.userInfo[GIFT_EGGS_RETURN];
	self.error = notif.userInfo[NOTIFICATION_ERROR];
	self.finished = YES;
}
@end
