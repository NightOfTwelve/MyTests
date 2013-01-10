//
//  BTHomeService.m
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHomeService.h"

@implementation BTHomeService

-(NSData*)getPostData {
    self.requestCID = HOME_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[HOME_REQUEST_NOTIFICATION_CID integerValue]];
	NSData *data = [self convertData:rd];
	[rd release];
    return data;
}

@end
