//
//  BTOneChosenHeaderService.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-6.
//
//

#import "BTOneChosenHeaderService.h"

@implementation BTOneChosenHeaderService

- (id)initWithID:(NSInteger)listID{
    self= [super init];
    if(self){
        _listID = listID;
    }
    return self;
}

-(NSData*)getPostData {
    self.requestCID = ONE_CHOOSEN_LIST_HEADER_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[ONE_CHOOSEN_LIST_HEADER_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:_listID] forKey:@"collectionid"];
    rd.request = requestDic;
	NSData *data = [self convertData:rd];
	[rd release];
    return data;
}
@end
