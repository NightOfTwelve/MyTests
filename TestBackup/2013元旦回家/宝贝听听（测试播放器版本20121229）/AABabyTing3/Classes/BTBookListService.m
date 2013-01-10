//
//  BTBookListService.m
//  故事分类Tab页下，根据分类id获得专辑列表。
//  cid ＝ 304。
//
//  Created by Vicky on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// =======================================================
// ** Import **
// =======================================================
#import "BTBookListService.h"
// =======================================================
// ** Class **
// =======================================================
@implementation BTBookListService
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


- (id)initWithCategoryId:(NSString *)aID type:(NSString *)type lastID:(NSInteger)lastID {
    self = [super init];
    if(self){
        _type= [type retain];
        _categoryID = aID;
        _lastID = lastID;
    }
    return  self;
}			//初始化


- (void)dealloc{
    [_type release];
    [super dealloc];
}

/**
 * 配置子类信息
 */
-(NSData*)getPostData {
    self.requestCID = ONECATEGORY_BOOKLIST_REQUSET_NOTIFICATION_CID;
    BTRequestData *rd = [[BTRequestData alloc] initWithCid:[ONECATEGORY_BOOKLIST_REQUSET_NOTIFICATION_CID integerValue]];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:_type	forKey:@"type"];			//类型
	[requestDic setObject:[NSNumber numberWithInteger:[_categoryID intValue]]			forKey:@"typeid"];			//分类id
    [requestDic setObject:[NSNumber numberWithInteger:_lastID]			forKey:@"lastid"];			//最后专辑id
    [requestDic setObject:[NSNumber numberWithInteger:pageRequestCount]			forKey:@"percount"];		//每次拉取条数
    rd.request = requestDic;
	
    NSData *data = [self convertData:rd];
	[rd release];
    return data;	//转换为JSONData
}
@end
