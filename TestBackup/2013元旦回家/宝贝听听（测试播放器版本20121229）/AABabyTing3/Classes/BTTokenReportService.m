//
//  BTTokenReportService.m
//  AABabyTing3
//
//  Created by Zero on 9/9/12.
//
//

#import "BTTokenReportService.h"

@interface BTTokenReportService ()
@property (nonatomic, copy)	NSString		*token;
@end

@implementation BTTokenReportService
@synthesize token;

- (NSData *)getPostData {
    self.requestCID = PUSHTOKEN_UPLOAD_REQUEST_NOTIFICATION_CID;
	BTRequestData *rd = [[BTRequestData alloc] initWithCid:[PUSHTOKEN_UPLOAD_REQUEST_NOTIFICATION_CID intValue]];
	NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
	[requestDic setValue:token forKey:PUSH_TOKEN_UPLOAD];
	rd.request = requestDic;
	NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}

- (id)initWithToken:(NSString *)theToken {
	self = [super init];
	if (self) {
		self.token = theToken;
	}
	return (self);
}

- (void)dealloc {
	self.token = nil;
	[super dealloc];
}

@end
