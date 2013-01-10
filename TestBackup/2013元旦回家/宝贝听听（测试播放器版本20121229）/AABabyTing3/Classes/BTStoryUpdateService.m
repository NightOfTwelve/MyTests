//
//  BTStoryUpdateService.m
//  AABabyTing3
//
//  Created by Tiny on 12-11-29.
//
//

#import "BTStoryUpdateService.h"

@implementation BTStoryUpdateService
@synthesize storyIds;

-(id)initWithStoryIds:(NSMutableArray *)ids{
    self = [super init];
    if (self) {
        self.storyIds = ids;
    }
    return self;
}

-(NSData*)getPostData {
    self.requestCID = STORYINFO_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[STORYINFO_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *reqDic = [NSMutableDictionary dictionary];
    [reqDic setValue:self.storyIds forKey:@"storyid"];
    rd.request = reqDic;
	NSData *data = [self convertData:rd];
	[rd release];
    return data;
}

-(void)dealloc{
    [storyIds release];
    [super dealloc];
}

@end
