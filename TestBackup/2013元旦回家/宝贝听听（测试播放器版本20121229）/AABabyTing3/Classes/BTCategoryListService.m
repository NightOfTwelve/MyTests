//
//  BTCategoryListService.m
//  故事分类Tab页下，获得分类列表。
//  cid ＝ 303。
//
//  Created by Vicky on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// =======================================================
// ** Import **
// =======================================================
#import "BTCategoryListService.h"

// =======================================================
// ** Class **
// =======================================================
@implementation BTCategoryListService
// =========================================
// ** 初始化 **
// =========================================
/**
 * 初始化
 */
- (id)initWithLastID:(NSInteger)lastID{
    self = [super init];
    if(self) {
        _lastID = lastID;
    }
    return self;
}

/**
 * 配置子类信息
 */
-(NSData*)getPostData {
    self.requestCID = CATEGORY_REQUEST_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[CATEGORY_REQUEST_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:_lastID]	forKey:@"lastid"];		//最后专辑id
    [requestDic setObject:[NSNumber numberWithInteger:pageRequestCount]	forKey:@"percount"];	//拉取条数
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
