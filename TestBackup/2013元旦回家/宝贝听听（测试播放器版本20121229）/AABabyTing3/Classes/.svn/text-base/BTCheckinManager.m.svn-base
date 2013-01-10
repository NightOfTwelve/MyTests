//
//  BTCheckinManager.m
//  BabyTingiPad
//
//  Created by  on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTCheckinManager.h"

static BTCheckinManager *instance = nil;

@implementation BTCheckinManager

@synthesize popularizes;
@synthesize recommends;
@synthesize splashs;
@synthesize updateType;
@synthesize updateUrl;
@synthesize necessarySoftData;

+(BTCheckinManager *)shareInstance{
    
    @synchronized (self){
        
        if (instance == nil) {
            instance = [[BTCheckinManager alloc] init];
        }
    }
    
    return instance;
}

+(void)destroyInstance{
    
    if (instance) {
        [instance release];
        instance = nil;
    }
}

-(void)dealloc{
    [popularizes release];
    [recommends release];
    [splashs release];
    [updateUrl release];
    [necessarySoftData release];
    [super dealloc];
}

@end
