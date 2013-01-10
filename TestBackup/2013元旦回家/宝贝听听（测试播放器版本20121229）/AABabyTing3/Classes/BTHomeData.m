//
//  BTHomeData.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHomeData.h"

@implementation BTHomeData
@synthesize category,describe,type,iconURL,homeID,updateDate,isNew;

-(void)dealloc{
    [type release];
    [homeID release];
    [iconURL release];
    [category release];
    [describe release];
    [updateDate release];
    [super dealloc];
}
@end
