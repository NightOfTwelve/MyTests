//
//  BTBannerClickedStatisticsAction.h
//  AABabyTing3
//
//  Created by Zero on 11/2/12.
//
//

#import <Foundation/Foundation.h>

@class BTBannerClickedStatisticsAction;
@protocol BTBannerClickedDelegate <NSObject>
@optional
- (void)saveBannerStatisticsSucceed:(BTBannerClickedStatisticsAction *)action;
- (void)saveBannerStatisticsFailed:(BTBannerClickedStatisticsAction *)action;
@end

@interface BTBannerClickedStatisticsAction : NSObject
@property (assign)	id<BTBannerClickedDelegate>	delegate;
- (void)clickedBannerAtId:(NSString *)bannerId;
+ (NSString *)filePath;
@end
