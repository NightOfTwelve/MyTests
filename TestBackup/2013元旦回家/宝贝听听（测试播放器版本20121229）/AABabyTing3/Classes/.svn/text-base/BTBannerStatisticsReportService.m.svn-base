//
//  BTBannerStatisticsReportService.m
//  AABabyTing3
//
//  Created by Zero on 11/3/12.
//
//

#import "BTBannerStatisticsReportService.h"

@implementation BTBannerStatisticsReportService
- (id)initWithRequestInfo:(NSDictionary *)theRequestInfo {
	if (self = [super init]) {
		self.requestInfo = theRequestInfo;
	}
	return (self);
}

- (void)dealloc {
	[_requestInfo release];
	[super dealloc];
}

- (NSData *)getPostData {
	NSMutableDictionary *info = [super postCommonInfo];
	[info setValue:REQUEST_NAME_BANNER_CLICKED_COUNT forKey:@"request_name"];
	[info setValue:self.requestInfo forKey:@"request_info"];
	NSData *data = [info JSONData];
	return data;
}

@end
