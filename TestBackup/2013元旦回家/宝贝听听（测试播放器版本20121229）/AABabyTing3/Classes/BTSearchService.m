//
//  BTSearchService.m
//  AABabyTing3
//
//  Created by Tiny on 12-9-20.
//
//

#import "BTSearchService.h"
#import "BTRequestData.h"

@implementation BTSearchService

-(id)initWith:(NSString *)content{
    
    self = [super init];
    if (self) {
        _searchContent = content;
    }
    return self;
}

-(NSData*)getPostData {
    self.requestCID = SEARCH_STORY_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[SEARCH_STORY_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *reqDic = [NSMutableDictionary dictionary];
    [reqDic setValue:_searchContent forKey:@"key"];
    rd.request = reqDic;
	NSData *data = [self convertData:rd];
	[rd release];
    return data;
}

@end
