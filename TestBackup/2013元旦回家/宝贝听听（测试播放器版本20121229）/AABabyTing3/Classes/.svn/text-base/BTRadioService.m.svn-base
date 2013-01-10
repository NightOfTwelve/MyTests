//
//  BTRadioService.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-8-31.
//
//

#import "BTRadioService.h"

@implementation BTRadioService


- (id)initWithHomeID:(NSInteger)homeID lastID:(NSInteger)lastID{
    self =[self init];
    if(self){
        _homeID = homeID;
        _lastID = lastID;
    }
    return self;
}

-(NSData*)getPostData {
    self.requestCID = RADIOLIST_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[RADIOLIST_REQUEST_NOTIFICATION_CID integerValue]];
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
