//
//  MockASIHTTPRequest.m
//  AABabyTing3
//
//  Created by Zero on 12/5/12.
//
//

#import "MockASIHTTPRequest.h"

@implementation MockASIHTTPRequest
- (void)dealloc {
	self.fakeData = nil;
	[super dealloc];
}
- (NSData *)responseData {
	return self.fakeData;
}
@end
