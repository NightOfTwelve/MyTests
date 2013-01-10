//
//  BTBookListService.h
//  故事分类Tab页下，根据分类id获得专辑列表。
//  cid ＝ 304。
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
@interface BTBookListService : BTBaseService {
    
    NSString            *_categoryID;
    NSString            *_type;
    NSInteger           _lastID;
}
// ==================================
// ** 方法 **
// ==================================
- (id)initWithCategoryId:(NSString *)ID type:(NSString *)type lastID :(NSInteger)lastID;				//初始化
- (NSData*)getPostData;	//配置子类信息
- (void)dealloc;		//析构
@end
