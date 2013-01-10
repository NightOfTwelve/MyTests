//
//  BTNewStoryHeaderService.m
//  AABabyTing3
//
//  Created by Wang Neo on 12-9-3.
//
//

#import "BTNewStoryHeaderService.h"

@implementation BTNewStoryHeaderService



- (id)initWithID:(NSInteger)listID{
    self= [super init];
    if(self){
        _listID = listID;
    }
    return self;
}

-(NSData*)getPostData {
    self.requestCID = NEWEST_STORY_HEADER_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[NEWEST_STORY_HEADER_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:_listID] forKey:@"listid"];
    rd.request = requestDic;
	NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}
@end
