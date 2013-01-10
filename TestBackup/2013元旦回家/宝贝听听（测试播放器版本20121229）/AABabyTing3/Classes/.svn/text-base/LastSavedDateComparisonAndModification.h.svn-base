//
//  LastSavedDateComparisonAndModification.h
//  BabyTing
//
//  Created by Zero on 8/9/12.
//
//

#import <Foundation/Foundation.h>

//UserDefaults
#define LocalStoriesStatisticsReport_LastReportedCountDate		@"LocalStoriesStatisticsReport_LastReportedCountDate"
#define LocalStoriesStatisticsReport_LastReportedIDDate			@"LocalStoriesStatisticsReport_LastReportedIDDate"

@interface LastSavedDateComparisonAndModification : NSObject
//上次上报【故事数量】成功的日期是否是今天（是今天，则返回YES）
+ (BOOL)isLastReportedLocalStoryCountDateToday;
//修改上次上报【故事数量】成功的日期为今天
+ (void)setLastReportedLocalStoryCountDateToday;

//上次上报【故事ID】成功的日期是否是今天（是今天，则返回YES）
+ (BOOL)isLastReportedLocalStoryIDsDateToday;
//修改上次上报【故事ID】成功的日期为今天
+ (void)setLastReportedLocalStoryIDsDateToday;
@end
