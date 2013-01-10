//
//  BTBannerRefresher.m
//  AABabyTing3
//
//  Created by Zero on 11/27/12.
//
//

#import "BTBannerRefresher.h"

static BTBannerRefresher *shared = nil;

@interface BTBannerRefresher ()
{
	BOOL checkInHasRefreshed;
}
@end

@implementation BTBannerRefresher
+ (BTBannerRefresher *)sharedInstance {
	@synchronized(self) {
		if (shared == nil) {
			shared = [[self alloc] init];
		}
		return shared;
	}
}
+ (void)destroySharedInstance {
	@synchronized(self) {
		if (shared != nil) {
			[shared release];
			shared = nil;
		}
	}
}

- (id)init {
	self = [super init];
	if (self) {
		checkInHasRefreshed = NO;
	}
	return self;
}

- (BOOL)canRefreshOfLocol {
	return !checkInHasRefreshed;
}
- (BOOL)canRefreshOfCheckinFinished {
	checkInHasRefreshed = YES;
	return YES;
}

@end