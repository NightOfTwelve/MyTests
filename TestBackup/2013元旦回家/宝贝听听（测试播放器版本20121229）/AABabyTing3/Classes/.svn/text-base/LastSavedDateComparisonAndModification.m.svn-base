//
//  LastSavedDateComparisonAndModification.m
//  BabyTing
//
//  Created by Zero on 8/9/12.
//
//

#import "LastSavedDateComparisonAndModification.h"

@interface LastSavedDateComparisonAndModification(Private)
+ (void)setLastReportedLocalStoryDateToday:(NSString *)key;
+ (BOOL)isLastReportedLocalStoryDateToday:(NSString *)key;

@end

@implementation LastSavedDateComparisonAndModification

//上次上报【故事数量】成功的日期是否是今天（是今天，则返回YES）
+ (BOOL)isLastReportedLocalStoryCountDateToday {
	return ( [self isLastReportedLocalStoryDateToday:LocalStoriesStatisticsReport_LastReportedCountDate] );
}
//修改上次上报【故事数量】成功的日期为今天
+ (void)setLastReportedLocalStoryCountDateToday {
	return ( [self setLastReportedLocalStoryDateToday:LocalStoriesStatisticsReport_LastReportedCountDate] );
}

//上次上报【故事ID】成功的日期是否是今天（是今天，则返回YES）
+ (BOOL)isLastReportedLocalStoryIDsDateToday {
	return ( [self isLastReportedLocalStoryDateToday:LocalStoriesStatisticsReport_LastReportedIDDate] );
}
//修改上次上报【故事ID】成功的日期为今天
+ (void)setLastReportedLocalStoryIDsDateToday {
	return ( [self setLastReportedLocalStoryDateToday:LocalStoriesStatisticsReport_LastReportedIDDate] );
}

//修改上次上报成功的日期为今天
+ (void)setLastReportedLocalStoryDateToday:(NSString *)key {
	//获取当前日期并转换日期格式
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *nowDate = [NSDate date];
	NSString *nowDateStr = [formatter stringFromDate:nowDate];
	[formatter release];
	
	//更新上报成功的日期
	[[NSUserDefaults standardUserDefaults] setValue:nowDateStr
											 forKey:key];
}

//上次上报故事数量成功的日期是否是今天（是今天，则返回YES）
+ (BOOL)isLastReportedLocalStoryDateToday:(NSString *)key {
	//获取上次上报成功的日期
	NSString *lastReportedDateStr = [[NSUserDefaults standardUserDefaults] valueForKey:key];
	//若获取失败，则设定为"1970-01-01"
	if (!lastReportedDateStr || [lastReportedDateStr isEqualToString:@""]) {
		lastReportedDateStr = @"1970-01-01";
		[[NSUserDefaults standardUserDefaults] setValue:lastReportedDateStr
												 forKey:key];
	}
	
	//获取当前日期并转换日期格式
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *nowDate = [NSDate date];
	NSString *nowDateStr = [formatter stringFromDate:nowDate];
	[formatter release];
	
//	DLog(@"lastReportedDate:%@",lastReportedDateStr);
//	DLog(@"nowDate:%@",nowDateStr);
	//返回日期比较结果
	return ( [nowDateStr isEqualToString:lastReportedDateStr] );
}

@end
