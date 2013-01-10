//
//  BTHotStoryService.m
//  AABabyTing3
//
//  Created by  on 12-9-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTHotStoryService.h"
#import "BTRequestData.h"

@implementation BTHotStoryService


- (id)initWithHomeID:(NSInteger)homeID lastID:(NSInteger)lastID rankID:(NSInteger)rankID{
    self =[self init];
    if(self){
		_rankID = rankID;
        _homeID = homeID;
        _lastID = lastID;
    }
    return self;
}
-(NSData*)getPostData {
    self.requestCID = HOTEST_SOTRYLIST_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[HOTEST_SOTRYLIST_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
	requestDic[@"rankid"] = @(_rankID);
	requestDic[@"listid"] = @(_homeID);
	requestDic[@"lastid"] = @(_lastID);
	requestDic[@"percount"] = @(pageRequestCount);
    rd.request = requestDic;
    NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}

@end
