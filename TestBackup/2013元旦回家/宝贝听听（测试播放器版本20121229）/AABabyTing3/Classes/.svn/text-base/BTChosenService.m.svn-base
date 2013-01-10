//
//  BTChosenService.m
//  AABabyTing3
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTChosenService.h"
#import "BTRequestData.h"

@implementation BTChosenService

- (id)initWithHomeID:(NSInteger)homeID lastID:(NSInteger)lastID{
    self =[self init];
    if(self){
        _homeID = homeID;
        _lastID = lastID;
    }
    return self;
}
-(NSData*)getPostData {
    self.requestCID = COLLECTION_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[COLLECTION_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:_homeID] forKey:@"listid"];
    [requestDic setObject:[NSNumber numberWithInteger:_lastID] forKey:@"lastid"];
    [requestDic setObject:[NSNumber numberWithInteger:pageRequestCount] forKey:@"percount"];
    rd.request = requestDic;
    NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}

@end
