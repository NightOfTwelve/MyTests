//
//  BTOneBookStoryListService.h
//  故事分类Tab页下，根据专辑id获得故事列表。
//  cid ＝ 305。
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
@interface BTOneBookStoryListService : BTBaseService {
        NSString            *_albumidID;
    NSInteger                   _lastID;
}
// ==================================
// ** 方法 **
// ==================================
- (id)init;				//初始化
- (id)initWithAlbumidId:(NSString *)ID lastID:(NSInteger)lastID;				//初始化
- (NSData*)getPostData;	//配置子类信息
- (void)dealloc;		//析构
@end
