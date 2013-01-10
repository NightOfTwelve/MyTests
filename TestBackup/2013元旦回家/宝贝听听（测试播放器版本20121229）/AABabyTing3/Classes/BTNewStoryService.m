//
//  BTNewStoryService.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-3.
//
//

#import "BTNewStoryService.h"

@implementation BTNewStoryService
- (id)initWithListID:(NSInteger )listID lastID:(NSInteger )lastID{
    self = [super init];
    if(self){
        _lastID = lastID;
        _listID = listID;
    }
    return self;
}


- (NSData *)getPostData{
    self.requestCID = NEWEST_SOTRYLIST_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[NEWEST_SOTRYLIST_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:_lastID] forKey:@"lastid"];
    [requestDic setObject:[NSNumber numberWithInteger:_listID] forKey:@"listid"];
    [requestDic setObject:[NSNumber numberWithInteger:pageRequestCount] forKey:@"percount"];
    rd.request = requestDic;
    NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}
@end
