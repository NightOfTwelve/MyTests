//
//  BTUpdateSoftwareAction.m
//  AABabyTing3
//
//  Created by Zero on 8/29/12.
//
//

#import "BTUpdateSoftwareAction.h"
#import "BTCheckinManager.h"

@implementation BTUpdateSoftwareAction

- (void)start {
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish:) name:NOTIFICATION_UPDATE_SOFTWARE_WHEN_CHECKIN_FINISH object:nil];
	[self didFinish:nil];
}

- (void)didFinish:(NSNotification *)notification {
	
	int updateType = [BTCheckinManager shareInstance].updateType;
	
	
	//更新类型，从checkin返回值读取
//	int updateType = [[notification.userInfo valueForKey:UPDATE_SOFTWARE_UPDATE_TYPE] intValue];
	BOOL bCanUpdate = (updateType != 0) ? YES : NO;//是否有更新版本
//	DLog(@"UpdateAction:bCanUpdate = %@",bCanUpdate?@"YES":@"NO");
	NSNumber *number = [NSNumber numberWithBool:bCanUpdate];
	if ([_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
		[_actionDelegate onAction:self withData:number];
	}
}

- (void)dealloc {
//	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
