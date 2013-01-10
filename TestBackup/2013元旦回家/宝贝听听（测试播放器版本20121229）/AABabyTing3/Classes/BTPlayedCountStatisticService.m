//
//  BTPlayedCountStatisticService.m
//  AABabyTing3
//
//  Created by Zero on 9/1/12.
//
//

#import "BTPlayedCountStatisticService.h"

@interface BTPlayedCountStatisticService ()
@property (nonatomic, retain)	NSArray *requestInfo;
@end

@implementation BTPlayedCountStatisticService
@synthesize requestInfo;

- (id)initWithRequestInfo:(NSArray *)aRequestInfo {
	if (self = [super init]) {
		self.requestInfo = aRequestInfo;
	}
	return self;
}

- (void)dealloc {
	[requestInfo release];
	[super dealloc];
}

- (NSData*)getPostData {
	self.requestCID = PLAYTIMES_UPLOAD_REQUEST_NOTIFICATION_CID;
	
	BTRequestData *rd = [[BTRequestData alloc] initWithCid:[PLAYTIMES_UPLOAD_REQUEST_NOTIFICATION_CID integerValue]];
	rd.requestArray = [NSMutableArray arrayWithArray:self.requestInfo];
	
    NSData *data = [self convertData:rd];
	[rd release];
	
	{
		NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//		CVLog(BTDFLAG_PlayedCountStatistics,@"data=%@",str);
		[str release];
	}
	
    return data;	//转换为JSONData
}


@end
