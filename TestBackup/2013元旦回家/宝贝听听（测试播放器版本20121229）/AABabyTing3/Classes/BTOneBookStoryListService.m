//
//  BTOneBookStoryListService.m
//  故事分类Tab页下，根据专辑id获得故事列表。
//  cid ＝ 305。
//
//  Created by Vicky on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// =======================================================
// ** Import **
// =======================================================
#import "BTOneBookStoryListService.h"

// =======================================================
// ** Class **
// =======================================================
@implementation BTOneBookStoryListService
// =========================================
// ** 初始化 **
// =========================================
/**
 * 初始化
 */
- (id)init{
    self = [super init];
    if(self) {
    }
    return self;
}

- (id)initWithAlbumidId:(NSString *)aID lastID:(NSInteger)lastID{
    self = [super init];
    if(self){
        _albumidID = aID;
        _lastID = lastID;
    }
    return  self;
}

/**
 * 配置子类信息
 */
-(NSData*)getPostData {
    self.requestCID = ONEBOOK_STORYLIST_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[ONEBOOK_STORYLIST_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:20]		forKey:@"percount"];                    //每次拉取条数
    [requestDic setObject:[NSNumber numberWithInteger:_lastID]		forKey:@"lastid"];                      //最后故事id
    [requestDic setObject:[NSNumber numberWithInteger:[_albumidID intValue]] forKey:@"albumid"];        //专辑id
    rd.request = requestDic;
	
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
