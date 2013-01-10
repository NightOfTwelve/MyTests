//
//  BTRequestData.m
//  AABabyTing3
//
//  Created by  on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTRequestData.h"
//#import "BTUtilityClass.h"
//#import "BTConstant.h"

@implementation BTRequestData

@synthesize cid,stamp,machine,version,identifier,os,channel,request,requestArray,appName;


- (id)initWithCid:(NSInteger)aCid{
    self = [super init];
    if(self){
        self.stamp = [NSNumber numberWithInt:0];
        self.machine = [BTUtilityClass getDeviceVersion];
        //DLog(@"self.machine = %@",self.machine);
        self.version = [BTUtilityClass getBundleVersion];
        self.identifier = [BTUtilityClass cfUUIDfromKeyChain];
        self.os = [[UIDevice currentDevice] systemVersion];
        self.channel = [NSNumber numberWithInt:DOWNLOAD_CHANNEL_FLAG];
        self.cid = [NSNumber numberWithInteger:aCid];
        self.appName = [NSNumber numberWithInt:REQUEST_APPNAME_TYPE];
        
    }
    return self;
}
-(void)dealloc{
    [cid release];
    [stamp release];
    [machine release];
    [version release];
    [identifier release];
    [os release];
    [channel release];
    [appName release];
    [request release];
    [requestArray release];
    [super dealloc];
}

@end
