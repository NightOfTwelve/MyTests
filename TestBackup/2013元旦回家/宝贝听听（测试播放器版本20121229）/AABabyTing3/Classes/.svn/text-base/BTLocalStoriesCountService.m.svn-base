//
//  BTLocalStoriesCountService.m
//  AABabyTing3
//
//  Created by Zero on 9/4/12.
//
//  本地故事数量上报Service

#import "BTLocalStoriesCountService.h"

@interface BTLocalStoriesCountService ()
@property (nonatomic, retain)	NSDictionary	*requestInfo;
@end

@implementation BTLocalStoriesCountService
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
	NSDictionary *mainBuddleInfoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:[NSString stringWithFormat:APP_NAME] forKey:@"app_name"];
    [info setValue:[mainBuddleInfoDictionary objectForKey:@"CFBundleVersion"] forKey:@"app_version"];
	[info setValue:[BTUtilityClass cfUUIDfromKeyChain] forKey:@"identifier"];
	[info setValue:REQUEST_NAME_LOCAL_STORY_COUNT forKey:@"request_name"];
	[info setValue:requestInfo forKey:@"request_info"];
	NSData *data = [info JSONData];
	return data;
}




@end
