//
//  BTBannerClickedStatisticsAction.m
//  AABabyTing3
//
//  Created by Zero on 11/2/12.
//
//

#import "BTBannerClickedStatisticsAction.h"

@implementation BTBannerClickedStatisticsAction
+ (NSString *)filePath {
	return [BTUtilityClass fileWithPath:FILE_NAME_BANNER_STATISTICS_ARCHIVER];
}
- (void)clickedBannerAtId:(NSString *)bannerId {
	static const NSString *kBannerPrefix = @"BabyTing_Banner";
	NSString *key = [NSString stringWithFormat:@"%@_%@",kBannerPrefix,bannerId];
	//读取
	NSMutableDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] filePath]];
	if (info == nil) {
		info = [NSMutableDictionary dictionary];
	}
	
	//+1
	NSUInteger count = [[info valueForKey:key] unsignedIntegerValue];
	count++;
	[info setValue:@(count) forKey:key];
	
	//保存
	BOOL saveSuc = [NSKeyedArchiver archiveRootObject:info toFile:[[self class] filePath]];
	
	//返回
	if (saveSuc) {
		if (_delegate && [_delegate respondsToSelector:@selector(saveBannerStatisticsSucceed:)]) {
			[_delegate saveBannerStatisticsSucceed:self];
		}
	} else {
		if (_delegate && [_delegate respondsToSelector:@selector(saveBannerStatisticsFailed:)]) {
			[_delegate saveBannerStatisticsFailed:self];
		}
	}
}
@end
