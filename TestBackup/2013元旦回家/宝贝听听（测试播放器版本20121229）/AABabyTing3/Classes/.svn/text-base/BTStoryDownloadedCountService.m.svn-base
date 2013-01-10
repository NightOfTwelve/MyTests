//
//  BTStoryDownloadedCountService.m
//  AABabyTing3
//
//  Created by Zero on 9/4/12.
//
//  故事下载次数上报Service

#import "BTStoryDownloadedCountService.h"

@interface BTStoryDownloadedCountService ()
@property (nonatomic, retain)	NSDictionary	*requestInfo;
@end

@implementation BTStoryDownloadedCountService
@synthesize requestInfo;

- (id)initWithRequestInfo:(NSDictionary *)theRequestInfo {
	if (self = [super init]) {
		self.requestInfo = theRequestInfo;
	}
	return (self);
}

- (void)dealloc {
	[requestInfo release];
	[super dealloc];
}

- (NSData *)getPostData {
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
	[info setValue:REQUEST_NAME_STORY_DOWNLOADED_COUNT forKey:@"request_name"];
	[info setValue:requestInfo forKey:@"request_info"];
	NSData *data = [info JSONData];
	return data;
}
@end
