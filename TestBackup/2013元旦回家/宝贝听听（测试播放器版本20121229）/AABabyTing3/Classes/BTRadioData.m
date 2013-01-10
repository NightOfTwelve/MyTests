//
//  BTRadioData.m
//  AABabyTing3
//
//  Created by Neo Wang on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTRadioData.h"

@implementation BTRadioData

@synthesize radioTitle,radioIconURL,radioDes,radioID,uptime,isNew;
-(void)dealloc{
    [radioID release];
    [radioDes release];
    [radioTitle release];
    [radioIconURL release];
    [uptime release];
    [super dealloc];
}
@end
