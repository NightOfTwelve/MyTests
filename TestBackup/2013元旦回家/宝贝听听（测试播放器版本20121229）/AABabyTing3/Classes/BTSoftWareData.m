//
//  BTSoftWareData.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTSoftWareData.h"

@implementation BTSoftWareData

@synthesize downloadURL;
@synthesize sotfID;

- (void)dealloc{
    [downloadURL release];
    [sotfID release];
    [super dealloc];
}

@end
