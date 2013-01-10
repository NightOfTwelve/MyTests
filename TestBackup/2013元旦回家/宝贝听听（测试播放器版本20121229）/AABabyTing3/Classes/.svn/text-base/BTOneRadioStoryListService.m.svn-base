//
//  BTOneRadioStoryListService.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-3.
//
//

#import "BTOneRadioStoryListService.h"

@implementation BTOneRadioStoryListService

- (id)initWithRadioID:(NSInteger)radioID history:(NSArray *)history requestCount:(NSInteger)count{
    self = [super init];
    if(self){
        _radioID = radioID;
        _historyArray = [[NSArray alloc] initWithArray:history];
        _requestCount = count;
    }
    return self;
}


- (NSData *)getPostData{
    self.requestCID = ONERADIO_STORYLIST_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[ONERADIO_STORYLIST_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:_radioID] forKey:@"radioid"];
    [requestDic setObject:_historyArray forKey:@"historyid"];
    [requestDic setObject:[NSNumber numberWithInteger:_requestCount] forKey:@"percount"];
    rd.request = requestDic;
    NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}


- (void)dealloc{
    [_historyArray release];
    [super dealloc];
}
@end
