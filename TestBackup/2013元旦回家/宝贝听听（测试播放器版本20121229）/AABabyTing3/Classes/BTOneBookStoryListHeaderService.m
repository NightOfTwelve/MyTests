//
//  BTOneBookStoryListHeaderService.m
//  cid = 317
//
//  Created by Vicky on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// =======================================================
// ** Import **
// =======================================================
#import "BTOneBookStoryListHeaderService.h"

// =======================================================
// ** Class **
// =======================================================
@implementation BTOneBookStoryListHeaderService
// =========================================
// ** 初始化 **
// =========================================
/**
 * 初始化
 */
- (id)initWithAlbumID:(NSInteger)aID{
    self = [super init];
    if(self) {
        _albumID = aID;
    }
    return self;
}

/**
 * 配置子类信息
 */
-(NSData*)getPostData {
    self.requestCID = ONE_BOOK_LIST_HEADER_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[ONE_BOOK_LIST_HEADER_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
	[requestDic setObject:[NSNumber numberWithInteger:_albumID]			forKey:@"albumid"];			//Header id
    rd.request = requestDic;
//
	NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}

// =========================================
// ** 析构 **
// =========================================
/**
 * 析构
 */
- (void)dealloc{
	[super dealloc];
}
@end
