//
//  BTBannerAction.m
//  AABabyTing3
//
//  Created by Zero on 9/3/12.
//
//

#import "BTBannerAction.h"

@implementation BTBannerAction

- (void)start {
	NSString *filePathBanner = [BTUtilityClass fileWithPath:BANNER_PLIST_NAME];
	NSArray *allBannerInfo = [NSArray arrayWithContentsOfFile:filePathBanner];
	if (!allBannerInfo) {
		return;
	}
	
	NSTimeInterval nowTime = [BTUtilityClass nowTimeDouble];
	NSMutableArray *allBannerInfoArray = [NSMutableArray array];
	for (NSDictionary *oneBannerInfo in allBannerInfo) {
		NSTimeInterval startTime = [[oneBannerInfo valueForKey:POPULARIZ_START_TIME] doubleValue];
		NSTimeInterval endTime = [[oneBannerInfo valueForKey:POPULARIZ_END_TIME] doubleValue];
		if (nowTime >= startTime && nowTime <= endTime) {
			[allBannerInfoArray addObject:oneBannerInfo];
		}
	}
	if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAction:withData:)]) {
		[_actionDelegate onAction:self withData:allBannerInfoArray];
	}
}

@end
