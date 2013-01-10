//
//  BTConfigurationRequestService.m
//  AABabyTing3
//
//  Created by Zero on 9/9/12.
//
//

#import "BTConfigurationRequestService.h"

@implementation BTConfigurationRequestService

- (NSData *)getPostData {
	self.requestCID = CONFIGURATION_REQUEST_NOTIFICATION_CID;
	BTRequestData *rd = [[BTRequestData alloc] initWithCid:[CONFIGURATION_REQUEST_NOTIFICATION_CID intValue]];
	NSData *data = [self convertData:rd];
	[rd release];
	return data;
}

@end
