//
//  BTOneChosenListService.m
//  AABabyTing3
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BTOneChosenListService.h"
#import "BTRequestData.h"

@implementation BTOneChosenListService
@synthesize bookId = _bookId;

//- (id)initWithBookId:(NSInteger)bookId andLastStoryId:(NSInteger)lastId requestCount:(NSInteger)count{
//    self = [super init];
//    if(self){
//        _bookId = bookId;
//        _lastStoryId = lastId;
//        _requestCount = count;
//    }
//    return self;
//}

-(id)initWithBookId:(int)bookId lastID:(NSInteger)lastID{
    
    self = [super init];
    if (self) {
        _bookId = bookId;
        _lastStoryId = lastID;
    }
    return self;
}

-(NSData*)getPostData {
    self.requestCID = ONECOLLECTION_STORYLIST_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[ONECOLLECTION_STORYLIST_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:_bookId] forKey:@"collectionid"];
    [requestDic setObject:[NSNumber numberWithInteger:_lastStoryId] forKey:@"lastid"];
    [requestDic setObject:[NSNumber numberWithInteger:pageRequestCount] forKey:@"percount"];
    rd.request = requestDic;
    NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}

@end
