//
//  BTBannerStatisticsReportService.h
//  AABabyTing3
//
//  Created by Zero on 11/3/12.
//
//

#import "BTCheckinService.h"

@interface BTBannerStatisticsReportService : BTStatisticBaseService
@property (nonatomic, retain)	NSDictionary *requestInfo;
- (id)initWithRequestInfo:(NSDictionary *)theRequestInfo;
@end
