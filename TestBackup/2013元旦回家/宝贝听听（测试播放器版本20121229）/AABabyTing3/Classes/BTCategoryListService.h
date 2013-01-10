//
//  BTCategoryListService.h
//  故事分类Tab页下，获得分类列表。
//  cid ＝ 303。
//
//  Created by Vicky on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// =======================================================
// ** Import **
// =======================================================
#import <Foundation/Foundation.h>
#import "BTBaseService.h"

// =======================================================
// ** Class **
// =======================================================
@interface BTCategoryListService : BTBaseService {
    NSInteger                   _lastID;
}
// ==================================
// ** 方法 **
// ==================================
- (id)initWithLastID:(NSInteger)lastID;				//初始化
- (NSData*)getPostData;	//配置子类信息
- (void)dealloc;		//析构
@end
